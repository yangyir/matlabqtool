function [outSeq] = s2d( inSeq, window )
% MV.S2D �������е�λ��/����ȡ���ֵӦ��[-1,1]
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

dist    = mv.dist(inSeq, window);
shift   = mv.shift(inSeq, window);

outSeq  = shift./dist;

% outSeq = nan(N,1);1
% outSeq(window:end) = dist(window:end)./shift(window:end);


end


