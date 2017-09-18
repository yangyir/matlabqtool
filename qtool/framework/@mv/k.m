function [ outSeq ] = k( inSeq, window)
% MV.K �������е�moving�������б��
% ���룺
%     inSeq   : N*1 ������
%     window��: �������ƶ����ڴ�С,������ǰ��, Ĭ��10
% �����
%     outSeq  : N*1 ��������1:windowΪnan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process
% ĳЩ��������
if nargin < 2 
    window = 10;
end

% seq �Ǽ�����


% window С�� seq ����
N = length(inSeq);
if N < window
    error('error: window size > seq length!');
end



%% main

x = (1:N)';

% һ��б��
outSeq = nan(N,1);
for  i = window:N
    idx = i-window+1:i;
%     TODO:     idx = idx & idxnan;
    a = polyfit(x(idx), inSeq(idx),1);
    outSeq(i) = a(1);
end




end

