function [ vatr ] = ATR( ticks, atrlen )
%ATR 计算ATR
% @luhuaibao
% 2014.6.3
% inputs:
%   ticks
%   atrlen,  计算atr的长度

if ~exist('atrlen','var')
    error('请输入计算ATR的历史长度');
end ; 

vatr = atr0( ticks.last,ticks.last,ticks.last,atrlen) ; 
 

end

