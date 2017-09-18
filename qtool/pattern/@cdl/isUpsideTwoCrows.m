function [ indUpsideTwoCrows ] = isUpsideTwoCrows(~, bars)
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P101
indGap = bars.barCeil(1:end-2)<bars.barFloor(2:end-1);
indFirstCrow = bars.yinYang(2:end-1)==-1;
indSecondCrow = bars.yinYang(3:end)==-1;
indEngulf = (bars.barCeil(2:end-1)<bars.barCeil(3:end))&(bars.barFloor(2:end-1)>bars.barFloor(3:end));

indUpsideTwoCrows = indGap&indFirstCrow&indSecondCrow&indEngulf;

pSize = 3;
indUpsideTwoCrows = [zeros(pSize-1,1);indUpsideTwoCrows];

end

