function [ indBeltHoldDown ] = isBeltHoldDown(obj, bars )
%% 
% ���ձ�����ͼ��������1998��5�µ�һ�棬P99
%% Parameters
lenLimit = 0.015*obj.zoomFactor;
shadowLimit = 0.01;
%%
indLen = bars.barLen./bars.open>lenLimit;

indUpLine = bars.lineLenUp./bars.barLen<shadowLimit;
indYin = bars.yinYang==-1;
indBeltHoldDown  = indYin&indUpLine&indLen;

end

