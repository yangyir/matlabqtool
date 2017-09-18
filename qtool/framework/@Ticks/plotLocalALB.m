function [ ] = plotLocalALB( obj, stk, etk )
%PLOTLOCALALB 画ask-last-bid 图， 局部
% [ ] = plotLocalALB( obj, stk, etk )
% stk         开始的tk编号（默认1）
% etk         结束的tk编号（默认latest）
% 程刚，140731


%% 预处理

len = length(obj.time);

if ~exist('stk', 'var'), stk = 1; end
if ~exist('etk', 'var')
    if obj.latest > 1
        etk = obj.latest;
    else        
        etk = len;
    end
end

stk = max(stk,1);
etk = min(etk,len);

range = stk:etk;


%% 作图
 
% hold off

l = obj.last(range);
plot(range, l, '.k');

hold on;
try
    a = obj.askP(range,1);
    b = obj.bidP(range,1);
    plot(range, a, 'b');
    plot(range, b, 'r');
catch e
    disp('取ask，bid时出错！');
end

title( sprintf('Local ask-last-bid 图：%d - %d', stk, etk));





end

