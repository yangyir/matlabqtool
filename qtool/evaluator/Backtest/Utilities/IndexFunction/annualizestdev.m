%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算年化波动率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  annstdR =annualizestdev(R,slicesPerDay)
%%
R(isnan(R)) = [];
% 计算波动率
stdR =std(R);
% 计算年化系数
annualCoe = 250*slicesPerDay;
annstdR = stdR*(annualCoe^0.5);
end
