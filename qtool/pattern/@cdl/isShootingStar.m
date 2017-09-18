function [ indShootingStar ] = isShootingStar(~, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P73
%% parameters
ratioLen = 3;
ratioOverlap = 0.6;
%%
ind1 = bars.lineLenUp>ratioLen*bars.barLen;
ind2 = bars.barLen>ratioLen*bars.lineLenDown;
indJump = bars.barFloor(2:end)>bars.barFloor(1:end-1)+ratioOverlap*bars.barLen(1:end-1);
indJump = vertcat(0,indJump);

indShootingStar = ind1&ind2&indJump;


end

