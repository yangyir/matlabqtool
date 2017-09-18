function [ annYield, annSharpe ] = annualizedYR( obj,initNav )
% ����һ��ʱ���TsRes���껪Yield�� Sharpe
%
% V1.0,���䳬��20131021
% V2.0,���䳬��20131123
%    1. �޸ĳ���Ρ�
% �̸գ�20131203������TsRes��

[tradeDays,dayLastIdx] = unique(floor(obj.time));

numDay = length(tradeDays);
dayNav = obj.nav(dayLastIdx);
dayNav = [initNav;dayNav];
dayYield = log(dayNav(2:end)./dayNav(1:end-1));

annYield = 250*sum(dayYield)/numDay;

annSharpe = annYield/std(dayYield)/sqrt(250);

end

