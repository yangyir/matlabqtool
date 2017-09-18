function [ score ] = momentumStart( bars, pricetype)
%MOMENTUMSTART 封装tgt中的同名函数
% bars            Bars类型数据
% pricetype       str, 'close'(defualt), 'high', 'low' 等
% 判断趋势起点，分数越高越是升势起点，反之降势起点

%% default value
if nargin<2
    pricetype = 'vwap';
end
 

%% main

eval( [ 'price = bars.' pricetype ';']);

score = tgt.momentumStart(price);

end

