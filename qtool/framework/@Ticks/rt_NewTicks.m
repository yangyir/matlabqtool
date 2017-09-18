function [ obj ] = rt_NewTicks( obj, T, levels )
%RT_NEWTICKS 实盘：初始化用
%    

%% 

obj.levels = levels;

obj.time = zeros(T, 1);
obj.time2 = zeros(T, 1);
obj.last = zeros(T,1);
obj.volume  = zeros(T,1);
obj.amount  = zeros(T,1);
obj.tranCnt  = zeros(T,1);


%%
obj.bidP = zeros(T, levels);
obj.askP = zeros(T, levels);
obj.bidQ = zeros(T, levels);
obj.askQ = zeros(T, levels);
obj.bidA = zeros(T, levels);
obj.askA = zeros(T, levels);

%%
obj.latest = 0;



end

