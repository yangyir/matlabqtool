function [ vatr ] = ATR( ticks, atrlen )
%ATR ����ATR
% @luhuaibao
% 2014.6.3
% inputs:
%   ticks
%   atrlen,  ����atr�ĳ���

if ~exist('atrlen','var')
    error('���������ATR����ʷ����');
end ; 

vatr = atr0( ticks.last,ticks.last,ticks.last,atrlen) ; 
 

end

