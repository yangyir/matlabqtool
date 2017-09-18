function numT = timeInt2Num( intT )
%   timeInt2Num     把replay中的int型的time转换成matlab num型的
% 2014.4.22, 返回的不包括date，只有floor
% version 1.0, luhuaibao, 2013.10.18, 修改整理后成版

intT = double(intT); % 整形转换为double型
intT = floor(intT/10) ;  % 由于后来time2多加一位，必须除掉
HH = floor(intT/10000) ;
M = rem(intT,10000) ; 
 
MM = floor(M/100) ; 

SS = rem(M ,100 ) ;
% numT = datenum(date) + HH/24 + MM/60/24 + SS/60/60/24 ; 
numT =   HH/24 + MM/60/24 + SS/60/60/24 ; 
end

