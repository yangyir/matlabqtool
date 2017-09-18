function [ obj ] = updateAsk( obj, origin )
%UPDATEASK 把origin中的ask量价注入obj
% 程刚，151111

%%
c1 = class(obj);
c2 = class(origin);

if ~strcmp(c1, c2) 
    error(['error: original class = ' c1  '; origin class = ' c2 '!']);
end




%%
flds = {
       'askQ1';%申卖量1	
       'askP1';%申卖价1	
       'askQ2';%申卖量2	
       'askP2';%申卖价2	
       'askQ3';%申卖量3	
       'askP3';%申卖价3	
       'askQ4';%申卖量4	
       'askP4';%申卖价4	
       'askQ5';%申卖量5	
       'askP5';%申卖价5	
       };


for i = 1:length(flds)
    fd          = flds{i};
    obj.(fd) = origin.(fd);
end    



end

