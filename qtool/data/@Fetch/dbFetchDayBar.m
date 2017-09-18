function [ bs, Sflag ] = dbFetchDayBar(secID, req_date, slice_seconds, slice_start, levels, type)
%% �ú�����������������
% ��Ƭ����Ϊǰ�պ� [0,60)
% secID Ϊ֤ȯ���� '600000.SZ'���� 'IF1312.CFE' ǰ�������벻�ܴ�
%req_date��������� '20131219
% slice_seconds ��Ƭ��ʱ����(s) 60��ʾһ����
% slice_start ��ʾ��һ����Ƭ������ʱ��(s) 20��ʾǰ20sΪһ����Ƭ���Ժ�ÿslice_secondsһ����Ƭ
% levels ��Ƭ�ĵ��� ͨ����ƱΪ5 �ڻ�Ϊ1
% typeΪ֤ȯ����'stock'��ʾ��Ʊ ���� 'future'��ʾ�ڻ�

%HeQun 2013.12.23
if nargin < 3
    error('��Ƭ�Ĳ������㣡')
elseif nargin < 4
    slice_start = zeros(size(slice_seconds));    
end

if length(slice_seconds) ~= length(slice_start)
    error('��Ƭ�ĳ��������Ϳ�ʼʱ���������Ȳ��ȣ�');
end

bs          = Bars;
if exist('type','var') == 0
    if exist('levels','var') == 0
        [ ts, SflagT ] = dbFetchDayTick(secID, req_date);
    else
        [ ts, SflagT ] = dbFetchDayTick(secID, req_date, levels);
    end
else
    [ ts, SflagT ] = dbFetchDayTick(secID, req_date, levels, type);
end

if SflagT
    if length(slice_seconds) >1
        for k =1:length(slice_seconds)
            bs(k) = Tick2Bar(ts, slice_seconds(k), slice_start(k));
        end
    else
        bs = Tick2Bar(ts, slice_seconds, slice_start);
    end
    Sflag =1;
else
    Sflag = 0;
end
end

