function [outSeq] = s2d( inSeq, window )
% MV.S2D 计算序列的位移/距离比。该值应在[-1,1]
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

dist    = mv.dist(inSeq, window);
shift   = mv.shift(inSeq, window);

outSeq  = shift./dist;

% outSeq = nan(N,1);1
% outSeq(window:end) = dist(window:end)./shift(window:end);


end


