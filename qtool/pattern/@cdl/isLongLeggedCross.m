function [ indLongLeggedCross ] = isLongLeggedCross( obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P164
%% Parameters
legLimit = 0.01*obj.zoomFactor;
%%
indCross = obj.isCross(bars);
indLongLeg = bars.lineLenUp./bars.open>legLimit & bars.lineLenDown./bars.open>legLimit;

indLongLeggedCross = indCross&indLongLeg;


end

