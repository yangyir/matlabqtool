function [ obj ] = updateAsk( obj, origin )
%UPDATEASK ��origin�е�ask����ע��obj
% �̸գ�151111

%%
c1 = class(obj);
c2 = class(origin);

if ~strcmp(c1, c2) 
    error(['error: original class = ' c1  '; origin class = ' c2 '!']);
end




%%
flds = {
       'askQ1';%������1	
       'askP1';%������1	
       'askQ2';%������2	
       'askP2';%������2	
       'askQ3';%������3	
       'askP3';%������3	
       'askQ4';%������4	
       'askP4';%������4	
       'askQ5';%������5	
       'askP5';%������5	
       };


for i = 1:length(flds)
    fd          = flds{i};
    obj.(fd) = origin.(fd);
end    



end

