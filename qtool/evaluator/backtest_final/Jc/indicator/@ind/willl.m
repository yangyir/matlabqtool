function [ willlVar ] = willl( HighPrice, LowPrice, ClosePrice )
% William Accumulation/Distribution line
% daniel

% ‘§¥¶¿Ì
 willlVar  = nan(size(HighPrice));

% º∆À„
for i = 1: size(HighPrice,2)
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    closep = ClosePrice(:,i);
     willlVar(:,i) = willad(highp, lowp, closep);
end

end