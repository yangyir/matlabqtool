function [k,d,j] = kdjMC(ClosePrice,HighPrice,LowPrice,nday, m, l, maType )
%计算kdj值以及对应的交易信号(-1,0,1)，在原kdj基础上，参照MC写法
%输入
%【数据】ClosePrice,HighPrice,Lowprice
%【参数】 nday移动平均回溯天数（自然数）,type  表示ma计算过程的系数选择方式
%输出，kdj 计算的kdj值
%   version1.0, 2013_10_18, luhuaibao, 与传统kdj不同之处有二：
%               相对原@ind下的指标kdj，添加参数maType，1为简单平滑，2为指数平滑;
%               同时，对原para1,para2,para3,para4参数修改。



%% 预处理
if ~exist('nday','var'), nday = 14; end;
if ~exist('m','var'), m = 3; end;
if ~exist('l','var'), l = 3; end;
if ~exist('maType','var'), maType = 2; end;

%% 计算kdj值
[nPeriod , nAsset] = size(ClosePrice);
k=zeros(nPeriod , nAsset);
d=zeros(nPeriod , nAsset);
j=zeros(nPeriod , nAsset);
for i=1:nAsset
    stosc = stochosc2(HighPrice(:,i), LowPrice(:,i), ClosePrice(:,i), nday, m, l, maType );
    k(:,i)=stosc(:,1);
    d(:,i)=stosc(:,2);
    j(:,i)=stosc(:,3);
end
end

%%
function stosc = stochosc2(highp, lowp, closep, n, m, l, maType )
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

var2 = closep(nzero)-llv(nzero) ;
var3 = hhv(nzero)-llv(nzero) ;
var4 = ind.ma(var2,m,0);
var5 = ind.ma(var3,m,0);

trsv=rsv(nzero);
len=size(trsv,1);
tk=nan(size(trsv));
td=tk;
tj=tk;


para1=(m-1)/(m+1);
para2=2/(m+1);
para3 = (l-1)/l;
para4 = 1/l;

tk(1:n-1,1) = 50 ;
tk(n)=para1*50+para2*trsv(n);
td(n)=para1*50+para2*tk(n);
tj(n)=3*tk(n)-2*td(n);

switch maType
    case 1
        tk = var4./var5*100 ;
        td = ind.ma(tk,l,0);
        tj = 3*td - 2*tk ;
    case 2
        for i=n+1:len
            tk(i)=para1*tk(i-1)+para2*trsv(i);
            td(i)=para3*td(i-1)+para4*tk(i);
            tj(i)=3*td(i)-2*tk(i);
        end;
end;


k(nzero)=tk;
d(nzero)=td;
j(nzero)=tj;
stosc=[k d j];
end