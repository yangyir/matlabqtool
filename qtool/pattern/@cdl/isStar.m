function [ indStar ] = isStar(obj, bars )
%% 
% 《日本蜡烛图技术》，1998年5月第一版，P57
%
%% Parameters
% threshold of the length of first bar
lastLenLimit = 0.01*obj.zoomFactor;
% ratio of the length of first bar and star bar
lenRatio = 0.3;
%%
indLastLen = bars.barLen./bars.open>lastLenLimit;
indLastLen = indLastLen(1:end-1);
indStarLen = bars.barLen(2:end)./bars.barLen(1:end-1)<lenRatio;
% indGap ==1 jump upward; indGap ==-1 jump downward.
indGap = (bars.barFloor(2:end)>bars.barCeil(1:end-1))-(bars.barCeil(2:end)<bars.barFloor(1:end-1));
indJump = indGap.*bars.yinYang(1:end-1)==1;

indStar = indLastLen&indStarLen&indJump;
indStar = [0;indStar];
end

