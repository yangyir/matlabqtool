function [sig_long, sig_short,sig_rs] = Pvt(ClosePrice,Volume, mu_up, mu_down,type)
% Price Volume Trend ��������ָ��

% PVTָ����㹫ʽ[1]
% �����x��(�������̼ۡ��������̼�)���������̼ۡ����ճɽ�����
% ��ô����PVTָ��ֵ��Ϊ�ӵ�һ����������ÿ��Xֵ���ۼӡ�
% daniel 2013/4/2


%% Ԥ����
if ~exist('mu_up', 'var') || isempty(mu_up), mu_up = 0.02; end
if ~exist('mu_down', 'var') || isempty(mu_down), mu_down = 0.02; end
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
for i = 1: nAsset
[closeHigh, closeLow, closeStat] = LastExtrema(ClosePrice(:,i),mu_up, mu_down);
[pvtHigh,   pvtLow,   pvtStat] = LastExtrema(pvtVal(:,i), mu_up, mu_down);
sig_rs(closeStat== 1 & pvtStat== 1  ,i) = 1;
sig_rs(closeStat==-1 & pvtStat==-1  ,i) =-1;
sig_long(pvtVal(:,i) > pvtHigh  & ClosePrice(:,i)< closeHigh)=1;
sig_short(pvtVal(:,i) <pvtLow  & ClosePrice(:,i) > closeLow) =-1;
end
else
;
end %EOF



