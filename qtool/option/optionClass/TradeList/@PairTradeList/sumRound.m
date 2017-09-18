function [ rStats ] = sumRound( obj )
%SUMBYROUND Summary of this function goes here
%   Detailed explanation goes here

% ÅËÆä³¬£¬20140706£¬V1.0

obj.prune();

roundType = unique(obj.data(:,obj.roundNoI));
numRound = length(roundType);

rStats.roundNum = numRound;
rStats.roundNo = zeros(numRound,1);
rStats.pnl = zeros(numRound,1);
rStats.commission = zeros(numRound,1);
rStats.volume = zeros(numRound,1);
rStats.span = zeros(numRound,1);
rStats.direction = zeros(numRound,1);

for i = 1:numRound
    rNo = roundType(i);
    rInd = obj.data(:,obj.roundNoI)==rNo;
    rStats.roundNo(i) = rNo;
    rStats.pnl(i) = sum(obj.data(rInd,obj.pnlI));
    rStats.commission(i) = sum(obj.data(rInd,obj.cmsnI));
    rStats.volume(i) = sum(obj.data(rInd,obj.volumeI));
    idxFirstTrade = find(rInd>0,1,'first');
    rStats.direction(i) = obj.data(idxFirstTrade,obj.directionI);
    idxLastTrade = find(rInd>0,1,'last');
    rStats.span(i) = obj.data(idxLastTrade,obj.timeI)-obj.data(idxFirstTrade,obj.timeI);
end

end

