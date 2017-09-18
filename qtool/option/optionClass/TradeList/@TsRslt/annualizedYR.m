function [ annYield, annSharpe ] = annualizedYR( obj,initNav )
% 根据一段时间的TsRes算年华Yield， Sharpe
%
% V1.0,潘其超，20131021
% V2.0,潘其超，20131123
%    1. 修改出入参。
% 程刚，20131203；放入TsRes类

[tradeDays,dayLastIdx] = unique(floor(obj.time));

numDay = length(tradeDays);
dayNav = obj.nav(dayLastIdx);
dayNav = [initNav;dayNav];
dayYield = log(dayNav(2:end)./dayNav(1:end-1));

annYield = 250*sum(dayYield)/numDay;

annSharpe = annYield/std(dayYield)/sqrt(250);

end

