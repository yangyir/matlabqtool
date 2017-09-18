function [ willlVar ] = willl( HighPrice, LowPrice, ClosePrice )
% William Accumulation/Distribution line
% daniel

% Ԥ����
 willlVar  = nan(size(HighPrice));

% ����
for i = 1: size(HighPrice,2)
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    closep = ClosePrice(:,i);
     willlVar(:,i) = willad(highp, lowp, closep);
end

end