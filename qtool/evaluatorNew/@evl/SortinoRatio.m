function sortinoR = SortinoRatio( nav, benchmark,rf)
% ���������ڼ���sortino ratio
% sortinoR = SortinoRatio( nav, rf)
% % navOrRate �ʲ���ֵ�����
% % rf �޷���������
% % flag 'val'��ʾ��ֵ��'pct'��ʾ�ٷֱȱ仯��Ĭ��Ϊ'pct'
% ----------------
% ��һ�Σ�20150511 �������޸�Ϊ��������nav��rfĬ��Ϊ0.05,���޸��˲��ֺ����壺��Ҫ��ʹ���껯����

% if nargin < 3
%     flag = 'pct';
% end
% 
% if strcmp( flag, 'val')
%     navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
% end
% 
% lrf = log(1+rf)/250;
% 
% sortinoR = (mean(navOrRate)-lrf)./sqrt(lpm(navOrRate, lrf, 2));
% end

%{
function  SoRa  = sortinoRatio( R,Rf )
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

difRR = R - Rf;
lenTR = length(R);
sTRR = 0;
for i =1:lenTR
    baseRR = min(difRR(i),0);
    sTRR = sTRR + baseRR^2;
end

DDex = sqrt(sTRR/(lenTR-1));
SoRm = mean(R-Rf)/DDex;
SoRa = SoRm*sqrt(250);

end
%}


%% Ԥ����
if ~exist('rf','var')
    rf = 0.05;
end

%% ��дmain

Rate    = evl.nav2yield(nav);
benchmarkAnnualYield    = evl.annualYield(benchmark);
sortinoR = (evl.annualYield(nav)-benchmarkAnnualYield)./sqrt(lpm(Rate, benchmarkAnnualYield, 2));

end
