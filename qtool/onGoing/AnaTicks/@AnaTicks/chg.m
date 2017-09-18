function vchg = chg( ticks,len,type )
% CHG 计算涨跌幅 
% @luhuaibao
% 2014.6.3
% inputs:
%   len          计算len个tick涨跌幅，len>0前验，len<0后验
%   type,  供选择，包括'last','bid','ask' 

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

