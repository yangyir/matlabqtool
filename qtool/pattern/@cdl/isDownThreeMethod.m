function [ indDownThreeMethod ] = isDownThreeMethod( obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P141
%% parameters
lenLimit = 0.01*obj.zoomFactor;
%%
indFirst = (bars.yinYang==-1)&(bars.barLen./bars.open>lenLimit);
indFirst = indFirst(1:end-4);

indLadder = (bars.barFloor(2:end-3)<bars.barFloor(3:end-2))&(bars.barFloor(3:end-2)<bars.barFloor(4:end-1));
indEmbrace = (bars.high(1:end-4)>bars.high(4:end-1))&(bars.low(1:end-4)<bars.low(2:end-3));

indLast = (bars.yinYang(5:end)==-1)&(bars.close(5:end)<bars.close(1:end-4))&(bars.open(5:end)<bars.close(4:end-1));

indDownThreeMethod = indFirst&indLadder&indEmbrace&indLast;


pSize = 5;
indDownThreeMethod = [zeros(pSize-1,1);indDownThreeMethod];
end

