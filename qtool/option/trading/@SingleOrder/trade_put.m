function trade_put(obj, direc, volume, offset )
% ʹ��obj.put����
% cg����д������ͨ���µ�����trade_opt

if ~exist('direc', 'var'),    direc = '1';    end
if ~exist('volume','var'),  volume = 1; end
if ~exist('offset', 'var'),    offset = '1';    end

ori_opt = obj.opt;

obj.opt = obj.put;
obj.trade_opt(direc, volume, offset);

obj.opt = ori_opt;

end

%%
% function trade_put(obj, direc, volume, offset )
% 
% 
% if ~exist('direc', 'var'),    direc = '1';    end
% if ~exist('volume','var'),  volume = 1; end
% if ~exist('offset', 'var'),    offset = '1';    end
% 
% 
% 
% put = obj.put;
% 
% % ����quoteOpt
% % ��H5������£���Ҫinitʱ����H5����
% % ������²�̫��ʱ���þ�ȡ����
% while 1
%     put.fillQuoteH5;
%     if put.askQ1>0
%         break;
%     else
%         disp('��Ȩ����δ�ӵ�');
%         pause(1);
%     end
% end
% 
% 
% 
% %% �µ�
% ctr = obj.counter;
% book = obj.book;
% 
% aimVolume   = volume;
% 
% while aimVolume > 0
%     
%     % ����quoteOpt
%     % ��H5������£���Ҫinitʱ����H5����
%     put.fillQuoteH5;
%     
%     
%     % ���entrust, 1��
%     e = Entrust;
%     mktNo   = '1';
%     stkCode = num2str(    put.code );
%     if strcmp(direc, '1')
%         px      = put.askP1;
%     elseif strcmp(direc, '2')
%         px      = put.bidP1;
%     end
%     vo      = aimVolume;
%     e.fillEntrust(mktNo, stkCode, direc, px, vo, offset);
%     
%     
%     
%     % TODO��������ȯ
%     
%     % �µ�
%     % �µ���������ѵ�������book.pendingEntrusts
%     ems.HSO32_place_optEntrust_and_fill_entrustNo(e, ctr);
%     book.pendingEntrusts.push(e);
% 
%     
%     % ��ѯ3�Σ����򳷵� ( ���������������̫���ˣ�
%     iter_wait = 1;
%     while ~e.is_entrust_closed
%         if iter_wait > 3
%             ems.HSO32_cancel_optEntrust_and_fill_cancelNo(e, ctr);
%             disp('e���г���');
%         end
%         pause(1);
%         ems.HSO32_query_optEntrust_once_and_fill_dealInfo(e, ctr);
%         iter_wait = iter_wait + 1;
%     end
%     
%     % ������ˣ�˵����entrust��close����Ҫ��¼
%     book.sweep_pending_entrusts;
%     
%     % ͬʱ��׼����һ���µ�
%     aimVolume = e.cancelVolume;
% end
% 
% % �����while����������һ��order��������ˣ���¼
% % ������book���¼�ˣ�book��ÿһ��entrust�����˼�¼
% % ��Ҫ��Ҫ�ڲ����߼����¼
% if ~isempty( obj.bookfn )
%     obj.book.toExcel(obj.bookfn);
% else
%     obj.book.toExcel();
% end
% 
% end