%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ����׼���ͱ�׼�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output1, output2] =  CalcCoefficientofvariance(account)

ave_account = mean(account);
net_account = account -ave_account;

% ��׼���
output2 = std (net_account);
% ��׼�����
output1 = output2/(ave_account-account(1));

end