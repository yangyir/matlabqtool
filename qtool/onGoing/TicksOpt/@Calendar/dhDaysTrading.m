function [ n ] = dhDaysTrading( date1, date2, market)
%DHDAYTRADING ���㽻���ռ��������������
% ���ޣ�����DH�ĺ������㣬һ��Ҫװ��DH
% market:   �г��� �� 'sse', 'shfe' 
% �̸�;140617

%%
DH

switch  market
    case{'sse'}
        type = 1;
    case{'szse'}
        type = 2;
    case{'shfe'}
        type = 3;
    otherwise
        type = 1;
end
   
if date1 > date2 
    tmp = date2;
    date2 = date1; 
    date1 = tmp;
end


%%
date1str    = datestr(date1, 'yyyy-mm-dd');
date2str    = datestr( date2, 'yyyy-mm-dd');

datesStr    = DH_D_TR_MarketTradingday(type,date1str,date2str);
n           = size(datesStr,1);

end

