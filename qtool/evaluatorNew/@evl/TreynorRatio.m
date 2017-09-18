function treynorR = TreynorRatio( nav, benchmark, rf)
% ���������ڼ���Treynor ratio
% treynorR = TreynorRatio( nav, benchmark, rf)
% nav �ʲ���ֵ�����
% benchmark �г�����ֵ�����
% rf �޷��������ʡ�Ĭ��5%
% ---------------
% ��һ�� 20150511��д�������nav���������޸Ĳ��ֺ����壨�껯���ݣ�

% if nargin < 4
%     flag = 'pct';
% end
% 
% if strcmp( flag, 'val')
%     navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
%     benchmark = log(benchmark(2:end,:)./benchmark(1:end-1,:));
% end
% 
% lrf = log(1+rf)/250;
% beta = evl.Beta(navOrRate, benchmark);
% treynorR = (mean(navOrRate)-lrf)./beta;
% end

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
%% Ԥ����
if ~exist('rf','var')
    rf = 0.05;
end
%% ��дmain
beta        = evl.beta(nav,benchmark);
treynorR    = (evl.annualYield(nav)-rf) / beta;
end
