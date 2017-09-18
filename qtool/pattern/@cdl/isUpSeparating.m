function [ indUpSeparating ] = isUpSeparating(obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P153
%% Parameters
errorLimit = 0.001*obj.zoomFactor;
%%
ind1 = bars.yinYang(1:end-1)==-1;
ind2 = bars.yinYang(2:end)==1;
indOpen = abs(bars.open(2:end)-bars.open(1:end-1))./bars.open(1:end-1)<errorLimit;
indBeltHold = obj.isBeltHoldUp(bars);
indBeltHold = indBeltHold(2:end);

indUpSeparating = ind1&ind2&indOpen&indBeltHold;

pSize = 2;
indUpSeparating = [zeros(pSize-1,1);indUpSeparating];
end

