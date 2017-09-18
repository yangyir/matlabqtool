function [ ATR ] = atr0( high, low, vclose, atrlen )
%ATR ����ATR
% @luhuaibao
% 2014.6.3
% inputs:
%   high, low, vclose , ����ĸߵ��գ�
%   atrlen,  ����atr�ĳ���

if ~exist('atrlen','var')
    error('���������ATR����ʷ����');
end ; 


iATR = max( [ high -  low, abs( [nan; vclose(1:end-1)] -  high ), abs(  low - [nan; vclose(1:end-1)] ) ],[],2 );
ATR = ind.ma( iATR,atrlen,0);

end

