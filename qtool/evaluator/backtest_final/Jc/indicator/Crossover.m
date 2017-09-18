function [idxCross] =  crossOver( A, B, type)
% A 自下而上穿越 B
% 返回 { 0 ， 1 }的bool序列
% 返回bool数列 穿越点为1 其它为0
% type = 1 标准
% type = 2 金叉: A B 同时上升且A上穿B
% type = 3 死叉：A B 同时下降且A上穿B
% @author daniel 20130506 version 1.1

%% 预处理
if nargin <= 2 || isempty(type)
    type = 1;
    if nargin <2 || isempty(A) || isempty(B)
        error('require input of A and B');
    end
end

[nPeriod, nAsset] = size(A);
if nAsset ~= size(B,2)
    error(' nAsset of A and B does not match');
end

if nPeriod ~= size(B,1)
    nPeriod = min(nPeriod, size(B,1));
    A = A(1:nPeriod, nAsset);
    B = B(1:nPeriod, nAsset);
end

%% 计算步骤

% 一般交叉，金叉，死叉
switch type
    case 1
        idxCross = [nan(1:nAsset); A(1:end-1,:)]<= [nan(1:nAsset); B(1:end-1,:)] & A>B;
    case 2
        idxCross = [nan(1:nAsset); A(1:end-1,:)]<= [nan(1:nAsset); B(1:end-1,:)] ...
            & A > B & A > [nan(1,nAsset); A(1:end-1,:) ] & B > [nan(1,nAsset); B(1:end-1,:)];
    case 3
        idxCross = [nan(1:nAsset); A(1:end-1,:)]<= [nan(1:nAsset); B(1:end-1,:)] ...
            & A > B & A < [nan(1,nAsset); A(1:end-1,:) ] & B < [nan(1,nAsset); B(1:end-1,:)];
end
    

