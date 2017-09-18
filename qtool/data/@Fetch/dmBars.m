function [ bs, sFlag ] = dmBars(code, start_date, end_date, slice_seconds, slice_start, driver)
% ��dbȡBars�����巽������ȡTicks����Bars��
% ÿ��ֻ��ȡһ�ֺ�Լ�����зַ�ʽ�����ж���
% Code ��Լ������ 'IF1312'(������Լ 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03')
% start_dateΪ��ʼʱ��
% end_dateΪ��ֹʱ��
% slice_seconds ��ʾ��Ƭ���ȣ�������������[60,90,120]
% slice_start ��ʾ��ʼʱ�䣬Ĭ����0�� ����Ҫ��slice_secondsһһ��Ӧ
% driver ���ݴ�ŵ��̷��� �˴�Ӧ���ǿ������̷��� Ĭ����'Y'

% HeQun 2013.1.22; ��������ͨ��������IF

%% Ԥ����
if nargin < 4
    error('ȡBar�Ĳ������㣡')
elseif nargin < 5
    slice_start = zeros(size(slice_seconds));
    driver = 'Y:\qdata\DayTicks\'; 
elseif nargin < 6
    driver = 'Y:\qdata\DayTicks\'; 
else
    if isempty(slice_start)
        slice_start = zeros(size(slice_seconds));
    end
end

sFlag = 0;


bs =Bars;
startDayNum = datenum(start_date, 'yyyymmdd');
endDayNum   = datenum(end_date, 'yyyymmdd');

%% ��һ�죬ר�Ŵ���
firstDay = startDayNum;
for k = startDayNum:endDayNum
    [ bs, successBars ] = dmDayBars(code, datestr(k,'yyyymmdd'), slice_seconds, slice_start, driver);
    firstDay = k;
    
    % ����ɹ�����ԭsec code
    if successBars
        disp(['�Ѿ�ȡ��',  code, '��' , datestr(k,'yyyymmdd'), '��Bar���ݣ�']);
        sFlag = 1;
        break;
    end
end

%% ��2��n�죬ȡ��������bs
for k = firstDay+1:endDayNum
    [ bs1, successBars ] = dmDayBars(code, datestr(k,'yyyymmdd'), slice_seconds, slice_start, driver);
    
    if successBars
%         ��ȡ����ʱ�Ķ���֤ȯ������л�ԭ
        disp(['�Ѿ�ȡ��',  code, '��' , datestr(k,'yyyymmdd'), '��Bar���ݣ�']);
        
%         ��������bar���м򵥵�����
        for kk = 1:length(bs)
            bs(kk).merge( bs1(kk) );
        end
    end
end


end