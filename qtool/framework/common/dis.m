function [d, dseq  ] = dis( seq, span )
%DIS 计算一个vector的走过的距离
% 输入：
%     ts  : 简单vector
%     span: 步长精度，默认1
% 输出：
%     d   : 总距离
%     dseq: 距离序列
% ver 1.0; Cheng,Gang; 20130723


%% pre-process


%% main
dseq =[0; diff(seq)];
dseq = cumsum(abs(dseq));
% dist = cumsum(dist);

d = dseq(end);


end

