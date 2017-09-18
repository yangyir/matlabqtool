function vvol = vol( ticks, type )
%VOL     计算ticks的某序列波动，日度
% @luhuaibao
% 2014.6.3
% inputs:
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

vvol = nanstd(data ) ; 


end

