function [ span, t1, t2 ] = longestDrawDown( nav )
% ������س������������¸�������
% [ span, t1, t2 ] = LongestDrawDown( nav )
% nav:  ��ֵ����
% span: ��س�����
% t1:   ��س����
% t2:   ��س��յ�
% ----------------------------
% �̸գ�20150510

%% main
nP              = size(nav,1);

% �¸�
isNewHi         = ones(nP,1);
h               = evl.preHigh(nav);
isNewHi(2:end)  = h(2:end) > h(1:end-1);

% �������س�
ddCount         = zeros(nP,1);

for t = 2:nP
    if isNewHi(t) == 1 % ���¸�
        ddCount(t) = 0;      
    else   % δ���¸ߣ��س���
        ddCount(t) = ddCount(t-1) + 1;
   end
end

% ������س�����
[span, t2 ] = max(ddCount);
t1          = t2-span+1;

end

