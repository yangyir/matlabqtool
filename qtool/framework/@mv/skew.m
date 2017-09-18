function [ outSeq ]  = skew( inSeq, window )
% MV.SKEW 计算moving 偏度skewness
% 输入：
%     inSeq   : N*1 简单向量
%     window　: 标量，移动窗口大小,包括当前点, 默认10
% 输出：
%     outSeq  : N*1 简单向量，1:window为nan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process
% 某些参数处理
if ~exist('window','var') 
    window = 10;
end

% seq 是简单序列


% window 小于 seq 长度
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


