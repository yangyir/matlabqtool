function [ indPiercingUp ] = isPiercingUp( obj,bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P51
%% parameters
% Dropping margin of the first bar
dropThreshold = 0.015*obj.zoomFactor;
% Rising margin of the second bar into the first one.
upThreshold =0.5;
%%
ind1yin = bars.yinYang(1:end-1)==-1;
indDrop = bars.barLen./bars.open>dropThreshold;
indDrop = indDrop(1:end-1);
indCover = bars.open(2:end)<bars.low(1:end-1);
indPierce = bars.barCeil(2:end)>bars.barFloor(1:end-1)+upThreshold*bars.barLen(1:end-1);

indPiercingUp = ind1yin&indDrop&indCover&indPierce; 
indPiercingUp = [0;indPiercingUp];

end

