function [ indBeltHoldUp ] = isBeltHoldUp( obj,bars )
%% 
% ���ձ�����ͼ��������1998��5�µ�һ�棬P99
%% Parameters
lenLimit = 0.015*obj.zoomFactor;
shadowLimit = 0.01;
%%
indLen = bars.barLen./bars.open>lenLimit;

indDownLine = bars.lineLenDown./bars.barLen<shadowLimit;
indYang = bars.yinYang==1;
indBeltHoldUp = indLen&indYang&indDownLine;

end

