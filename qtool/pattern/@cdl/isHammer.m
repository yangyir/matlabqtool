function indHammer = isHammer(~,bars)
%%
% 《日本蜡烛图技术》，1998年5月第一版，P30
%% parameters
ratio = 3;
%%
ind1 = bars.lineLenDown>ratio*bars.barLen;
ind2 = bars.barLen>ratio*bars.lineLenUp;
indHammer = ind1&ind2;

end


