function [ obj ] = updateBid( obj, origin )
%UPDATEbid ��origin�е�bid����ע��obj
% �̸գ�151111

%%
c1 = class(obj);
c2 = class(origin);

if ~strcmp(c1, c2) 
    error(['error: original class = ' c1  '; origin class = ' c2 '!']);
end




%%
flds = {
       'bidQ1';%������1	
       'bidP1';%������1	
       'bidQ2';%������2	
       'bidP2';%������2	
       'bidQ3';%������3	
       'bidP3';%������3	
       'bidQ4';%������4	
       'bidP4';%������4	
       'bidQ5';%������5	
       'bidP5';%������5	
       };


for i = 1:length(flds)
    fd          = flds{i};
    obj.(fd) = origin.(fd);
end    



end

