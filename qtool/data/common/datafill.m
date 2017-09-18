function [ r ] = datafill( bars, idx )
%DATAFILL       ���հ����ݣ�ʹ��ʱ���ϸ��걸
%   inputs:
%   bars:           ԭ���ݣ�Bars��
%   idx:           1Ϊ��ָ�ڻ����ݣ�2Ϊ��Ʊָ������
%   outputs:
%   r
% ver 1.0 , luhuaibao

Date=unique(floor(bars.time)); % ��ȡ��������
Date(end)=[]; % �����������һ��������ֻ��һ��ʱ����ڣ�ֱ��ɾ��
ReferenceDate=repmat(Date,270,1); 
ReferenceDate=sort(ReferenceDate); 
switch idx
    case 1
        Dailytime_morning=(9/24+16/(24*60)):1/(24*60):(11/24+30/(24*60));
        Dailytime_afternoon=(13/24+1/(24*60)):1/(24*60):(15/24+15/(24*60));
    case 2
        Dailytime_morning=(9/24+31/(24*60)):1/(24*60):(11/24+30/(24*60));
        Dailytime_afternoon=(13/24+1/(24*60)):1/(24*60):(15/24+0/(24*60));
end;

Dailytime=[Dailytime_morning Dailytime_afternoon]'; % һ�������Ľ����յ�ʱ������
ReferenceDailytime=repmat(Dailytime,length(Date),1); 
Referencetime=ReferenceDailytime+ReferenceDate;

[flag,id]=ismember(Referencetime,bars.time); %�ҳ�ȱʧ����λ��

var=nan(length(Referencetime),1);% var������ʱ�洢
% ���open
for i=1:length(flag)
    if flag(i)==1
        var(i)=bars.open(id(i));
    end
    if flag(i)==0 
        var(i)=(bars.open(id(find(id(1:i)>0,1,'last')))+bars.open(id(i-1+find(id(i:end)>0,1,'first'))))/2; % ȱʧ��������λ����һ������һ�������ݵľ�ֵ����
    end
end
bars.open = var;
% ���high
for i=1:length(flag)
    if flag(i)==1
        var(i)=bars.high(id(i));
    end
    if flag(i)==0 
        var(i)=(bars.high(id(find(id(1:i)>0,1,'last')))+bars.high(id(i-1+find(id(i:end)>0,1,'first'))))/2;
    end
end
bars.high = var;
% ���low
for i=1:length(flag)
    if flag(i)==1
        var(i)=bars.low(id(i));
    end
    if flag(i)==0 
        var(i)=(bars.low(id(find(id(1:i)>0,1,'last')))+bars.low(id(i-1+find(id(i:end)>0,1,'first'))))/2;
    end
end
bars.low = var;
% ���close
for i=1:length(flag)
    if flag(i)==1
        var(i)=bars.close(id(i));
    end
    if flag(i)==0 
        var(i)=(bars.close(id(find(id(1:i)>0,1,'last')))+bars.close(id(i-1+find(id(i:end)>0,1,'first'))))/2;
    end
end
bars.close = var;

% ���vwap ����ǿ�
if ~isempty(bars.vwap)
    for i=1:length(flag)
        if flag(i)==1
            var(i)=bars.vwap(id(i));
        end
        if flag(i)==0 
            var(i)=(bars.vwap(id(find(id(1:i)>0,1,'last')))+bars.vwap(id(i-1+find(id(i:end)>0,1,'first'))))/2;
        end
    end
bars.vwap = var;
end
% ���volume ����ǿ�
if ~isempty(bars.volume)
    for i=1:length(flag)
        if flag(i)==1
            var(i)=bars.volume(id(i));
        end
        if flag(i)==0 
            var(i)=(bars.volume(id(find(id(1:i)>0,1,'last')))+bars.volume(id(i-1+find(id(i:end)>0,1,'first'))))/2;
        end
    end
bars.volume = var;
end
% ���amount ����ǿ�
if ~isempty(bars.amount)
    for i=1:length(flag)
        if flag(i)==1
            var(i)=bars.amount(id(i));
        end
        if flag(i)==0 
            var(i)=(bars.amount(id(find(id(1:i)>0,1,'last')))+bars.amount(id(i-1+find(id(i:end)>0,1,'first'))))/2;
        end
    end
bars.amount = var;
end

% ���amount ����ǿ�
if ~isempty(bars.openInterest)
    for i=1:length(flag)
        if flag(i)==1
            var(i)=bars.openInterest(id(i));
        end
        if flag(i)==0 
            var(i)=(bars.openInterest(id(find(id(1:i)>0,1,'last')))+bars.openInterest(id(i-1+find(id(i:end)>0,1,'first'))))/2;
        end
    end
bars.openInterest = var;
end

% update time
bars.time = Referencetime;
% save
switch idx
    case 1
        dataIF = bars;
%         save('dataIFDH.mat','dataIFDH');  
        r = bars;
    case 2
        dataHS = bars;
%         save('dataHS.mat','dataHS');   
        r = bars;
end;

end

