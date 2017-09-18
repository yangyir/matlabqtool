function [ sig_ol, sig_cl, sig_os, sig_cs ] = sig2trade( signal )
%% 该函数将持仓信号转化为交易信号
% 输入信号都没有延迟
% 该转化信号函数只针对二项选择式的信号，如SAR

%% 计算开仓情况
[nperiod, nasset]  =  size(signal);

idx_pos  =  find(signal == 1);
idx_neg  =  find(signal ==-1);

if isempty(idx_pos)
    idx_ol = [];
else
    idx_ol    =  find( signal(idx_pos) == 1 & signal(idx_pos - 1) ~= 1 & mod(idx_pos, nperiod) ~= 1);
end

if isempty(idx_neg)
    idx_os = [];
else
    idx_os    =  find( signal(idx_neg) ==-1 & signal(idx_neg - 1) ~=-1 & mod(idx_neg, nperiod) ~= 1);
end

%% 最后一个时间点的处理

%计算平空的情况
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(idx_pos)
    idx_cs =[];
else

if  idx_pos(end) ~= nperiod * nasset
    idx_cs    =  find( signal(idx_pos) == 1 & signal(idx_pos + 1) ~= 1 & mod(idx_pos, nperiod) ~= 0);
else
    if numel(idx_pos) == 1
        idx_cs = [];
    else
        idx_pos_mod  =  idx_pos(1:end-1);
        idx_cs  =  find( (signal(idx_pos_mod) == 1 & signal(idx_pos_mod + 1) ~= 1 & mod(idx_pos_mod, nperiod) ~=0));
    end
end

end


%计算平多的情况
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(idx_neg)
    idx_cl = [];
else

if  idx_neg(end) ~= nperiod * nasset
    idx_cl  =  find( signal(idx_neg) ==-1 & signal(idx_neg + 1) ~=-1 & mod(idx_neg, nperiod) ~= 0);
else
    if numel(idx_neg) == 1;
        idx_cl = [];
    else
        idx_neg_mod  =  idx_neg(1:end-1);
        idx_cl  =  find( (signal(idx_neg_mod) ==-1 & signal(idx_neg_mod + 1) ~=-1 & mod(idx_neg_mod, nperiod) ~=0));
    end
end

end

%% 计算买卖信号

sig_long  =  zeros(nperiod, nasset);
sig_short =  zeros(nperiod, nasset);

sig_ol  =  zeros(nperiod, nasset);
sig_os  =  zeros(nperiod, nasset);
sig_cs  =  zeros(nperiod, nasset);
sig_cl  =  zeros(nperiod, nasset);

% 完成交易信号
if ~isempty(idx_ol)
sig_ol(idx_pos(idx_ol))  =  1;
end
if ~isempty(idx_cs)
sig_cs(idx_pos(idx_cs)+1)  = -1;
end
if ~isempty(idx_os)
sig_os(idx_neg(idx_os))  = -1;
end
if ~isempty(idx_cl)
sig_cl(idx_neg(idx_cl)+1)  =  1;
end

temp  =  sig_cs;
sig_cs  =  sig_cl;
sig_cl  =  temp;

% sig_long  =  sig_ol + sig_cs;
% sig_short =  sig_os + sig_cl;

% sig_trade  =  sig_buy + sig_sell;
% sig_trade(sig_trade > 0) =  1;
% sig_trade(sig_trade < 0) = -1;

end

