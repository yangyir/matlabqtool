function [ e ] = place_entrust_opt( obj, direc, volume, offset, px  )
%PLACE_ENTRUST_OPT  ������һ��option�µ�������ʹ��obj.optָ�룬�ṩ������µ�ѡ��
% ֻ�����µ�����������
% [ e ] = place_entrust_opt( obj, direc, volume, offset, px  )
% ���������µ��������Ե����������
% ---------------------------------------------
% cg��20160320
% cg, 20160420, ���ɹ����µ�������pendingEntrusts


%% 
if ~exist('direc', 'var'),    direc = '1';     end
if ~exist('volume','var'),    volume = 1;      end
if ~exist('offset', 'var'),   offset = '1';    end

opt = obj.opt;

% ����quoteOpt
% ��H5������£���Ҫinitʱ����H5����
% ������²�̫��ʱ���þ�ȡ����
% while 1
%     opt.fillQuoteH5;
%     if opt.askQ1>0
%         break;
%     else
%         disp('��Ȩ����δ�ӵ�');
%         pause(1);
%     end
% end

%% �µ�
ctr = obj.counter;
book = obj.book;



% ���entrust, 1��
e = Entrust;
mktNo   = '1';
stkCode = num2str(  opt.code );
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

e.fillEntrust(mktNo, stkCode, direc, px, volume, offset, opt.optName);



% TODO��������ȯ

% �µ�
succ = ems.place_optEntrust_and_fill_entrustNo(e, ctr);

% ���µ��ɹ��������ѵ�������book.pendingEntrusts
if succ
    book.pendingEntrusts.push(e);
else
    fprintf('�µ�ʧ��!\n');
end
% �����Ͳ�����



%% save ��δ���ڴ˴���¼��Ϊ��Ч�ʣ�
% ������book���¼�ˣ�book��ÿһ��entrust�����˼�¼
% ��Ҫ��Ҫ�ڲ����߼����¼
% obj.book.toExcel();





end