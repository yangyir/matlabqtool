function [obj] = autocalc( obj )
%AUTOCALC calculates derived properties of a Bars instance
% i.e.    barCeil;
%         barFloor;
%         barLen;
%         lineLenUp;
%         lineLenDown;
%         yinYang;
%         avgHL;
%         avgOC;
%         avgHLOC;
% ----------------------------------------
% ver1.0    Cheng,Gang      20130408 
% ver1.1;   Cheng,Gang;     20130418; 加入avgHL，avgOC，avgHLOC   
% ver1.2;   Cheng,Gang;     20131231; 去掉不用的域
% 
% obj.barCeil     = max( obj.open, obj.close);
% obj.barFloor    = min( obj.open, obj.close);
% obj.barLen      = abs(obj.open - obj.close);
% obj.lineLenUp   = obj.high - obj.barCeil;
% obj.lineLenDown = obj.barFloor - obj.low;
% obj.yinYang     = (obj.close > obj.open)*2-1;
% obj.avgHL       = (obj.high + obj.low)/2;
% obj.avgOC       = (obj.open + obj.close)/2;
% obj.avgHLOC     = (obj.avgHL + obj.avgOC)/2;

% for future:  change of open interest
% obj.dOpenInt    = [nan; diff(obj.openInt)];

% hidden
obj.len = length(obj.close);
end

