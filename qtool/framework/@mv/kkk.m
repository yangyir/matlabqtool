function [ k, kk ] = kkk( inSeq, win1, win2)
% MV.SHIFT ��������λ��
% ���룺
%     inSeq    : N*1 ������
%     win1     : k��moving���� default = 10
%     win2     : kk��moving���� default = 7 
% �����
%     k        : N*1 ��������1:win1Ϊnan
%     kk       : N*1 ��������1:win1+win2Ϊnan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process

% ĳЩ��������
if nargin < 2 
    win1 = 10;
end
if nargin<3 
    win2 = 7; 
end

% seq �Ǽ�����


% window С�� seq ����
N = length(inSeq);
if N < win1
    error('error: window size > seq length!');
end


% check sequence NAN
idxnan = isnan(inSeq);


%% main
x = (1:N)';

% һ��б��
k = nan(N,1);
for  i = win1:N
    idx = i-win1+1:i;
%     TODO:     idx = idx & idxnan;
    a = polyfit(x(idx), inSeq(idx),1);
    k(i) = a(1);
end

% ����б��
kk = nan(N,1);
for i = win1+win2 :N
    idx = i-win2+1:i;
    a = polyfit( x(idx), k(idx),1);
    kk(i) = a(1);
end



end


