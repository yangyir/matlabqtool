function [line1, line2, line3] = alligator(HighPrice,LowPrice, fast, mid, slow)
%计算alligator方法
%输入 
%【数据】LowPrice,HighPrice
% 输出 
%alligator三条均线值 linegreen linered lineblue 分别为 5日 8日 13日sma
%   Yan Zhang   version 1.0 2013/4/22
%
%Yan Zhang   version 1.1 2013/3/21

%% 预处理
if nargin <2
    error('not enough input');
end



%%  计算Alligator数值

[nPeriod , nAsset] = size(LowPrice);
 line1=zeros(nPeriod , nAsset);
 line2=zeros(nPeriod , nAsset);
 line3=zeros(nPeriod , nAsset);
for i=1:nAsset 

    highp=HighPrice(:,i);
    lowp=LowPrice(:,i);    
    med=(highp+lowp)/2;
    tline1=nan(size(med));
    tline2=nan(size(med));
    tline3=nan(size(med));
    med=med';
    ttline1=tsmovavg(med, 's', fast);
    ttline2=tsmovavg(med, 's', mid);
    ttline3=tsmovavg(med, 's', slow);
    tline1( fast-1:end)=ttline1(1:nPeriod-fast+ 2);
    tline2( mid -2:end)=ttline2(1:nPeriod-mid + 3);
    tline3( slow-4:end)=ttline3(1:nPeriod-slow+ 5);
    line1(:,i)=tline1;
    line2(:,i)=tline2;
    line3(:,i)=tline3;
    clear tline1 tline2 tline3 ttline1 ttline2 ttline3
end