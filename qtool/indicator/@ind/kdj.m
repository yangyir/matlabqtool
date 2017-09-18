function [k,d,j] = kdj(ClosePrice,HighPrice,LowPrice,nday, m, l)
%计算kdj值以及对应的交易信号(-1,0,1)
%输入
%【数据】ClosePrice,HighPrice,Lowprice
%【参数】 nday移动平均回溯天数（自然数）,type  表示ma计算过程的系数选择方式
%输出，kdj 计算的kdj值
%   Yan Zhang   version 1.0 2013/3/12



%% 预处理
if nargin <3
    error('not enough input');
end

if nargin<4
nday=9;
m = 3; l = 3;
end

%% 计算kdj值
[nPeriod , nAsset] = size(ClosePrice);
 k=zeros(nPeriod , nAsset);
 d=zeros(nPeriod , nAsset);
 j=zeros(nPeriod , nAsset);
for i=1:nAsset
    stosc = stochosc2(HighPrice(:,i), LowPrice(:,i), ClosePrice(:,i), nday, m, l);
    k(:,i)=stosc(:,1);
    d(:,i)=stosc(:,2);
    j(:,i)=stosc(:,3);
end
end

%%
function stosc = stochosc2(highp, lowp, closep, n, m, l)
%n>nnz(nzero),return ;
%Yan Zhang   version 1.1 2013/3/22
rsv        = nan(size(closep));
llv         = llow(lowp, n);
hhv         = hhigh(highp, n);

nzero       = find((hhv-llv) ~= 0);
k=nan(size(rsv));
d=k;
j=d;
if length(nzero)<=n
    stosc=[k d j];
    return;
end
rsv(nzero) = ((closep(nzero)-llv(nzero))./(hhv(nzero)-llv(nzero))) * 100;
trsv=rsv(nzero);
len=size(trsv,1);
tk=nan(size(trsv));
td=tk;
tj=tk;


    para1=(m-1)/m;
    para2=1/m;
    para3 = (l-1)/l;
    para4 = 1/l;

        tk(n)=para1*50+para2*trsv(n);
         td(n)=para1*50+para2*tk(n);
         tj(n)=3*tk(n)-2*td(n);
     for i=n+1:len
         tk(i)=para1*tk(i-1)+para2*trsv(i);
         td(i)=para3*td(i-1)+para4*tk(i);
         tj(i)=3*td(i)-2*tk(i);
     end

k(nzero)=tk;
d(nzero)=td;
j(nzero)=tj;
stosc=[k d j];
end

