function [ bs, success ] = dmDayBars(secID, reqDate, sliceSeconds, sliceStart, driver)
%% ��db��ץTicks�����г�Bars 
% �ú�����������������
% ��Ƭ����Ϊǰ�պ� [0,60)
% secID Ϊ֤ȯ���� '600000.SZ'���� 'IF1312.CFE' ǰ�������벻�ܴ���������'IFHot"�������Լ
% req_date��������� '20131219
% slice_seconds ��Ƭ��ʱ����(s) 60��ʾһ����
% slice_start ��ʾ��һ����Ƭ������ʱ��(s) 20��ʾǰ20sΪһ����Ƭ���Ժ�ÿslice_secondsһ����Ƭ
% driver ���ݴ�ŵ��̷��� �˴�Ӧ���ǿ������̷��� Ĭ����'Y'

%HeQun 2013.1.22

%% Ԥ����
if nargin < 3
    error('��Ƭ�Ĳ������㣡')
elseif nargin < 4
    sliceStart = zeros(size(sliceSeconds));
elseif nargin < 5
    driver = 'Y';   
end

% �ж���Ƭ��ʱ��θ����Ƿ�����Ƭ����ʼʱ�������ͬ
if length(sliceSeconds) ~= length(sliceStart)
    error('��Ƭ�ĳ��������Ϳ�ʼʱ���������Ȳ��ȣ�');
end

% success  = 0; % Ԥ���� Ĭ��һ��ʼ��Ƭ��û���гɹ�

%% ץTicks�� �������ݿ��е����������ޣ� ��ʱ����type��levels��������
bs          = Bars;

[ ts, successTicks ]    = dmDayTicks(secID, reqDate, driver);


%% �г�Bars
if successTicks
    if length(sliceSeconds) >1
%         ���ڶ����Ƭ������ѭ���и�
        for k =1:length(sliceSeconds)
            bs(k) = ts.toBars(sliceSeconds(k), sliceStart(k));
        end
    else
%         ֻ��һ����Ƭ���и�
        bs  = ts.toBars(sliceSeconds, sliceStart);
    end
    success =1;
else
    success = 0;
end
end

