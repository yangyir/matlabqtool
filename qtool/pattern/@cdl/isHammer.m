function indHammer = isHammer(~,bars)
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P30
%% parameters
ratio = 3;
%%
ind1 = bars.lineLenDown>ratio*bars.barLen;
ind2 = bars.barLen>ratio*bars.lineLenUp;
indHammer = ind1&ind2;

end


