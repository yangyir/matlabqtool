function [ e ] = place_entrust_autoOffset( obj, direc, volume, px )
%PLACE_ENTRUST_AUTOOFFSET 下单时，根据position自动判断开平仓
% 约定：当volume较大时，可能拆成一部分平仓，一部分开仓， 这样，不如就开仓
% [ e ] = place_entrust_autoOffset( obj, direc, volume, px )
%   direc： ‘1’买，‘2’卖； 1买， -1卖
%   volume:  正数
% -----------------------------------
% cg, 20160327


%% pre
% 读仓位
switch direc
    case {'1', 1, 'b', 'buy'} % 买
        pos = obj.positionShort;
    case {'2', -1, 's', 'sell'} % 卖
        pos = obj.positionLong;  
end


%% main
offset = '1'; 

% 如果下单低于持仓，就可以关仓

% 加一个容错数量，因为现在挂单不改变pos.volume， 假设已挂出tolerance张
% 只是暂时解决方案。长久之计，是加Position.volumeSellable
tolerance = 10; 

try
    if volume <= pos.volume - tolerance
        offset = '2';
    end
catch
end


e = obj.place_entrust_opt( direc, volume, offset, px );




end

