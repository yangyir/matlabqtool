function lretExclMax = LretExclMax(navOrRate, flag)
% �۳����ӯ����Ķ���������
% flag 'val'��ʾ��ֵ��'pct'��ʾ�ٷֱȱ仯��Ĭ��Ϊ'pct'

if nargin < 2
    flag = 'pct';
end

if strcmp( flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
end

maxLret=max(navOrRate);

[~, nAsset]=size(navOrRate);
lretExclMax = zeros(1,nAsset);
for iAsset = 1:nAsset
    lretExclMax (iAsset) = sum(navOrRate(navOrRate(:,iAsset)<maxLret(iAsset),iAsset));
    % �����޳����ֵ֮��ĸ���
    lretExclMax (iAsset) = lretExclMax (iAsset) / sum(~(navOrRate(:,iAsset)==maxLret(iAsset)));
end

end
%{
 function gainRateExcMaxRet = gainRateExcMax(Account)
% % �۳����ӯ����������,�������Account�����ʲ��䶯���
         returnRate=diff(Account)./Account(1:end-1);
         [C,I] = max(returnRate);
         returnRate(I) = [];
         gainRateExcMaxRet = prod(returnRate+1)-1;
     end
%}