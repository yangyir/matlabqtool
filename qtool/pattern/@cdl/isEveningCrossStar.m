function [ indEveningCrossStar ] = isEveningCrossStar(obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P67
%%
indEveningStar = obj.isEveningStar(bars);
indCross = obj.isCross(bars);
indCross = [0;indCross(1:end-1)];

indEveningCrossStar = indEveningStar&indCross;
end

