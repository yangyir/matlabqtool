function [ep,beta] = residualCal(R1,R2)
result=regstats(R1,R2);
ep = result.r;
beta_temp = result.beta;
beta = beta_temp(2:end)';
end

