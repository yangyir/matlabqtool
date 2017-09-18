function [ outSeq ]  = dndn( inSeq )
% MV.DNDN 计算moving 连续下跌的步数,window没有意义
% 输入：
%     inSeq   : N*1 简单向量
% 输出：
%     outSeq  : N*1 简单向量，1:window为nan
% ----------------------------------------------------
% Cheng,Gang; 20130723    

%% pre-process

% seq 是简单序列



%% main
N = length(inSeq);
outSeq = nan(N,1);

dif = diff(inSeq);
updn = zeros(N,1);
updn(dif<0) = 1;
 
cnt = 0;
for i = 1:N-1
    cnt = (cnt + 1)* updn(i);  
    outSeq(i+1) = cnt;
end


end



