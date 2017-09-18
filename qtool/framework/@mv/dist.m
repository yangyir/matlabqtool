function [outSeq] = dist( inSeq, window )
% MV.DIST 计算移动距离
% [outSeq] = mv.dist( inSeq, window )
% 输入：
%     inSeq   : N*1 简单向量
%     window　: 标量，移动窗口大小,包括当前点, 默认10
% 输出：
%     outSeq  : N*1 简单向量，1:window为nan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process

% 某些参数处理
if nargin < 2 
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
% 累积路程： 差分， 绝对值， 积分
dist = cumsum( abs([0;diff(inSeq)]) );

% moving 路程：当前点M减去M-window点
outSeq(window:end) = dist(window:end) - dist(1:end-window+1);


end

