function  [ mfiVal, pmf, nmf ] = mfi(HighPrice, LowPrice, ClosePrice, Volume, nDay )
% money flow index �ʽ�����ָ��
% default nDay  = 14
% 2013/3/21 daniel

% Ԥ����
if ~exist('nDay','var')
    nDay = 14;
end
[nPeriod, nAsset] = size(ClosePrice);
upordown = ones(nPeriod, nAsset);
rmf = nan(nPeriod, nAsset);
pmf = zeros(nPeriod,nAsset);
nmf = zeros(nPeriod, nAsset);
mfiVal = zeros(nPeriod, nAsset);

% ���㲽
% 1.���ͼ۸�TP��=������߼ۡ���ͼ������̼۵�����ƽ��ֵ
% 2.����������MF��=���ͼ۸�TP����N���ڳɽ����
% 3.�������MF>����MF���򽫵��յ�MFֵ��Ϊ������������PMF��
% 4.�������MF<����MF���򽫵��յ�MFֵ��Ϊ������������NMF��
% 5.MFI=100-[100/(1+PMF/NMF)]
% 6.����Nһ����Ϊ14�ա�

tp = (HighPrice + LowPrice + ClosePrice)/3;  %typical price
upordown(tp(2:nPeriod,:)<=tp(1:nPeriod-1,:))=-1; % up or down
rmf(2:nPeriod,:) =  tp(2:nPeriod,:).* Volume(2:nPeriod,:); % raw money flow

pmf(upordown == 1) = rmf(upordown==1);  % positive money Flow
nmf(upordown ==-1) = rmf(upordown==-1); % negative money flow

for iPeriod = nDay:nPeriod
    mfiVal(iPeriod,:) = sum(pmf(iPeriod-nDay+1:iPeriod,:))./sum(nmf(iPeriod-nDay+1:iPeriod,:));
end
mfiVal= 100- 100./(1+mfiVal);

end %EOF


