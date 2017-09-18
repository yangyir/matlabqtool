function [ willrVal ] = willr( HighPrice, LowPrice, ClosePrice, nDay )
% William %R
% default nDay =14
% daniel

% ‘§¥¶¿Ì
if ~exist('nDay','var')
    nDay = 14;
end
willrVal = nan(size(HighPrice));

% º∆À„
for i = 1: size(HighPrice,2)
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    closep = ClosePrice(:,i);
    willrVal(:,i) = willpctr(highp, lowp, closep, nDay);
end

end

