function openfire_tmp(ctrs, books, call, put, volume, direc, offset, rangbu, proportion)
% ��Counter/��Book�µ����� ctr bookͬʱ�µ� һ����ͬʱ�µ�
% call��Ȩ��put��Ȩ�µ�
% ȡ��ǰS
% ȡ�����K1��K2����ϣ���gamma
% ��ʱ���ֶ�ָ��һ��call�� һ��put
% volume��λ�µ�������
% rangbu���ò����ȣ�ֵ��0, 1��, 0�����������1���ǶԼۣ�Ĭ�ϣ���0.5�����м��
% ���Ʒ� 20170105


%% prepared

if ~exist('direc', 'var'),     direc  = '1';     end
if ~exist('volume','var'),     volume = 1;       end
if ~exist('offset', 'var'),    offset = '1';     end
if ~exist('rangbu', 'var'),    rangbu = 0.8;     end
assert(length(proportion) == length(ctrs));
assert(length(proportion) == length(books));


% ����quoteOpt
% ��H5������£���Ҫinitʱ����H5����
% ������²�̫��ʱ���þ�ȡ����
while 1
    call.fillQuote;
    put.fillQuote;
    if call.askQ1>0 && put.askQ1>0
        break;
    else
        disp('��Ȩ����δ�ӵ�');
        pause(1);
    end
end



%% �µ����� ���Counter��Book����,�����µ�����,ֱ�����еĶ��ɽ�

aimVolumeCall = round(volume * proportion);
aimVolumePut  = round(volume * proportion);
len_counter   = length(ctrs);

