function [textrema]=trendextrema(data,mu1,mu2)
%data为输入的时间序列
%mu1为对应的谷值阈值， mu2为对应的峰值阈值
%data为数据
%返回的数值 trendsig 1,0,-1 分别表示上升、振荡、下降
%version 1.00 by zhangyan 2013-4-2
if nargin<3
    mu1=0.02;
    mu2=0.02;
end
pv=zeros(length(data-1),1);

for i=2:length(data-1)
    pv(i)=peakvalley(data,i,mu1,mu2);
end
if ~nnz(pv)
    textrema=zeros(length(data),1);
    return;
end
[textrema,~]=trendseries(pv,data,2);
end