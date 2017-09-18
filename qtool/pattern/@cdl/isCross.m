function [ indCross ] = isCross(obj, bars)
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P155
%%
% ratio of the barLen and open.
ratio = 0.0005*obj.zoomFactor;

indCross = (bars.barLen./bars.open<=ratio)&((bars.lineLenUp+bars.lineLenDown)>0);

end