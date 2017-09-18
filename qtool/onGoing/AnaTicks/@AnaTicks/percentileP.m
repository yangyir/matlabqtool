function [ percentile ] = percentileP(ticks, currentTk, valuePrice, win, price_type)
%PERCENTILEP ���ڹ�ȥ�۸��������۸������İٷ�λ
% [ percentile ] = percentileP(ticks, currentTk, valuePrice, win, price_type)
% �ͼ۸� -- �Ͱٷ�λ
% ���룺
%     ticks           ����
%     currentTk 
%     valuePrice      �۸�    
%     win             ���ڴ�С
%     price_type      'bid','ask','last'(default)
% �����
%     percentile      �۸��Ӧ�İٷ�λ  
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



%% main

if exist('win', 'var')
    if currentTk >= win
        ts = data(currentTk - win + 1 :currentTk);               
        % ֱ�ӷ��⾭������
%         percentile = fzero(@(x) prctile(ts, x)-valuePrice, 50);
        
        % �Լ�д��һ��private��������
        percentile = prctileP(ts, valuePrice);      
    else
        disp('����currentTk֮ǰû���㹻win');
        percentile = nan;
    end
else
    disp('��ʾ����win��ͳ�Ʒ�Χ1��currentTk');
     ts = data(1:currentTk);
     percentile = prctileP(ts, valuePrice);   

end


end

