function [ r, idx ]  = movingMin( ticks,len,type )
%MOVINMIN 移动求最小值
% @ luhuaibao
% 2014.6.3
% inputs:
%       ticks, Ticks类
%       len,    计算长度
%       type,  供选择，包括'last','bid','ask' 

if ~exist('type','var')
    type = 'last';
end ;

switch type
    case 'last'
        [ r, idx ] = movMin0( ticks.last, len ) ; 
        
    case 'bid'
        [ r, idx ] = movMin0( ticks.bidP(:,1), len ) ; 
    case 'ask'
        [ r, idx ] = movMin0( ticks.askP(:,1), len ) ; 
        
end ; 

end

