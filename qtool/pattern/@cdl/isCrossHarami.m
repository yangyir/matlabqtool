function [ indCrossHarami ] = isCrossHarami(obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P89
%%
indHarami = obj.isHarami(bars);
indCross = obj.isCross(bars);

indCrossHarami = indCross&indHarami;

end

