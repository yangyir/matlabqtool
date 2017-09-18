function [ output_args ] = plotind( obj, idx, drawtype)
%PLOTIND在Ticks上画要显示的点
% [   ] = plotind( obj, idx, drawtype)
%   idx             直接给要画的index， 如 tks.last > 100
%   drawtype        color and shape, eg. '*r'(default)
% ----------------------------------------------------------------
% ver1.0;  Cheng,Gang;     20130409
% ver1.1; Cheng,Gang; 20130411; 加入showcond，对ind的取值范围增大
% ver1.2; Cheng,Gang; 20130411; 只画点，重叠显示的问题在函数外自行解决
% ver1.3; Cheng,Gang; 20130419; show = nan(length(obj.vwap),1); 避免obj.len为空
% 程刚；140731；showcond去掉，直接就用idx作参数

%% pre-process
if ~exist('drawtype','var') drawtype = '*r'; end
 

%% main
% figure
% hold on;

len = length(obj.last);
if len ==0, return; end
    
% draw 1: indicated places
show = nan(len,1);
% eval(['idx = ind' showcond ';'] );
show( idx ) = obj.last( idx );
% eval( [ 'show( ind', showcond, ') = obj.vwap( ind', showcond, ');' ]);
plot(show, drawtype);

end

