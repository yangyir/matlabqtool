function [ indWindow ] = isWindow(~, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P123
%%
indWindowUp = bars.low(2:end)>bars.high(1:end-1);
indWindowDown = bars.high(2:end)<bars.low(1:end-1);
indWindow = indWindowUp|indWindowDown;
indWindow = vertcat(0,indWindow);


end

