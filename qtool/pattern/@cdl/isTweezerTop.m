function [ indTweezerTop ] = isTweezerTop(obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P91
%% parameters
gapRatio = 0.0005*obj.zoomFactor;
%%
ind12 = abs(bars.high(1:end-1)-bars.high(2:end))<gapRatio*bars.high(1:end-1);
indHalt = obj.isHalt(bars);
indHalt = indHalt(2:end);

indTweezerTop = ind12&(~indHalt);
pSize = 2;
indTweezerTop = [zeros(pSize-1,1);indTweezerTop];
end

