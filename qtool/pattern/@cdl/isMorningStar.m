function [ indMorningStar ] = isMorningStar( obj,bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P58
%% parameters
pierceRatio = 0.5;
%%
indStar = obj.isStar(bars);
indStar = indStar(2:end-1);
indYinYang = (bars.yinYang(1:end-2)==-1)&(bars.yinYang(3:end)==1);
indPierce = bars.barCeil(3:end)>bars.barFloor(1:end-2)+pierceRatio*bars.barLen(1:end-2);

indMorningStar = indStar&indYinYang&indPierce;

pSize = 3;
indMorningStar= [zeros(pSize-1,1);indMorningStar];
end

