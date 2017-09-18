function [ obj ] = fillTK( obj )
%FILLTK ����optCode����д T��K��ص���
% ʱ������Ǹ��ѵ㣬û����ȫ���
%�̸�;140616

%% ǰ����
% ������룺'510050C1407A1500'
if isempty(obj.optCode)
    disp('����ȱ��optCode');
    return;
end

obj.underCode = str2double( obj.optCode(1:6) );


%% ֱ��
obj.optType     = obj.optCode(7);
obj.strikeCode  = obj.optCode(13:16);
obj.expCode     = obj.optCode(8:11);
obj.adjustCode  = obj.optCode(12);

% ����
obj.strike = str2double(obj.strikeCode) / 100;


%% ����Ҫ���㣬�ϸ���

% ������Ȩ��ÿ�µ�4����3
% ETF��Ȩ��ÿ�µ�3����5
if obj.underCode == 510050 || obj.underCode == 510300
    % ETF��Ȩ��ÿ�µ�3����5
    obj.expDate = Calendar.nthWeekdayOfMonth(3,'fri',obj.expCode(3:4),obj.expCode(1:2));
else
    % ������Ȩ��ÿ�µ�4����3
    obj.expDate = Calendar.nthWeekdayOfMonth(4,'wed',obj.expCode(3:4),obj.expCode(1:2));
end


obj.expDate2 = datestr(obj.expDate, 'yyyymmdd'); % �����գ�yyyymmdd

obj.naturalT = obj.expDate - obj.date; % ���뵽���ն�����Ȼ��



%% ����Ҫ���㣬�ϸ��ӣ�û��calendarû����
% obj.tradingT =  Calendar.daysNonWeekend(obj.expDate, obj.date); % ���뵽���ն��ٽ�����
        
obj.tradingT =  Calendar.dhDaysTrading(obj.expDate, obj.date, 'sse'); % ���뵽���ն��ٽ�����
        

end

