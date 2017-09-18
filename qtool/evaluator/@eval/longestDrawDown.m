function [ span, t1, t2 ] = longestDrawDown( nav )
% 最长连续回撤天数（不创新高天数）
% [ span, t1, t2 ] = LongestDrawDown( nav )
% nav:  净值序列
% span: 最长回撤天数
% t1:   最长回撤起点
% t2:   最长回撤终点
% ----------------------------
% 程刚，20150510

%% main
nP              = size(nav,1);

% 新高
isNewHi         = ones(nP,1);
h               = evl.preHigh(nav);
isNewHi(2:end)  = h(2:end) > h(1:end-1);

% 数连续回撤
ddCount         = zeros(nP,1);

for t = 2:nP
    if isNewHi(t) == 1 % 创新高
        ddCount(t) = 0;      
    else   % 未创新高，回撤中
        ddCount(t) = ddCount(t-1) + 1;
   end
end

% 最长连续回撤天数
[span, t2 ] = max(ddCount);
t1          = t2-span+1;

end

