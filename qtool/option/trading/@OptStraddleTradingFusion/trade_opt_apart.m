function trade_opt_apart(obj, direc, volume, offset, px)
% 基于trade_opt的拆单下单操作
% trade_opt_apart(obj, direc, volume, offset, px)
% wyf 20161229

% 预先判断
if ~exist('direc', 'var'),     direc = '1';     end
if ~exist('volume','var'),     volume = 1;      end
if ~exist('offset', 'var'),    offset = '1';    end


% 拆单操作
entrust_amounts = obj.split_amount(volume);


% 开火下单操作
if ~exist('px', 'var')
    for entrust_t = 1:length(entrust_amounts)
        entrust_amount = entrust_amounts(entrust_t);
        obj.trade_opt(direc, entrust_amount, offset);
    end
else
    for entrust_t = 1:length(entrust_amounts)
        entrust_amount = entrust_amounts(entrust_t);
        obj.trade_opt(direc, entrust_amount, offset, px);
    end
end








end