function [ e ] = place_entrust_opt( obj, direc, volume, offset, px  )
%PLACE_ENTRUST_OPT  泛化的一个option下单函数，使用obj.opt指针，提供最宽泛的下单选项
% 只负责下单，其他不管
% [ e ] = place_entrust_opt( obj, direc, volume, offset, px  )
% 其他花样下单函数可以调用这个函数
% ---------------------------------------------
% cg，20160320


%% 
if ~exist('direc', 'var'),    direc = '1';    end
if ~exist('volume','var'),  volume = 1; end
if ~exist('offset', 'var'),    offset = '1';    end

opt = obj.quote;


%% 下单
ctr = obj.counter;


% 填充entrust, 1个
e = Entrust;
mktNo   = '1';
stkCode = num2str(  opt.code );
nm      = opt.optName;
nm      = nm(end-7:end);   % 形同：'沽4月2200'， 为了简洁
if ~exist('px', 'var')
    % 更新quoteOpt
    opt.fillQuote;
    
    % 默认取对价
    if strcmp(direc, '1')
        px = opt.askP1;
    elseif strcmp(direc, '2')
        px = opt.bidP1;
    end
end

e.fillEntrust(mktNo, stkCode, direc, px, volume, offset, nm );



% TODO：验资验券

% 下单
% 下单后就立即把单子塞进pendingEntrusts
ems.place_optEntrust_and_fill_entrustNo(e, ctr);
obj.push_pendingEntrust(e);
    
% 后续就不管了


%% save （未必在此处记录？为了效率）
% 不用再book里记录了，book对每一个entrust都做了记录
% 主要是要在策略逻辑里记录
% if ~isempty( obj.bookfn )
%     obj.book.toExcel(obj.bookfn);
% else
%     obj.book.toExcel();
% end

end