function numT = timeInt2Num( intT )
%   timeInt2Num     ��replay�е�int�͵�timeת����matlab num�͵�
% 2014.4.22, ���صĲ�����date��ֻ��floor
% version 1.0, luhuaibao, 2013.10.18, �޸������ɰ�

intT = double(intT); % ����ת��Ϊdouble��
intT = floor(intT/10) ;  % ���ں���time2���һλ���������
HH = floor(intT/10000) ;
M = rem(intT,10000) ; 
 
MM = floor(M/100) ; 

SS = rem(M ,100 ) ;
% numT = datenum(date) + HH/24 + MM/60/24 + SS/60/60/24 ; 
numT =   HH/24 + MM/60/24 + SS/60/60/24 ; 
end

