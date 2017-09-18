function vol = movingVol( ticks,len,type )
%MOVINGVOL   �ƶ���len�ڵĲ�����
% @luhuaibao
% 2014.6.3
% inputs:
%   len��moving�ĳ���
%   type,  ��ѡ�񣬰���'last','bid','ask' 

if ~exist('type','var')
    type = 'last';
end ;


switch type
    case 'last'
        data = ticks.last(1:ticks.latest);
    case 'bid'
        data = ticks.bidP(1:ticks.latest,1);
    case 'ask'
        data = ticks.askP(1:ticks.latest,1);    
end ;  

n = length(data) ; 
vol = nan(n,1); 

for i =  len:n
    vol(i) = nanstd(data(i-len+1:i));    
end ; 
 
 
end

