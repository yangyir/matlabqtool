function [obj] = calcProfile(obj)
%CALCPROFILE 只算最新的last，ask，bid
% 

N = length(obj.stockCodes);
for i = 1:N
    tks = obj.stockTicks(i);
    l = tks.latest;
    % 如果ticks有更新，就更新profile
    if l > obj.preLatest(i)
        % profile由自己定义, 是矩阵
        obj.stockProfile(i,:) = [ tks.last(l), ...
            tks.askP(l,1),...
            tks.askV(l,1), ...
            tks.bidP(l,1), ...
            tks.bidV(l,1), ...
            tks.askP(l,2), ...
            tks.askV(l,2), ...
            tks.bidP(l,2), ...
            tks.bidV(l,2) ];
        
        
        
        % 更新preLatest
        obj.preLatest(i) = l;
    end
    
end
end