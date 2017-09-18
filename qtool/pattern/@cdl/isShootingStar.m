function [ indShootingStar ] = isShootingStar(~, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P73
%% parameters
ratioLen = 3;
ratioOverlap = 0.6;
%%
ind1 = bars.lineLenUp>ratioLen*bars.barLen;
ind2 = bars.barLen>ratioLen*bars.lineLenDown;
indJump = bars.barFloor(2:end)>bars.barFloor(1:end-1)+ratioOverlap*bars.barLen(1:end-1);
indJump = vertcat(0,indJump);

indShootingStar = ind1&ind2&indJump;


end

