function [ sig_out ] = sigLast( sig_in, nBar )
% �ú������źų��� n ��K��(���������źŵĵ�һ��bar��
% �����n��K���ڳ����µ��źţ����Զ����µ��źſ�ʼ��ǰ���ź���ʧ
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