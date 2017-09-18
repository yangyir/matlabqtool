function [ percentile ] = prctileP( vector, value )
%PRCTILEP 求value 在 vector（无序）中的百分位
% 程刚；140608


vector2 = vector(~any(isnan(vector),2)); %除去nan
len = length(vector2);
if len < 10
    fprintf('警告：vector太小(l=%d)，percentile可能不靠谱',len);
end
        
%% 直接反解经常出错, 尤其是当value超出vector范围时
%         percentile = fzero(@(x) prctile(vector, x)-value, 50);
        
%% 这么做更靠谱
sorted_vector = sort(vector2);
if value < sorted_vector(1)
    percentile = 0;
elseif value > sorted_vector(end)
    percentile = 100;
else
    p_low = find(sorted_vector==value, 1, 'first');
    p_hi = find( sorted_vector==value, 1, 'last');
    if isempty(p_low)
        p_low = find(sorted_vector<value, 1, 'last');
        p_hi = find(sorted_vector>value, 1, 'first');
    end
    percentile = 100 * (p_low + p_hi)/2 /(len+1);
end

end

