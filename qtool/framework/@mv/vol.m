function [ outSeq ] = vol( inSeq, window )
% �������е��ƶ�vol
% [ outSeq ] = mv.vol( inSeq, window )
% ���룺
%     inSeq   : N*1 ������
%     window��: �������ƶ����ڴ�С,������ǰ��, Ĭ��10
% �����
%     outSeq  : N*1 ��������1:windowΪnan
% ----------------------------------------------------
% Cheng,Gang; 20130723   
% �̸գ�20150531���������㣬ӦΪ std(inSeqChg)

%% pre-process
% ĳЩ��������
if ~exist('window', 'var')
    window = 10;
end

% seq �Ǽ�����


% window С�� seq ����
N = length(inSeq);
if N < window
    error('error: window size > seq length!');
end

inSeqChg = ones( N, 1 );
% inSeqChg(1) = 1;
inSeqChg(2:end) = inSeq(2:end)./ inSeq(1:end-1);

%% main
outSeq = nan(N,1);

for i = window:N
    outSeq(i) = std( inSeqChg(i-window+1 : i));
end


end