while true
    
    % ���н��׳ɽ����
    call_entrust_flag = any(aimVolumeCall);
    put_entrust_flag  = any(aimVolumePut);
    if call_entrust_flag == false && put_entrust_flag == false
        break;
    end
    
    
    % ���Call��ί������
    if call_entrust_flag
        % ����quoteOpt
        call.fillQuote;
        
        % ����orderRef�ж�Book������
        e1    = Entrust;
        e1(1) = [];
        nm    = call.optName(end-6:end);
        mktNo   = '1';
        stkCode = num2str( call.code );
        if strcmp(direc, '1')
            px = call.askP1 * rangbu + call.bidP1 *(1-rangbu);
        elseif strcmp(direc, '2')
            px = call.bidP1 * rangbu + call.askP1*(1-rangbu);
        end
        for len_t = 1:len_counter
            one_aimVolumeCall = aimVolumeCall(len_t);
            if one_aimVolumeCall == 0
                continue;
            else
                % ���в�
                entrust_amount = OptStraddleTradingFusion.split_amount(one_aimVolumeCall);
                % �������ί�е�
                for entrust_t = 1:length(entrust_amount)
                    vo = entrust_amount(entrust_t);
                    entrust_node = Entrust;
                    entrust_node.fillEntrust(mktNo, stkCode, direc, px, vo, offset, nm);
                    entrust_node.orderRef = len_t;
                    e1(end + 1) = entrust_node;
                end
            end
        end
    else
        e1    = Entrust;
        e1(1) = [];
    end

    
    % ���Put��ί������
    if put_entrust_flag
        put.fillQuote;
        
        % ���ί�е�
        e2    = Entrust;
        e2(1) = [];
        nm    = put.optName(end-6:end);
        mktNo   = '1';
        stkCode = num2str( put.code );
        if strcmp(direc, '1')
            px  = put.askP1*rangbu + put.bidP1*(1-rangbu);
        elseif strcmp(direc, '2')
            px  = put.bidP1*rangbu + put.askP1*(1-rangbu);
        end
        for len_t = 1:len_counter
            one_aimVolumePut = aimVolumePut(len_t);
            if one_aimVolumePut == 0
                continue;
            else
                % ���в�
                entrust_amount = OptStraddleTradingFusion.split_amount(one_aimVolumePut);
                for entrust_t = 1:length(entrust_amount)
                    vo = entrust_amount(entrust_t);
                    entrust_node = Entrust;
                    entrust_node.fillEntrust(mktNo, stkCode, direc, px, vo, offset, nm);
                    entrust_node.orderRef = len_t;
                    e2(end + 1) = entrust_node;
                end
            end
        end
    else
        e2    = Entrust;
        e2(1) = [];
    end
    

    % �µ�
    % �µ���������ѵ�������book.pendingEntrusts
    if call_entrust_flag
        for et = 1:length(e1)
            entrust_node = e1(et);
            orderRef = entrust_node.orderRef;
            % ѡ��ctr��book
            ctr  = ctrs{orderRef};
            book = books(orderRef);
            ems.place_optEntrust_and_fill_entrustNo(entrust_node, ctr);
            book.pendingEntrusts.push(entrust_node);
        end
    end
    if put_entrust_flag
        for et = 1:length(e2)
            entrust_node = e2(et);
            orderRef = entrust_node.orderRef;
            % ѡ��ctr��book
            ctr  = ctrs{orderRef};
            book = books(orderRef);
            ems.place_optEntrust_and_fill_entrustNo(entrust_node, ctr);
            book.pendingEntrusts.push(entrust_node);
        end
    end


    
    % ��ѯ3�Σ����򳷵� ( ���������������̫���ˣ�
    iter_wait = 1;
    e1_is_entrust_closed = true;
    e2_is_entrust_closed = true;
    for et = 1:length(e1)
        entrust_node = e1(et);
        e1_is_entrust_closed = e1_is_entrust_closed && entrust_node.is_entrust_closed;
    end
    for et = 1:length(e2)
        entrust_node = e2(et);
        e2_is_entrust_closed = e2_is_entrust_closed && entrust_node.is_entrust_closed;
    end
    
    while ~e1_is_entrust_closed || ~e2_is_entrust_closed
        if iter_wait > 3
            if ~e1_is_entrust_closed
                % ��һ�����ڵļ۸����û�б仯���Ͳ����������򣬳���
                call.fillQuote;
                if strcmp(direc, '1')
                    px = call.askP1 * rangbu + call.bidP1 *(1-rangbu);
                elseif strcmp(direc, '2')
                    px = call.bidP1 * rangbu + call.askP1*(1-rangbu);
                end
                
                if abs(px - e1(1).price) >=0.00005
                    for et = 1:length(e1)
                        entrust_node = e1(et);
                        orderRef = entrust_node.orderRef;
                        ctr      = ctrs{orderRef};
                        ems.cancel_optEntrust_and_fill_cancelNo(entrust_node, ctr);
                    end
                    disp('e1���г���');
                else
                    disp('e1�۸�δ�䣬�����ҵ�');
                end
                
            end
            if ~e2_is_entrust_closed
                put.fillQuote;
                if strcmp(direc, '1')
                    px  = put.askP1*rangbu + put.bidP1*(1-rangbu);
                elseif strcmp(direc, '2')
                    px  = put.bidP1*rangbu + put.askP1*(1-rangbu);
                end
                
                if abs( px - e2(1).price ) >=0.00005
                    for et = 1:length(e2)
                        entrust_node = e2(et);
                        orderRef = entrust_node.orderRef;
                        ctr      = ctrs{orderRef};
                        ems.cancel_optEntrust_and_fill_cancelNo(entrust_node, ctr);
                    end
                    disp('e2���г���');
                else
                    disp('e2�۸�δ�䣬�����ҵ�');
                end
            end
        end
        pause(1);
        
        if isempty(e1)
        else
            for et = 1:length(e1)
                entrust_node = e1(et);
                orderRef = entrust_node.orderRef;
                ctr      = ctrs{orderRef};
                ems.query_optEntrust_once_and_fill_dealInfo(entrust_node, ctr);
            end
        end
        
        if isempty(e2)
        else
            for et = 1:length(e2)
                entrust_node = e2(et);
                orderRef = entrust_node.orderRef;
                ctr      = ctrs{orderRef};
                ems.query_optEntrust_once_and_fill_dealInfo(entrust_node, ctr);
            end
        end
        
        iter_wait = iter_wait + 1;
        
        % �鿴�Ƿ��Ѿ���ȫ�ɽ�
        e1_is_entrust_closed = true;
        e2_is_entrust_closed = true;
        for et = 1:length(e1)
            entrust_node = e1(et);
            e1_is_entrust_closed = e1_is_entrust_closed && entrust_node.is_entrust_closed;
        end
        for et = 1:length(e2)
            entrust_node = e2(et);
            e2_is_entrust_closed = e2_is_entrust_closed && entrust_node.is_entrust_closed;
        end
    end
    
    % ������ˣ�˵����entrust��close����Ҫ��¼
    for len_t = 1:len_counter
        books(len_t).sweep_pendingEntrusts;
    end

    
    % ͬʱ��׼����һ���µ�
    aimVolumeCall = zeros(1, len_counter);
    aimVolumePut  = zeros(1, len_counter);
    for et = 1:length(e1)
        entrust_node = e1(et);
        orderRef = entrust_node.orderRef;
        aimVolumeCall(orderRef) = aimVolumeCall(orderRef) + entrust_node.cancelVolume;
    end
    for et = 1:length(e2)
        entrust_node = e2(et);
        orderRef = entrust_node.orderRef;
        aimVolumePut(orderRef) = aimVolumePut(orderRef) + entrust_node.cancelVolume;
    end
end
% �����while����������һ��order��������ˣ���¼
% ������book���¼�ˣ�book��ÿһ��entrust�����˼�¼
% ��Ҫ��Ҫ�ڲ����߼����¼
% obj.book.toExcel;











end