function [sig_long, sig_short] = Ac(HighPrice,LowPrice,nDay,mDay, type)
%accelerator oscillator  返回交易信号(-1,0,1)
%输入
% 【数据】HighPrice, LowPrice （时间 X 股票矩阵）
% 【参数】nDay, mDay 快速和慢速移动平均回溯天数 （自然数）
%   Yan Zhang   version 1.0 2013/3/12

%% 预处理
if ~exist('nDay', 'var') || isempty(nDay), nDay = 5; end
if ~exist('mDay', 'var') || isempty(mDay), mDay = 34; end
if ~exist('type', 'var') || isempty(type), type = 1; end

[nPeriod , nAsset] = size(LowPrice);
acVal=zeros(nPeriod , nAsset);
sig_long = zeros(nPeriod , nAsset);
sig_short= zeros(nPeriod , nAsset);

if nDay > mDay %避免快慢速日期输入错误
    temp = nDay;
    nDay = mDay;
    mDay = temp;
    clear temp;
end


[acVal] = ind.aco(HighPrice,LowPrice,nDay,mDay);

%% 信号步
%sig_long,sig_short
%如果在零点线之上，有两条绿色买;
%如果在零点线之下，有三条绿色买;
%如果在零点线之上，有三条红色卖;
%如果在零点线之下，有两条红色卖.

% difac 正数时用绿色表示，为负数时用红色表示
if type == 1
    difac=acVal(2:end,:)-acVal(1:end-1,:);
    difac=[zeros(1,nAsset);difac]; 
    zeroline=0;
    for i=1:nAsset
        for j=3:nPeriod-1
            if acVal(j,i)<zeroline && acVal(j-1,i)<zeroline
                if acVal(j-2,i)<zeroline &&  difac(j,i)>0 && difac(j-1,i)>0 && difac(j-2,i)<0
                    sig_long(j,i)=1;
                elseif difac(j,i)<0 && difac(j-1,i)<0
                    sig_short(j,i)=-1;
                end
            elseif acVal(j,i)>zeroline && acVal(j-1,i)>zeroline
                if acVal(j-2,i)>zeroline &&  difac(j,i)<0 && difac(j-1,i)<0 && difac(j-2,i)<0
                    sig_short(j,i)=-1;
                elseif difac(j,i)>0 && difac(j-1,i)>0
                    sig_long(j,i)=1;
                end
            end
        end
    end
else
end
end %EOF
 