function [ score ] = momentumStart( bars, pricetype)
%MOMENTUMSTART ��װtgt�е�ͬ������
% bars            Bars��������
% pricetype       str, 'close'(defualt), 'high', 'low' ��
% �ж�������㣬����Խ��Խ��������㣬��֮�������

%% default value
if nargin<2
    pricetype = 'vwap';
end
 

%% main

eval( [ 'price = bars.' pricetype ';']);

score = tgt.momentumStart(price);

end

