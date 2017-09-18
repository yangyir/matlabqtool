function [ tks, sFlag ] = dmTicks(code, start_date, end_date, root)
% ÿ��ֻ��ȡһ�ֺ�Լ
% Code ��Լ������ 'IF1312'(������Լ 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03')
% start_dateΪ��ʼʱ�� '20120104'
% end_dateΪ��ֹʱ�� '20120108'
% root ���ݴ�ŵ�·���� �˴�Ӧ���ǿ������е����ݣ� Ĭ����'Y:\qdata\DayTicks\'

% HeQun 2014.1.22

if nargin < 3
    error('�������㣡')
elseif nargin < 4
    root = 'Y:\qdata\DayTicks\';
end



%% ��ʼ��
sFlag = 0;

%% ����SQL����

tks         = Ticks;
startDayNum = datenum(start_date, 'yyyymmdd');
endDayNum   = datenum(end_date, 'yyyymmdd');



% ��һ��ѭ����ȡ��һ�������ݵ�ticks����Ϊ�ܽ��
for k = startDayNum:endDayNum
    [ tks, sFlagD ] = dmDayTicks(code, datestr(k,'yyyymmdd'),root);
    firstDay = k;
    
    
    % ��ɹ�������
    if sFlagD
        disp(['�Ѿ�ȡ��',  code, '��' , datestr(k,'yyyymmdd'), '��Tick���ݣ�']);
        sFlag = 1;
        break;
    end
end

% ȡ�����������ticks�������)���������һ������tks
for k = firstDay+1:endDayNum
    [ ts1, sFlagD ] = dmDayTicks(code, datestr(k,'yyyymmdd'),root);
    
    % ��ɹ�ȡ��������tks
    if sFlagD        
        disp(['�Ѿ�ȡ��',  code, '��' , datestr(k,'yyyymmdd'), '��Tick���ݣ�']);
        tks.merge(ts1);
    end
end
