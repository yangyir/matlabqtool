function lretExclMax = LretExclMax(navOrRate, flag)
% 扣除最大盈利后的对数收益率
% flag 'val'表示净值，'pct'表示百分比变化。默认为'pct'

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
    % 除以剔除最大值之后的个数
    lretExclMax (iAsset) = lretExclMax (iAsset) / sum(~(navOrRate(:,iAsset)==maxLret(iAsset)));
end

end
%{
 function gainRateExcMaxRet = gainRateExcMax(Account)
% % 扣除最大盈利后收益率,输入参数Account是总资产变动情况
         returnRate=diff(Account)./Account(1:end-1);
         [C,I] = max(returnRate);
         returnRate(I) = [];
         gainRateExcMaxRet = prod(returnRate+1)-1;
     end
%}