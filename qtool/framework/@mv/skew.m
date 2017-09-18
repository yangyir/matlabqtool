function [ outSeq ]  = skew( inSeq, window )
% MV.SKEW ����moving ƫ��skewness
% ���룺
%     inSeq   : N*1 ������
%     window��: �������ƶ����ڴ�С,������ǰ��, Ĭ��10
% �����
%     outSeq  : N*1 ��������1:windowΪnan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process
% ĳЩ��������
if ~exist('window','var') 
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

for i = window:N
    outSeq(i) = skewness( inSeq( i - window +1 : i) );
end


end


