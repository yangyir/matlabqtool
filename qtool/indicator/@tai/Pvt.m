function [sig_long, sig_short,sig_rs] = Pvt(ClosePrice,Volume,nBar, type)
% Price Volume Trend ��������ָ��

% PVTָ����㹫ʽ[1]
% �����x��(�������̼ۡ��������̼�)���������̼ۡ����ճɽ�����
% ��ô����PVTָ��ֵ��Ϊ�ӵ�һ����������ÿ��Xֵ���ۼӡ�
% daniel 2013/4/2


%% Ԥ����
if ~exist('nBar', 'var'), nBar = 5; end
if ~exist('type', 'var') || isempty(type), type = 1; end

[nPeriod, nAsset] = size(ClosePrice);
sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);
sig_rs   = zeros(nPeriod, nAsset);




%% ���㲽
[pvtVal] = ind.pvt(ClosePrice,Volume);

%% �źŲ�
% �۸���������PVT������ȷ�ϼ۸�������
% �۸��½�����PVT�½���ȷ�ϼ۸��½���
% �۸���������pvt�½������������Ƽ�����
% �۸��½�����pvt���������½����Ƽ�����
if type==1
    sig_rs( ClosePrice > ind.ma(ClosePrice, nBar) & ind.roc(ClosePrice, nBar) > 0 & pvtVal > ind.ma(pvtVal, nBar)) = 1;
    sig_rs( ClosePrice < ind.ma(ClosePrice, nBar) & ind.roc(ClosePrice, nBar) < 0 & pvtVal < ind.ma(pvtVal,nBar)) = -1;
    sig_long (crossOver(ClosePrice, ind.ma(ClosePrice, nBar))  & ind.roc(ClosePrice, nBar) > 0 & pvtVal > ind.ma(pvtVal, nBar)) = 1;
    sig_short ( crossOver(ind.ma(ClosePrice, nBar), ClosePrice) & ind.roc(ClosePrice, nBar) < 0 & pvtVal < ind.ma(pvtVal,nBar)) = -1;
else
;
end %EOF



