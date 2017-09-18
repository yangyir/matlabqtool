function [ indRickshaw ] = isRickshaw(obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P164
%%
errorLimit = 0.2;
indLongLeggedCross = obj.isLongLeggedCross(bars);
indMiddle = abs(bars.lineLenUp./bars.lineLenDown-1)<errorLimit;

indRickshaw = indLongLeggedCross&indMiddle;

end

