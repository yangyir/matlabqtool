function [pStats] = sumPair(obj)
% �������������ÿһ��pair����һ��round

% ���䳬��20140814

save('tmp_sumPair_X.mat','obj');
X = importdata('tmp_sumPair_X.mat');
delete('tmp_sumPair_X.mat');

X.data(1:2:X.rcdNum,X.roundNoI) = 1:X.rcdNum/2;
X.data(2:2:X.rcdNum,X.roundNoI) = 1:X.rcdNum/2;

pStats = X.sumRound();

end