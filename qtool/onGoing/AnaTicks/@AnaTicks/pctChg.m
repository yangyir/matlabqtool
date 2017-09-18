function vchg = pctChg( ticks,len,type )
%PCTCHG �����ǵ����ٷֱ�
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
        vchg  = pctChg0( len, ticks.last  ) ; 
    case 'bid'
        vchg  = pctChg0( len, ticks.bidP(:,1)  ) ; 
    case 'ask'
        vchg  = pctChg0( len, ticks.askP(:,1) ) ; 
        
end ;  






end

