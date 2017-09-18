function barsout = reframeBars(barsin, freq)
% reframeBars�����ɸ�����ת��Bars�Ĳ���Ƶ��
% �˰汾ֻ��Թ�ָ�ڻ�����
% �������룺 bars�� Ĭ��Ϊ1����Ƶ������
% ��������� bars��
% ������ freq ��default = 5 5���ӣ���freq=10 10����
% ע�� ת��������������
% ���ת����ʱ�䲻�ܱ���Ƶ����������������²��ֵ�����Ϊһ��bar
% @daniel 2013/06/03 version 1.0

dayList = unique(floor(barsin.time));
timeListMorning = [9/24+15/1440:freq/1440: 11/24+30/1440]'; 
timeListAfternoon = [13/24:freq/1440:15/24+15/1440]';
if timeListMorning(end)~= 11/24+30/1440
    timeListMorning = [timeListMorning(2:end);11/24+30/1440];
else
    timeListMorning = timeListMorning(2:end);
end

if timeListAfternoon(end)~= 15/24+15/1440
    timeListAfternoon = [timeListAfternoon(2:end);15/24+15/1440];
else
    timeListAfternoon = timeListAfternoon(2:end);
end

timeList = [timeListMorning;timeListAfternoon];

barsout = Bars;
newTime = ones(length(timeList),1)*dayList'+timeList*ones(1,length(dayList));
barsout.time=newTime(:);
barsout.close = nan(size(barsout.time));
barsout.open = barsout.close;
barsout.high = barsout.close;
barsout.low  = barsout.close;

for i = 1:length(barsout.time)
    if i == 1
        idxFirst = 1;
    else
        idxFirst = find(barsin.time == barsout.time(i-1))+1;
    end
    idxLast = find(barsin.time == barsout.time(i));
    if isempty(idxLast) || isempty(idxFirst)
        continue;
    else
    barsout.close(i)  = barsin.close(idxLast);
    barsout.high(i) = max(barsin.high(idxFirst:idxLast));
    barsout.low(i) = min(barsin.low(idxFirst:idxLast));
    barsout.open(i) = barsin.open(idxFirst);
    end
end

    



