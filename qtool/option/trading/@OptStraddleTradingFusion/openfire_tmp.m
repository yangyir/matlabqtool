function openfire_tmp(ctrs, books, call, put, volume, direc, offset, rangbu, proportion)
% 多Counter/多Book下单情形 ctr book同时下单 一次性同时下单
% call期权和put期权下单
% 取当前S
% 取最近的K1，K2，组合，算gamma
% 暂时：手动指定一个call， 一个put
% volume单位下单的数量
% rangbu：让步幅度，值域【0, 1】, 0就是用最不利，1就是对价（默认），0.5就是中间价
% 吴云峰 20170105


%% prepared

if ~exist('direc', 'var'),     direc  = '1';     end
if ~exist('volume','var'),     volume = 1;       end
if ~exist('offset', 'var'),    offset = '1';     end
if ~exist('rangbu', 'var'),    rangbu = 0.8;     end
assert(length(proportion) == length(ctrs));
assert(length(proportion) == length(books));


% 更新quoteOpt
% 用H5行情更新，需要init时启动H5行情
% 行情更新不太及时，好久取不到
while 1
    call.fillQuote;
    put.fillQuote;
    if call.askQ1>0 && put.askQ1>0
        break;
    else
        disp('期权行情未接到');
        pause(1);
    end
end



%% 下单规则 多个Counter多Book下面,首先下单操作,直到所有的都成交

aimVolumeCall = round(volume * proportion);
aimVolumePut  = round(volume * proportion);
len_counter   = length(ctrs);

while true
    
    % 所有交易成交完毕
    call_entrust_flag = any(aimVolumeCall);
    put_entrust_flag  = any(aimVolumePut);
    if call_entrust_flag == false && put_entrust_flag == false
        break;
    end
    
    
    % 填充Call的委托序列
    if call_entrust_flag
        % 更新quoteOpt
        call.fillQuote;
        
        % 基于orderRef判断Book的序列
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
                % 进行拆单
                entrust_amount = OptStraddleTradingFusion.split_amount(one_aimVolumeCall);
                % 进行填充委托单
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

    
    % 填充Put的委托序列
    if put_entrust_flag
        put.fillQuote;
        
        % 填充委托单
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
                % 进行拆单
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
    

    % 下单
    % 下单后就立即把单子塞进book.pendingEntrusts
    if call_entrust_flag
        for et = 1:length(e1)
            entrust_node = e1(et);
            orderRef = entrust_node.orderRef;
            % 选择ctr和book
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
            % 选择ctr和book
            ctr  = ctrs{orderRef};
            book = books(orderRef);
            ems.place_optEntrust_and_fill_entrustNo(entrust_node, ctr);
            book.pendingEntrusts.push(entrust_node);
        end
    end


    
    % 查询3次，否则撤单 ( 两个单的情况复杂太多了）
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
                % 查一下现在的价格，如果没有变化，就不撤单，否则，撤单
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
                    disp('e1进行撤单');
                else
                    disp('e1价格未变，继续挂单');
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
                    disp('e2进行撤单');
                else
                    disp('e2价格未变，继续挂单');
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
        
        % 查看是否已经完全成交
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
    
    % 如果到此，说明该entrust已close，需要记录
    for len_t = 1:len_counter
        books(len_t).sweep_pendingEntrusts;
    end

    
    % 同时，准备下一轮下单
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
% 上面的while结束，算是一个order真正完成了，记录
% 不用再book里记录了，book对每一个entrust都做了记录
% 主要是要在策略逻辑里记录
% obj.book.toExcel;











end