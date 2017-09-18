function [ RSI, var0, var1, var4 ]  = rsiMC(data, len) 
% 与MC一致的计算RSI函数，系数移动平均计算分子分母，qtool中的为简单移动平均计算分子分母
% version 1.0 , luhuaibao
% version 1.1 , luhuaibao, 修改入参，入参由bars更改为直接参与计算量

vclose = data ; 
difclose = [nan ; diff(vclose) ] ;
absDifClose = abs(difclose) ; 

lenData = size(vclose,1) ; 
var0 = nan( lenData, 1 ) ; 
var1 = nan( lenData, 1 ) ;
var4 = nan( lenData, 1 ) ; 
var0(len,1) = ( vclose(len,1) - vclose(1,1) )/len ; 
var1(len,1) = nanmean( absDifClose(1:len,1) ) ; 

for i = len+1:lenData
    var0(i,1) = var0(i-1,1) + ( difclose(i,1) - var0(i-1,1))/len ; 
    var1(i,1) = var1(i-1,1) + ( absDifClose(i,1) - var1(i-1,1) )/len ;  
    if var1(i,1) ~= 0 
        var4(i,1) = var0(i,1)/var1(i,1) ; 
    else
        var4(i,1) = 0 ;    
    end; 
end ; 
 
 
RSI = 50 * ( var4 + 1 ) ;

end 