function [ indMorningCrossStar ] = isMorningCrossStar(obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P67
%%
indMorningStar = obj.isMorningStar(bars);
indCross = obj.isCross(bars);
indCross = [0;indCross(1:end-1)];

indMorningCrossStar = indMorningStar&indCross;

end

