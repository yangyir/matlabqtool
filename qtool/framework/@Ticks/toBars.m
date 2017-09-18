function [bs] = toBars(obj, slice_seconds, slice_start)
% TOBARS ʹ�õ���һ���Tick����ת��ΪBar
% [bs] = toBars(obj, slice_seconds, slice_start)

% ts ��ʾTick����
% bs ��ʾBar����

%HeQun 2013.12.23

%% 
% if exist('obj','class')
%     error('Tick ���������޷�ת��ΪBar��');
% end

bs          = Bars;
if isempty(obj.time)
    return;
end

%% ʱ�������к���nan���ݵ����д������ݴ���
if any(isnan(obj.time))
    error('Tick ��������Nan���ݣ��޷�ת��ΪBar��');
end

% ͨ����һ��ʱ���ж������ʱ��
Timevec             = datevec(obj.time(1));

%% �ж�֤ȯ���ͣ� ����ʱ��ڵ�
if strcmp(obj.type, 'stock')
    % ��Ʊÿ����240���ӽ���ʱ�䣬����240*60=14400s����ʱ�䣬
    % ������ν��л���, timeSeg��ʾ
    timeSeg     =   transpose(slice_start:slice_seconds:14400);
    
    
    %�����һ��Bar�Ĵ�����timeSeg���һ�����ݲ��ǽ��׽���ʱ�䣬
    %  �����׽���ʱ����ΪBars�����ʱ��
    if timeSeg(end) < 14400
        timeSeg(end+1) = 14400;
    end
    
    
    %����һ��Bar�Ĵ���������ʼʱ�䲻�ǣ�����[0,slice_start]��Ϊһ��ĵ�һ��Bar
    if slice_start >0
        timeSeg = [0;timeSeg];
    end
    
    % ����������Ϣ��ʱ��
    timeSeg(timeSeg>7200)  = timeSeg(timeSeg>7200)+5400;
    
    % ��ʱ����MatlabС����ʾ���ټ��ϵ����ʱ�䣬 ��ҪĿ����������time���Ƚ�
    timeSeg = timeSeg/86400 + datenum([Timevec(1:3),9,30,0]);
elseif strcmp(obj.type, 'future')
    % ��Ʊÿ����270���ӽ���ʱ�䣬����270*60=16200s����ʱ�䣬
    % ������ν��л���
    timeSeg = transpose(slice_start:slice_seconds:16200);
    if timeSeg(end) < 16200
        timeSeg(end+1) = 16200;
    end
    %������ʼʱ�䲻�ǣ�����[0,slice_start]��Ϊһ��ĵ�һ��Bar
    if slice_start >0
        timeSeg = [0;timeSeg];
    end
    
    % ����������Ϣ��ʱ�䣬8100���Ӧ2h15min,5400s��Ӧ1h30min
    timeSeg(timeSeg>8100)   = timeSeg(timeSeg>8100)+5400;
    
    % ��ʱ����MatlabС����ʾ���ټ��ϵ����ʱ�䣬 ������time���Ƚ�
    timeSeg = timeSeg/86400 + datenum([Timevec(1:3),9,15,0]);
elseif strcmp(obj.type, 'Gfuture')
    % ��Ʒ�ڻ�ÿ����240���ӽ���ʱ�䣬����240*60=14400s����ʱ�䣬
    % ������ν��л���
    timeSeg = transpose(slice_start:slice_seconds:14400);
    if timeSeg(end) < 14400
        timeSeg(end+1) = 14400;
    end
    %������ʼʱ�䲻�ǣ�����[0,slice_start]��Ϊһ��ĵ�һ��Bar
    if slice_start >0
        timeSeg = [0;timeSeg];
    end
    
    % ����������Ϣ��ʱ�䣬9000���Ӧ2h30min,7200s��Ӧ2h0min
    timeSeg(timeSeg>9000)   = timeSeg(timeSeg>9000)+7200;
    
    % ��ʱ����MatlabС����ʾ���ټ��ϵ����ʱ�䣬 ������time���Ƚ�
    timeSeg = timeSeg/86400 + datenum([Timevec(1:3),9,00,0]);
else
    error('����ʶ���֤ȯ���ͣ�֤ȯ����Ӧ����''stock''���� ''future''');
end

%% ���һЩ�����Լ���ʼ��
slicetype   = int32(slice_seconds*100000+slice_start*10);

bs.time      = timeSeg(2:end);
bs.code      = obj.code;
bs.type      = obj.type;
bs.slicetype = slicetype;
bs.time2 = str2num(datestr(bs.time,'HHMMSS'));

startIndex = 1;
barNum = length(timeSeg)-1;
bs.open      = nan(barNum,1);
bs.high      = nan(barNum,1);
bs.low       = nan(barNum,1);
bs.close     = nan(barNum,1);
bs.amount    = nan(barNum,1);    %Ԫ
bs.volume    = nan(barNum,1);    %��
bs.tickNum   = nan(barNum,1);
if strcmp(obj.type, 'future')
    bs.openInt   = nan(barNum,1);
end

%% ��һ���ÿ��Bar����ֵ
for k = 1:barNum
    % ����k��bar�Ľ���λ����tick�е����
    endIndex = find(obj.time > timeSeg(k+1),1,'first') - 1;
    
    if isempty(endIndex)
        endIndex = length(obj.time);
    end
    % ����������Bar����ʱ����bar�����
    if(~(isempty(endIndex) || endIndex < startIndex))
        bs.open(k)      = obj.last(startIndex);
        bs.high(k)      = max(obj.last(startIndex:endIndex));
        bs.low(k)       = min(obj.last(startIndex:endIndex));
        bs.close(k)     = obj.last(endIndex);
        bs.amount(k)    = obj.amount(endIndex) - obj.amount(startIndex);    %Ԫ
        bs.volume(k)    = obj.volume(endIndex) - obj.volume(startIndex);    %��
        bs.tickNum(k)   = endIndex - startIndex + 1;
        if strcmp(obj.type, 'future')
            bs.openInt(k)   = obj.openInt(endIndex);
        end
        startIndex      = endIndex + 1;
    end    
end

% ����Ӧ�ı���
bs.settlement       = obj.close; % �����������⣡����
bs.preSettlement    = obj.preSettlement;
% bs.tickNum          = endIndex - startIndex + 1;
bs.date             = str2num(datestr(bs.time(1),'yyyymmdd'));
end
