function [ preHi, idx ] = preHigh( nav )
%PREHIGH ����nav���е�ǰ��ֵ������ǵ���������
% ----------------------------------
% �̸գ�20150510

%% main
nP      = size(nav,1);
preHi   = nan(nP,1);
idx     = nan(nP,1);

for i = 1:nP
    [preHi(i),idx(i)] = max(nav(1:i));
end


end

