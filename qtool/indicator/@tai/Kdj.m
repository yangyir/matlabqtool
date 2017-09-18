function [sig_long,sig_short,sig_rs] = Kdj(ClosePrice,HighPrice,LowPrice,thred1, thred2, nday,m, l, type)
%计算kdj值以及对应的交易信号(-1,0,1)
%输入
%【数据】ClosePrice,HighPrice,Lowprice
%【参数】 nday移动平均回溯天数（自然数）,type  表示ma计算过程的系数选择方式 
%type 1 [2/3 1/3] type 2 [(n-1)/n 1/n]
%输出交易信号
%   Yan Zhang   version 1.0 2013/3/12 

%   sig_long  当K上穿30时，买入，信号为1 当信号为1且K在thred2以下，K，D产生死叉，信号改为-1 
%   sig_short 当K下穿thred2时，卖出，信号为-1 当信号为-1且K在30以上，K，D产生死叉，信号改为-1 
%   sig_rs   K<30，超卖，信号为1，K〉thred2，超买，信号为-1
%   Yan Zhang   version 1.1 2013/3/12 
%   lu huaibao   version 1.2 2013/08/29,把30和70修改成thred1和thred2，注释掉预处理下的前三行，因为默认参数很多。

%% 预处理
% if nargin <3
%     error('not enough input');
% end
if ~exist('nday', 'var') || isempty(nday), nday = 9; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 计算kdj值 
[nPeriod , nAsset] = size(ClosePrice);
[k,d] = ind.kdj(ClosePrice,HighPrice,LowPrice,nday, m, l);
 %% 计算信号
 if type==1
    sig_long=zeros(size(ClosePrice));
    sig_short=sig_long;
    sig_long(2:end,:)=((k(2:end,:)>thred1) & (k(1:end-1,:)<thred1));
    sig_short(2:end,:)=((k(2:end,:)<thred2) & (k(1:end-1,:)>thred2))*(-1);
    sig_rs=k<thred1+(k>thred2)*(-1);
 else
     sig_long=zeros(size(ClosePrice));
     sig_short=sig_long;
     sig_long(2:end,:)=((k(2:end,:)>thred1) & (k(1:end-1,:)<thred1));
     sig_short(2:end,:)=((k(2:end,:)<thred2) & (k(1:end-1,:)>thred2))*(-1);

     for i=1:nAsset
        for j=2:nPeriod-1
            if sig_long(j-1,i)==1 && k(j,i)<thred2 && k(j-1,i)>d(j-1,i) && k(j+1,i)<d(j+1,i)
                 sig_long(j,i)=-1;
            elseif sig_short(j-1,i)==-1 && k(j,i)>thred1 && k(j-1,i)<d(j-1,i) && k(j+1,i)>d(j+1,i)
                 sig_short(j,i)=1;
            end;
        end
     end
    sig_rs=k<thred1+(k>thred2)*(-1);
end
