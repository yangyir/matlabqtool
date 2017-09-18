function [ willrVal ] = willr( HighPrice, LowPrice, ClosePrice, nDay )
% William %R
% default nDay =14
% daniel

% Ԥ����
if ~exist('nDay','var')
    nDay = 14;
end
willrVal = nan(size(HighPrice));

% ����
for i = 1: size(HighPrice,2)
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    closep = ClosePrice(:,i);
    willrVal(:,i) = willpctr(highp, lowp, closep, nDay);
end

end

