function [outSeq] = dist( inSeq, window )
% MV.DIST �����ƶ�����
% [outSeq] = mv.dist( inSeq, window )
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
outSeq = nan(N,1);
% �ۻ�·�̣� ��֣� ����ֵ�� ����
dist = cumsum( abs([0;diff(inSeq)]) );

% moving ·�̣���ǰ��M��ȥM-window��
outSeq(window:end) = dist(window:end) - dist(1:end-window+1);


end

