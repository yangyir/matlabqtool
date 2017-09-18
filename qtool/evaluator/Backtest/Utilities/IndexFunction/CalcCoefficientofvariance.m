%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算标准离差和标准离差率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output1, output2] =  CalcCoefficientofvariance(account)

ave_account = mean(account);
net_account = account -ave_account;

% 标准离差
output2 = std (net_account);
% 标准离差率
output1 = output2/(ave_account-account(1));

end