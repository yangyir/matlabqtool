function [ r, idx ]  = movingMax( ticks,len,type )
%MOVINGMAX �ƶ������ֵ
% @ luhuaibao
% 2014.6.3
% inputs:
%       ticks, Ticks��
%       len,    ���㳤��
%       type,  ��ѡ�񣬰���'last','bid','ask' 

if ~exist('type','var')
    type = 'last';
end ;

switch type
    case 'last'
        [ r, idx ] =  movMax0( ticks.last, len ) ; 
        
    case 'bid'
        [ r, idx ] =  movMax0( ticks.bidP(:,1), len ) ; 
    case 'ask'
        [ r, idx ] =  movMax0( ticks.askP(:,1), len ) ; 
        
end ; 

        
 


end

