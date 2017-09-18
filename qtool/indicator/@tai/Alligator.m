function [sig_long, sig_short] = Alligator(HighPrice,LowPrice,ClosePrice, fast, mid, slow, delta,type)
%计算alligator方法对应的交易信号(-1,0,1)
%输入 
%【数据】ClosePrice,HighPrice
%【参数】 判决相对高低的阈值delta=0.01;
% 输出 
%pos 交易信号，以及alligator三条均线值 linegreen linered lineblue 分别为 5日 8日 13日sma
%   Yan Zhang   version 1.0 2013/3/12
%
%延时小的线比延时大的线相对高出一个阈值，sig_long信号为1
%延时大的线比延时小的线相对低出一个阈值, sig_short信号为-1
%Yan Zhang   version 1.1 2013/3/21

%% 预处理
if nargin <3
    error('not enough input');
end

if ~exist('delta','var') || isempty(delta), delta = 0.01; end
if ~exist('type','var') || isempty(type), type = 1; end
if ~exist('fast', 'var') || isempty(fast), fast = 3; end
if ~exist('mid', 'var') || isempty(mid), mid = 7; end
if ~exist('slow', 'var') || isempty(slow), slow = 15; end


%%  计算Alligator数值

[nPeriod , nAsset] = size(LowPrice);
[line1 line2 line3]= ind.alligator(HighPrice,LowPrice, fast, mid, slow);
%%   计算信号
sig_long=zeros(nPeriod,nAsset);
sig_short=zeros(nPeriod,nAsset);
if type==1
%      for jAsset=1:nAsset
%         sig_long(1:end-1, jAsset) = (line1(1:end-1,jAsset)<line2(1:end-1,jAsset) &  line1(2:end,jAsset)>line2(2:end,jAsset)) & (line2(1:end-1,jAsset)<line3(1:end-1,jAsset) &  line2(2:end,jAsset)>line3(2:end,jAsset)) 
%         sig_short(1:end-1, jAsset) = (line1(1:end-1,jAsset)>line2(1:end-1,jAsset) &  line1(2:end,jAsset)<line2(2:end,jAsset)) & (line2(1:end-1,jAsset)>line3(1:end-1,jAsset) &  line2(2:end,jAsset)<line3(2:end,jAsset)) 
%     end
    for j=1:nAsset
    for i=1:nPeriod
        if (ClosePrice(i,j)/line1(i,j)-1>delta) && (line1(i,j)/line2(i,j)-1>delta) && (line2(i,j)/line3(i,j)-1>delta)
            sig_long(i,j)=1;
        elseif (ClosePrice(i,j)/line1(i,j)-1<-delta) && (line1(i,j)/line2(i,j)-1<-delta) && (line2(i,j)/line3(i,j)-1<-delta)
            sig_short(i,j)=-1;
        end
    end
    end
else
    for j=1:nAsset
    for i=1:nPeriod
        if (ClosePrice(i,j)/line1(i,j)-1>delta) && (line1(i,j)/line2(i,j)-1>delta) && (line2(i,j)/line3(i,j)-1>delta)
            sig_long(i,j)=1;
        elseif (ClosePrice(i,j)/line1(i,j)-1<-delta) && (line1(i,j)/line2(i,j)-1<-delta) && (line2(i,j)/line3(i,j)-1<-delta)
            sig_short(i,j)=-1;
        end
    end
    end
end

