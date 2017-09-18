function [ indTweezerBottom ] = isTweezerBottom(obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P91
%% Parameters
gapRatio = 0.0005*obj.zoomFactor;
%%
ind12 = abs(bars.low(1:end-1)-bars.low(2:end))<gapRatio*bars.low(1:end-1);
indHalt = obj.isHalt(bars);
indHalt = indHalt(2:end);

indTweezerBottom = ind12&(~indHalt);

pSize = 2;
indTweezerBottom = [zeros(pSize-1,1);indTweezerBottom];

end

