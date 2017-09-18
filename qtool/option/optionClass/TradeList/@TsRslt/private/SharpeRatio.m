
function [annSharpe,annYield, annVol] = SharpeRatio(nav,Rf,slicesPerDay)
% 潘其超，20140710，V.10
% 基于给定频率的净值时间序列，

% 计算连续收益率s
R = log(nav(2:end)./nav(1:end-1));

% 年化收益
annYield = mean(R-Rf)*slicesPerDay*250;

% 年化波动
annVol  = std(R)*(slicesPerDay*250)^0.5;

% 年化
annSharpe = annYield/annVol;
end

