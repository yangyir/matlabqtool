function [ e ] = place_entrust_opt( obj, direc, volume, offset, px  )
%PLACE_ENTRUST_OPT  ������һ��option�µ�������ʹ��obj.optָ�룬�ṩ������µ�ѡ��
% ֻ�����µ�����������
% [ e ] = place_entrust_opt( obj, direc, volume, offset, px  )
% ���������µ��������Ե����������
% ---------------------------------------------
% cg��20160320


%% 
if ~exist('direc', 'var'),    direc = '1';    end
if ~exist('volume','var'),  volume = 1; end
if ~exist('offset', 'var'),    offset = '1';    end

opt = obj.quote;


%% �µ�
ctr = obj.counter;


% ���entrust, 1��
e = Entrust;
mktNo   = '1';
stkCode = num2str(  opt.code );
nm      = opt.optName;
nm      = nm(end-7:end);   % ��ͬ��'��4��2200'�� Ϊ�˼��
if ~exist('px', 'var')
    % ����quoteOpt
    opt.fillQuote;
    
    % Ĭ��ȡ�Լ�
    if strcmp(direc, '1')
        px = opt.askP1;
    elseif strcmp(direc, '2')
        px = opt.bidP1;
    end
end

e.fillEntrust(mktNo, stkCode, direc, px, volume, offset, nm );



% TODO��������ȯ

% �µ�
% �µ���������ѵ�������pendingEntrusts
ems.place_optEntrust_and_fill_entrustNo(e, ctr);
obj.push_pendingEntrust(e);
    
% �����Ͳ�����


%% save ��δ���ڴ˴���¼��Ϊ��Ч�ʣ�
% ������book���¼�ˣ�book��ÿһ��entrust�����˼�¼
% ��Ҫ��Ҫ�ڲ����߼����¼
% if ~isempty( obj.bookfn )
%     obj.book.toExcel(obj.bookfn);
% else
%     obj.book.toExcel();
% end

end