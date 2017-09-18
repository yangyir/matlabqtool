function [ ATR ] = atr0( high, low, vclose, atrlen )
%ATR 计算ATR
% @luhuaibao
% 2014.6.3
% inputs:
%   high, low, vclose , 行情的高低收，
%   atrlen,  计算atr的长度

if ~exist('atrlen','var')
    error('请输入计算ATR的历史长度');
end ; 


iATR = max( [ high -  low, abs( [nan; vclose(1:end-1)] -  high ), abs(  low - [nan; vclose(1:end-1)] ) ],[],2 );
ATR = ind.ma( iATR,atrlen,0);

end

