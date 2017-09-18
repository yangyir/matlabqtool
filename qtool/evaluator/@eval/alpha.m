function alpha = alpha( navOrRate, benchmark, rf, flag)
% ���������ڼ���alphaϵ��
% navOrRate �ʲ���ֵ�����
% benchmark �г�����ֵ�����
% rf �޷���������
% flag 'val'��ʾ��ֵ��'pct'��ʾ�ٷֱȱ仯��Ĭ��Ϊ'pct'

if nargin < 4
    flag = 'pct';
end

if strcmp(flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
    benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
end

beta = eval.beta( navOrRate, benchmark);
lrf = log(rf + 1)/250;


alpha = mean(navOrRate - lrf) - beta.*(mean(benchmark - lrf));

end
%{
previous version
function alphaC = alphaCoefficient( R,Rm,Rf,betaC)

loc = isnan(R) | isnan(Rf)| isnan(Rm);
R (loc) = [];
Rf(loc) = [];
Rm(loc) = [];
% ���ݲ������nan
if size(R,1)>1
    alphaC = mean(R - Rf) - betaC*(mean(Rm-Rf));
else
    alphaC  =nan;
end
end
%}
