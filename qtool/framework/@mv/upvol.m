function [ outSeq ] = upvol( inSeq, window )
% MV.UPVOL 计算moving下半边volatility
% [ outSeq ] = mv.upvol( inSeq, window )
% 输入：
%     inSeq   : N*1 简单向量
%     window　: 标量，移动窗口大小,包括当前点, 默认10
% 输出：
%     outSeq  : N*1 简单向量，1:window为nan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process
% 某些参数处理
if ~exist('window', 'var')
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

ma = mv.avg(inSeq,window);

for i = window:N
    
    dif = inSeq(i-window+1:i) - ma(i);
    updif = zeros(window,1);
    updif(dif>0) = dif(dif>0);
    cnt = sum(dif>0);
    outSeq(i) = sqrt(sum(updif.^2)/cnt);
end


end
