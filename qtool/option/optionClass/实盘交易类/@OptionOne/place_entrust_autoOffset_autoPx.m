function [e] = place_entrust_autoOffset_autoPx( obj, direc, volume, pxType)
%PLACE_ENTRUST_AUTOOFFSET_AUTOPX 下单时，自动计算开平仓，根据pxType下单
% 需要用到仓位
% [e] = place_entrust_autoOffset_autoPx( obj, direc, volume, pxType)  
%   direc： ‘1’买，‘2’卖； 1买， -1卖
%   volume:  正数
%   pxType： 对价oppo（默认），限价持平atpar，last价，mid价
% -----------------------------
% cg, 20160327


%% pre
if ~exist('pxType', 'var')
    pxType = 'oppo';
end
    

%% 读仓位， 算offset
switch direc
    case {'1', 1} % 买
        pos = obj.positionShort;
    case {'2', -1} % 卖
        pos = obj.positionLong;  
end


% 如果下单很大，就直接开新仓
% 否则，关仓
offset = '1'; % 开仓
try
    if volume <= pos.volume
        offset = '2';
    end
catch
end

%% 下单
e = obj.place_entrust_autoPx( direc, volume, offset, pxType );

end

