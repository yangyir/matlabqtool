function [sig_long, sig_short , sig_rs] = Mtm(ClosePrice, nDay)
% Momemtum ����ָ�� 
% ���� sig_long, sig_short, sig_rs
% sig_long: mtm�Ӹ����� = 1; sig_short: mtm �����为Ϊ0; sig_rs: mtm>0 = 1, mtm <0 = -1;
% nDay ����bar�� Ĭ��= 10
% @author daniel 20130506

%% Ԥ����
if ~exist('nDay','var'),    nDay = 10;end

[nPeriod, nAsset] = size(ClosePrice);
mtmVal = ind.mtm(ClosePrice, nDay);

sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);
sig_rs = zeros(nPeriod, nAsset);

%% �źŲ�
zeroline = zeros(nPeriod, nAsset);
sig_long(logical(crossOver(mtmVal,zeroline)))   =  1;
sig_short(logical(crossOver(zeroline, mtmVal))) = -1;
sig_rs(mtmVal > 0 ) = 1;
sig_rs(mtmVal < 0 ) = -1;

end %EOF