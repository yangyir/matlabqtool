function [ mk, mkk ] = calcmovk( sequence, win1, win2)
%CALCMOVK ����moving б��k, kk of a sequence
% returns a sequence with NANs at head and tail
% sequence  :      the sequence to process, must NOT contain NAN
% win1     :      k��moving���� default = 8
% win2     :      kk��moving���� default = 7 
% i.e. calck(seq, 5), at point 20, uses seq(15:25) -> seq = kx + b 
% ver1.0;     Cheng,Gang;     20130721

%% pre-process
% default semi window size
if nargin<2 
    win1 = 8; 
end
if nargin<3 
    win2 = 7; 
end

% check sequence NAN
idxnan = isnan(sequence);


%% main
len = length(sequence);
x = (1:len)';

% һ��б��
mk = nan(len,1);
for  i = win1+1:len
    idx = i-win1:i;
%     TODO:     idx = idx & idxnan;
    a = polyfit(x(idx), sequence(idx),1);
    mk(i) = a(1);
end

% ����б��
mkk = nan(len,1);
for i = win1+win2+2 :len
    idx = i-win2:i;
    a = polyfit( x(idx), mk(idx),1);
    mkk(i) = a(1);
end



end

