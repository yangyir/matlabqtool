function [ sig_out ] = sigLast( sig_in, nBar )
% 该函数让信号持续 n 根K线(包括发出信号的第一根bar）
% 如果在n根K线内出现新的信号，则自动以新的信号开始，前期信号消失
% @daniel 20130604 version 1

[nPeriod, nAsset] = size(sig_in);
sig_out = zeros(nPeriod, nAsset);

for jAsset = 1: nAsset
    count = nBar;
    lastSig = sig_in(1, jAsset);
    for iPeriod = 1: nPeriod
        nowSig = sig_in(iPeriod, jAsset);
        if nowSig~=0
            sig_out(iPeriod, jAsset) = nowSig;
            count = nBar;
            lastSig = nowSig;
        elseif lastSig ~=0 && count>=0
            sig_out(iPeriod, jAsset) = lastSig;
            count = count-1;
        elseif count<0
            lastSig = 0;
        end
    end
end %EOF