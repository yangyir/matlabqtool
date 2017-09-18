function [ vwillr ] = percentr( vtime,vhigh,vlow,vclose,len )
%PERCENTR       计算willr，根据mc
% version 1.0 , luhuaibao, 2013.9.27

[~,id] = sort( -vtime );
% 最近的排在上面
vhigh = vhigh(id);
vlow = vlow(id);
vclose = vclose(id);

var0 = max( vhigh(1:len ) );
var1 = var0 - min( vlow(1:len) ) ;

if var1 ~= 0   
	vwillr = 100 - ( ( var0 - vclose(1) ) / var1 ) * 100 ;
else
	vwillr = 0 ;

end

end
