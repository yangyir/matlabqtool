function sharpeR = SharpeRatio( navOrRate, rf, flag)
% ���������ڼ���sharpe ratio
% navOrRate �ʲ���ֵ�����
% rf �޷���������
% flag 'nav'��ʾ��ֵ������Ϊ����
if nargin < 3
    flag = 'pct';
end

if strcmp( flag, 'val')
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
end
lrf = log(1+rf)/250;
sharpeR = (mean(navOrRate)-lrf)./std(navOrRate);
end

%{
function sharperatio = SharpeRatio( R,Rf)

loc = isnan(R) | isnan(Rf);

R (loc) = [];
Rf(loc) = [];
if size(R,1)>1
    sharperatio = (mean(R-Rf))/std(R);
else
    sharperatio = nan;
end
end
%}
