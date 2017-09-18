function  retExclMax  = RetExclMax(navOrRate, flag)
% �۳����ӯ�����������
% navOrRate �ʲ���ֵ�����
% flag 'val'��ʾ��ֵ��'pct'��ʾ�ٷֱȱ仯��Ĭ��Ϊ'pct'

if nargin < 2
    flag = 'pct';
end

if strcmp(flag, 'val')
    navOrRate = navOrRate(2:end,:)./navOrRate(1:end-1,:) - 1;
end

maxRet=max(navOrRate);
[~, nAsset]=size(navOrRate);

retExclMax = zeros(1,nAsset);
for iAsset = 1:nAsset
    retExclMax(iAsset) = prod(navOrRate(navOrRate(:,iAsset)<maxRet(iAsset),iAsset) + 1);
    retExclMax(iAsset) = retExclMax(iAsset).^(1/sum(~(navOrRate(:,iAsset)==maxRet(iAsset))));
    retExclMax(iAsset) = retExclMax(iAsset) - 1;
end

end

