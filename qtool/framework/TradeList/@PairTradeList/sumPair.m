function [pStats] = sumPair(obj)
% 根据配对来做，每一个pair就算一个round

% 潘其超，20140814

save('tmp_sumPair_X.mat','obj');
X = importdata('tmp_sumPair_X.mat');
delete('tmp_sumPair_X.mat');

X.data(1:2:X.rcdNum,X.roundNoI) = 1:X.rcdNum/2;
X.data(2:2:X.rcdNum,X.roundNoI) = 1:X.rcdNum/2;

pStats = X.sumRound();

end