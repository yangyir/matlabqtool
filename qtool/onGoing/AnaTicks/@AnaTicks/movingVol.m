function vol = movingVol( ticks,len,type )
%MOVINGVOL   移动求len内的波动率
% @luhuaibao
% 2014.6.3
% inputs:
%   len，moving的长度
%   type,  供选择，包括'last','bid','ask' 

if ~exist('type','var')
    type = 'last';
end ;


switch type
    case 'last'
        data = ticks.last(1:ticks.latest);
    case 'bid'
        data = ticks.bidP(1:ticks.latest,1);
    case 'ask'
        data = ticks.askP(1:ticks.latest,1);    
end ;  

n = length(data) ; 
vol = nan(n,1); 

for i =  len:n
    vol(i) = nanstd(data(i-len+1:i));    
end ; 
 
 
end

