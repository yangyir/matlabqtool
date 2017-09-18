function [ k, kk ] = kkk( inSeq, win1, win2)
% MV.SHIFT 计算序列位移
% 输入：
%     inSeq    : N*1 简单向量
%     win1     : k的moving窗口 default = 10
%     win2     : kk的moving窗口 default = 7 
% 输出：
%     k        : N*1 简单向量，1:win1为nan
%     kk       : N*1 简单向量，1:win1+win2为nan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process

% 某些参数处理
if nargin < 2 
    win1 = 10;
end
if nargin<3 
    win2 = 7; 
end

% seq 是简单序列


% window 小于 seq 长度
N = length(inSeq);
if N < win1
    error('error: window size > seq length!');
end


% check sequence NAN
idxnan = isnan(inSeq);


%% main
x = (1:N)';

% 一阶斜率
k = nan(N,1);
for  i = win1:N
    idx = i-win1+1:i;
%     TODO:     idx = idx & idxnan;
    a = polyfit(x(idx), inSeq(idx),1);
    k(i) = a(1);
end

% 二阶斜率
kk = nan(N,1);
for i = win1+win2 :N
    idx = i-win2+1:i;
    a = polyfit( x(idx), k(idx),1);
    kk(i) = a(1);
end



end


