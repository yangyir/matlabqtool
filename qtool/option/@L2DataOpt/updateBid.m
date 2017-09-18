function [ obj ] = updateBid( obj, origin )
%UPDATEbid 把origin中的bid量价注入obj
% 程刚，151111

%%
c1 = class(obj);
c2 = class(origin);

if ~strcmp(c1, c2) 
    error(['error: original class = ' c1  '; origin class = ' c2 '!']);
end




%%
flds = {
       'bidQ1';%申卖量1	
       'bidP1';%申卖价1	
       'bidQ2';%申卖量2	
       'bidP2';%申卖价2	
       'bidQ3';%申卖量3	
       'bidP3';%申卖价3	
       'bidQ4';%申卖量4	
       'bidP4';%申卖价4	
       'bidQ5';%申卖量5	
       'bidP5';%申卖价5	
       };


for i = 1:length(flds)
    fd          = flds{i};
    obj.(fd) = origin.(fd);
end    



end

