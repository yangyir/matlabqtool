function vvol = vol( ticks, type )
%VOL     ����ticks��ĳ���в������ն�
% @luhuaibao
% 2014.6.3
% inputs:
%   type,  ��ѡ�񣬰���'last','bid','ask' 


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

