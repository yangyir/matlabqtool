function [e] = trade_opt(obj, direc, volume, offset, px )
% ������һ��option�µ�������ʹ��obj.optָ�룬�ṩ��������µ�ѡ��
%  trade_opt(obj, direc, volume, offset, px )
% ���������µ��������Ե����������
% ---------------------------------------------
% cg��20160320


%% 
if ~exist('direc', 'var'),    direc = '1';      end
if ~exist('volume','var'),     volume = 1;      end
if ~exist('offset', 'var'),    offset = '1';    end

opt = obj.opt;

% ����quoteOpt
% ��H5������£���Ҫinitʱ����H5����
% ������²�̫��ʱ���þ�ȡ����
while 1
    opt.fillQuote;
    if opt.askQ1>0
        break;
    else
        disp('��Ȩ����δ�ӵ�');
        pause(1);
    end
end



%% �µ�
ctr = obj.counter;
book = obj.book;

aimVolume   = volume;

while aimVolume > 0
    
    % ���entrust, 1��
    e = Entrust;
    mktNo   = '1';
    stkCode = num2str(    opt.code );
    if ~exist('px', 'var')
        % ����quoteOpt
        % ��H5������£���Ҫinitʱ����H5����
        opt.fillQuote;
        
        % Ĭ��ȡ�Լ�
        if strcmp(direc, '1')
            px = opt.askP1;
        elseif strcmp(direc, '2')
            px = opt.bidP1;
        end
    end
    
    vo      = aimVolume;
    e.fillEntrust(mktNo, stkCode, direc, px, vo, offset);
    
    
    
    % TODO��������ȯ
    
    % �µ�
    % �µ���������ѵ�������book.pendingEntrusts
    ems.place_optEntrust_and_fill_entrustNo(e, ctr);
    book.pendingEntrusts.push(e);

    
    % ��ѯ3�Σ����򳷵� 
    iter_wait = 1;
    while ~e.is_entrust_closed
        if iter_wait > 3
            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
            disp('e���г���');
        end
        pause(1);
        ems.query_optEntrust_once_and_fill_dealInfo(e, ctr);
        iter_wait = iter_wait + 1;
    end
    
    % ������ˣ�˵����entrust��close����Ҫ��¼
    book.sweep_pendingEntrusts;
    
    % ͬʱ��׼����һ���µ�
    aimVolume = e.cancelVolume;
end


%% save
% �����while����������һ��order��������ˣ���¼
% ������book���¼�ˣ�book��ÿһ��entrust�����˼�¼
% ��Ҫ��Ҫ�ڲ����߼����¼






end