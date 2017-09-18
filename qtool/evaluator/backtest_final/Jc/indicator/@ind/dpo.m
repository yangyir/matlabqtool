function [ dpoVal ] = dpo( ClosePrice, nDay)
% detrend price oscilliator
% default nDay = 20
% ���nDay����������nDay�Զ�+1
% daniel 2013/4/16

% Ԥ����
if ~exist('nDay','var'), nDay = 20; end
if mod(nDay,2), nDay = nDay +1; end

% ���㲽
dpoVal = ind.ma(ClosePrice, nDay/2+1, 0) - ind.ma(ClosePrice, nDay, 0);

end

