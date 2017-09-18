function [obj] = calcProfile(obj)
%CALCPROFILE ֻ�����µ�last��ask��bid
% 

N = length(obj.stockCodes);
for i = 1:N
    tks = obj.stockTicks(i);
    l = tks.latest;
    % ���ticks�и��£��͸���profile
    if l > obj.preLatest(i)
        % profile���Լ�����, �Ǿ���
        obj.stockProfile(i,:) = [ tks.last(l), ...
            tks.askP(l,1),...
            tks.askV(l,1), ...
            tks.bidP(l,1), ...
            tks.bidV(l,1), ...
            tks.askP(l,2), ...
            tks.askV(l,2), ...
            tks.bidP(l,2), ...
            tks.bidV(l,2) ];
        
        
        
        % ����preLatest
        obj.preLatest(i) = l;
    end
    
end
end