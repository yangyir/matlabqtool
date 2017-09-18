function [FluxInd, TrendInd] = GuppyTrendIdentify(bars, period1, period2, period3, period4, period5, tol)
% v1.0 Yang Xi
% ���ù˱�ratio���������ƻ���
% bars��5��period��������˱�ratio
% tol�ǵ���ContinFilter���ƹ���ʱ��������Ŀ�����ֵ
% FluxInd����bars�������׶ε�����
% TrendInd�������ƽ׶ε�����
% ��������Ĳο�ֵ�����ڷ������� period1 = 10,period2 = 20,period3 = 60,period4 = 120,
% period5 = 240, tol = 30~60
if ~exist('period1','var'), period1 = 10; end;
if ~exist('period2','var'), period2 = 20; end;
if ~exist('period3','var'), period3 = 60; end;
if ~exist('period4','var'), period4 = 120; end;
if ~exist('period5','var'), period5 = 240; end;
if ~exist('tol','var'), tol = 60; end;
GuppyRatio = marketstatus.GuppyMMA(bars, period1, period2, period3, period4, period5);
FluxThrshld = prctile(GuppyRatio,25);
Fluxsignal = (GuppyRatio<FluxThrshld);
[~, Trendsignal] = marketstatus.ContinFilter(1-Fluxsignal,tol); % �ȶ������źŽ��й��ˣ������ڸ������źŽ����
NewFluxsignal = (Trendsignal == 0); 
[~, NewFluxsignal] = marketstatus.ContinFilter(NewFluxsignal,tol);% ���µ������źŽ��й���
FluxInd = find(NewFluxsignal == 1);
TrendInd = setdiff(1:length(bars.time),FluxInd);
end
