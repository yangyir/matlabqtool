function [ newbars ] = fixbase( obj, value )
%FIXBASE 针对bars.open(1)进行定基，除法
%  value        定基除数，默认value = obj.vwap(1)

%% pre-process

if ~exist('value', 'var') value = obj.vwap(1); end

%% main
newbars = Bars;

% 不变量
newbars.type      = obj.type;
newbars.time      = obj.time;
newbars.volume    = obj.volume;
newbars.amount    = obj.amount;
newbars.openInterest = obj.openInterest;

%定基量
newbars.open  = obj.open  / value;
newbars.close = obj.close / value;
newbars.high  = obj.high  / value;
newbars.low   = obj.low   / value;
newbars.vwap  = obj.vwap  / value;


end

