function [ outSeq ] = upvol( inSeq, window )
% MV.UPVOL ����moving�°��volatility
% [ outSeq ] = mv.upvol( inSeq, window )
% ���룺
%     inSeq   : N*1 ������
%     window��: �������ƶ����ڴ�С,������ǰ��, Ĭ��10
% �����
%     outSeq  : N*1 ��������1:windowΪnan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

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


%% main
outSeq = nan(N,1);

ma = mv.avg(inSeq,window);

for i = window:N
    
    dif = inSeq(i-window+1:i) - ma(i);
    updif = zeros(window,1);
    updif(dif>0) = dif(dif>0);
    cnt = sum(dif>0);
    outSeq(i) = sqrt(sum(updif.^2)/cnt);
end


end
