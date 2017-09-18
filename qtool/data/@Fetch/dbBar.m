function [ bs, Sflag ] = dbBar(Code, start_date, end_date, slice_seconds, slice_start)
% ÿ��ֻ��ȡһ�ֺ�Լ
% Code Ϊ֤ȯ���룬��Ʊ���� '600000.SH'�� ��ָ���� 'IF1312'(������Լ 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', ������Լ 'IFHot')
% start_dateΪ��ʼʱ��
% end_dateΪ��ֹʱ��
% slice_seconds ��ʾ��Ƭ���ȣ�������������[60,90,120]
% slice_start ��ʾ��ʼʱ�䣬Ĭ����0�� ����Ҫ��slice_secondsһһ��Ӧ

%HeQun 2013.12.23
if nargin < 4
    error('ȡBar�Ĳ������㣡')
elseif nargin < 5
    slice_start = 0;
end

bs =Bars;
[DayCode, DayTime] = genContractImfor(Code, start_date, end_date);
if isempty(DayCode)
    Sflag = 0;
    disp('û�е�ǰ���������');
    return;
end

startDay = 0;
for k = 1:length(DayCode)
    [ bs, SflagD ] = dbFetchDayBar(DayCode{k}, num2str(DayTime{k}), slice_seconds, slice_start);
    startDay = k;
    if SflagD
        if strcmp(Code, 'IFHot') || strcmp(Code(1:4), 'IF0Y')
            for kk = 1:length(bs)
                bs(kk).code = Code;
            end
        end
        break;
    end
end

for k = startDay+1:length(DayCode)
    [ bs1, SflagD ] = dbFetchDayBar(DayCode{k}, num2str(DayTime{k}), slice_seconds, slice_start);
    if SflagD
        if strcmp(Code, 'IFHot') || strcmp(Code(1:4), 'IF0Y')
            for kk = 1:length(bs)
                bs1(kk).code = Code;
            end
        end
        for kk = 1:length(bs)
            bs(kk) = barLink(bs(kk), bs1(kk));
        end
    end
end
Sflag = 1;
end