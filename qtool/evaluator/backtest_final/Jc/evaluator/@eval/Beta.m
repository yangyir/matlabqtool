function beta = Beta( navOrRate, benchmark, flag)
% ���������ڼ���betaϵ��
% navOrRate �ʲ���ֵ�����
% benchmark �г�����ֵ�����
% flag 'val'��ʾ��ֵ��'pct'��ʾ�ٷֱȱ仯��Ĭ��Ϊ'pct'

if nargin < 3
    flag = 'pct';
end

if strcmp(flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
    benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
end

nAsset = size(navOrRate, 2);
beta = zeros(1,nAsset);

for iAsset = 1:nAsset
    covMatrix=cov(navOrRate(:,iAsset), benchmark);
    beta(iAsset) = covMatrix(1,2)/covMatrix(2,2);
end

end
%{
previous version
function betaC =betaCoefficient( R,Rm)
loc = isnan(R) | isnan(Rm);
R (loc) = [];
Rm (loc) = [];

if size(R,1)>1
    covRRm = cov(R,Rm);
    betaC = covRRm(1,2)/var(Rm);
else
    betaC = nan;
end
end
%}