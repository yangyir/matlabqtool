function trade_put(obj, direc, volume, offset )
% 使用obj.put交易
% cg，改写，调用通用下单函数trade_opt

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
% % 更新quoteOpt
% % 用H5行情更新，需要init时启动H5行情
% % 行情更新不太及时，好久取不到
% while 1
%     put.fillQuoteH5;
%     if put.askQ1>0
%         break;
%     else
%         disp('期权行情未接到');
%         pause(1);
%     end
% end
% 
% 
% 
% %% 下单
% ctr = obj.counter;
% book = obj.book;
% 
% aimVolume   = volume;
% 
% while aimVolume > 0
%     
%     % 更新quoteOpt
%     % 用H5行情更新，需要init时启动H5行情
%     put.fillQuoteH5;
%     
%     
%     % 填充entrust, 1个
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
%     % TODO：验资验券
%     
%     % 下单
%     % 下单后就立即把单子塞进book.pendingEntrusts
%     ems.HSO32_place_optEntrust_and_fill_entrustNo(e, ctr);
%     book.pendingEntrusts.push(e);
% 
%     
%     % 查询3次，否则撤单 ( 两个单的情况复杂太多了）
%     iter_wait = 1;
%     while ~e.is_entrust_closed
%         if iter_wait > 3
%             ems.HSO32_cancel_optEntrust_and_fill_cancelNo(e, ctr);
%             disp('e进行撤单');
%         end
%         pause(1);
%         ems.HSO32_query_optEntrust_once_and_fill_dealInfo(e, ctr);
%         iter_wait = iter_wait + 1;
%     end
%     
%     % 如果到此，说明该entrust已close，需要记录
%     book.sweep_pending_entrusts;
%     
%     % 同时，准备下一轮下单
%     aimVolume = e.cancelVolume;
% end
% 
% % 上面的while结束，算是一个order真正完成了，记录
% % 不用再book里记录了，book对每一个entrust都做了记录
% % 主要是要在策略逻辑里记录
% if ~isempty( obj.bookfn )
%     obj.book.toExcel(obj.bookfn);
% else
%     obj.book.toExcel();
% end
% 
% end