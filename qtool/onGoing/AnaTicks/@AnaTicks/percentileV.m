function [ value ] = percentileV(ticks, currentTk, percentile, win, price_type)
%PERCENTILEV ���ڹ�ȥ�۸��������ٷ�λ�ļ۸�ֵ
% [ value ] = percentileV(ticks, currentTk, percentile, win, price_type)
% ���룺
%     ticks           ����
%     currentTk       ����tick����ǰ����win��  
%     percentile      �ٷ�λ, ��95.8, 25      
%     win             ���ڴ�С
%     price_type      'bid','ask','last'(default)
% �����
%     value           �ٷ�λ��Ӧ�ļ۸�
%     
%�̸գ�140608


%% Ԥ����
if ~isa(ticks, 'Ticks')
    disp('�����������ͱ�����Ticks');
    return;
end
 
if isempty(ticks.latest)
    n = length(ticks.last);
else
    n = ticks.latest ; 
end ; 


if ~exist('price_type', 'var'), price_type = 'last'; end

switch price_type
    case 'last'
        data = ticks.last(1:n);
    case 'bid'
        data = ticks.bidP(1:n,1);
    case 'ask'
        data = ticks.askP(1:n,1);    
    otherwise 
        disp('����price_type����Ϊ''last''(ȱʡ��, ''bid'',''ask''');
end ;  



% currentPrice = data(currentTk); 

%% main

if exist('win', 'var')
    if currentTk >= win
        ts = data(currentTk - win + 1 :currentTk);
        value = prctile(ts, percentile);
    else
        disp('����currentTk֮ǰû���㹻win');
        value = nan;
    end
else
    disp('��ʾ����win��ͳ�Ʒ�Χ1��currentTk');
     ts = data(1 :currentTk);
    value = prctile(ts, percentile); 
end



end

