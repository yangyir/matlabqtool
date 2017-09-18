function [ vmoneyflow ] = moneyflow( vtime,vhigh,vlow,vclose,vvolume,len )
%MONEYFLOW          �����ֽ������ο�mc�ļ��㷽ʽ
%len                ���㳤��
% version 1.0, luhuaibao, 2013.9.27. 
 
vhlc0 = (vhigh + vlow + vclose).*vvolume;
hlc0 = vhigh + vlow + vclose ; 

[~,id] = sort( -vtime );
% �������������
vhlc0 = vhlc0(id);
hlc0 = hlc0(id);

hlc0diff = diff(hlc0);

vhlc = vhlc0( 1:len,1);

var0 = zeros(len,1);
var0( hlc0diff(1:len,1) < 0,: ) = 1 ;

var0 = sum( vhlc.*var0 ) ;
var1 = sum( vhlc ) ;

if var1 ~= 0
    vmoneyflow = 100 * var0 / var1 ;
else
    vmoneyflow = 0 ;
end;
 

end

