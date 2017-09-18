function [ e ] = place_entrust_opt( obj, direc, volume, offset, px  )
%PLACE_ENTRUST_OPT  泛化的一个option下单函数，使用obj.opt指针，提供最宽泛的下单选项
% 只负责下单，其他不管
% [ e ] = place_entrust_opt( obj, direc, volume, offset, px  )
% 其他花样下单函数可以调用这个函数
% ---------------------------------------------
% cg，20160320
% cg, 20160420, 不成功的下单不放入pendingEntrusts


%% 
if ~exist('direc', 'var'),    direc = '1';     end
if ~exist('volume','var'),    volume = 1;      end
if ~exist('offset', 'var'),   offset = '1';    end

opt = obj.opt;

% 更新quoteOpt
% 用H5行情更新，需要init时启动H5行情
% 行情更新不太及时，好久取不到
% while 1
%     opt.fillQuoteH5;
%     if opt.askQ1>0
%         break;
%     else
%         disp('期权行情未接到');
%         pause(1);
%     end
% end

%% 下单
ctr = obj.counter;
book = obj.book;



% 填充entrust, 1个
e = Entrust;
mktNo   = '1';
stkCode = num2str(  opt.code );
if ~exist('px', 'var')
    % 更新quoteOpt
    % 用H5行情更新，需要init时启动H5行情
    opt.fillQuote;
    
    % 默认取对价
    if strcmp(direc, '1')
        px = opt.askP1;
    elseif strcmp(direc, '2')
        px = opt.bidP1;
    end
end

e.fillEntrust(mktNo, stkCode, direc, px, volume, offset, opt.optName);



% TODO：验资验券

% 下单
succ = ems.place_optEntrust_and_fill_entrustNo(e, ctr);

% 如下单成功，立即把单子塞进book.pendingEntrusts
if succ
    book.pendingEntrusts.push(e);
else
    fprintf('下单失败!\n');
end
% 后续就不管了



%% save （未必在此处记录？为了效率）
% 不用再book里记录了，book对每一个entrust都做了记录
% 主要是要在策略逻辑里记录
% obj.book.toExcel();





end