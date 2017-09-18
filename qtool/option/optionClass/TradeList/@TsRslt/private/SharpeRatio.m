
function [annSharpe,annYield, annVol] = SharpeRatio(nav,Rf,slicesPerDay)
% ���䳬��20140710��V.10
% ���ڸ���Ƶ�ʵľ�ֵʱ�����У�

% ��������������s
R = log(nav(2:end)./nav(1:end-1));

% �껯����
annYield = mean(R-Rf)*slicesPerDay*250;

% �껯����
annVol  = std(R)*(slicesPerDay*250)^0.5;

% �껯
annSharpe = annYield/annVol;
end

