function [ k, kk ] = calck( sequence, swin1, swin2)
%CALCK calculates the linear slope k, kk of a sequence
% returns a sequence with NANs at head and tail
% sequence  :      the sequence to process, mustNOT contain NAN
% swin1     :      semi window size for k,default = 5
% swin2     :      semi window size for kk, default = 5 
% i.e. calck(seq, 5), at point 20, uses seq(15:25) -> seq = kx + b 
% ver1.0;     Cheng,Gang;     20130409

%% pre-process
% default semi window size
if nargin<2 
    swin1 = 5; 
end
if nargin<3 
    swin2 = 5; 
end

% check sequence NAN
idxnan = isnan(sequence);


%% main
len = length(sequence);
x = (1:len)';

% 一阶斜率
k = nan(len,1);
for  i = swin1+1:len-swin1
    idx = i-swin1:i+swin1;
%     TODO:     idx = idx & idxnan;
    a = polyfit(x(idx), sequence(idx),1);
    k(i) = a(1);
end

% 二阶斜率
kk = nan(len,1);
for i = swin1+swin2+2 :len-swin2 - swin1
    idx = i-swin2:i+swin2;
    a = polyfit( x(idx), k(idx),1);
    kk(i) = a(1);
end



end

