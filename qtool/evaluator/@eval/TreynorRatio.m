function treynorR = TreynorRatio( navOrRate, benchmark, rf, flag)
% ���������ڼ���Treynor ratio
% navOrRate �ʲ���ֵ�����
% benchmark �г�����ֵ�����
% rf �޷���������
% flag 'val'��ʾ��ֵ��'pct'��ʾ�ٷֱȱ仯��Ĭ��Ϊ'pct'

if nargin < 4
    flag = 'pct';
end

if strcmp( flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
    benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
end

lrf = log(1+rf)/250;
beta = eval.Beta(navOrRate, benchmark);
treynorR = (mean(navOrRate)-lrf)./beta;
end

%{
previous version
function treynorC = treynorCoefficient( R,Rf,betaC )
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

if size(R,1)>1
    treynorC = (mean(R-Rf))/betaC;
else
    treynorC = nan;
end

end
%}
