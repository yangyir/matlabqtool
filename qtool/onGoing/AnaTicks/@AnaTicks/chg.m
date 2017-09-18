function vchg = chg( ticks,len,type )
% CHG �����ǵ��� 
% @luhuaibao
% 2014.6.3
% inputs:
%   len          ����len��tick�ǵ�����len>0ǰ�飬len<0����
%   type,  ��ѡ�񣬰���'last','bid','ask' 

if ~exist('type','var')
    type = 'last';
end ;

switch type
    case 'last'
        vchg = chg0( len, ticks.last ) ; 
        
    case 'bid'
        vchg  = chg0( len, ticks.bidP(:,1) ) ; 
    case 'ask'
        vchg  = chg0( len, ticks.askP(:,1) ) ; 
        
end ; 


end

