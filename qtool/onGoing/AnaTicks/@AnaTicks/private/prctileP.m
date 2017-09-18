function [ percentile ] = prctileP( vector, value )
%PRCTILEP ��value �� vector�������еİٷ�λ
% �̸գ�140608


vector2 = vector(~any(isnan(vector),2)); %��ȥnan
len = length(vector2);
if len < 10
    fprintf('���棺vector̫С(l=%d)��percentile���ܲ�����',len);
end
        
%% ֱ�ӷ��⾭������, �����ǵ�value����vector��Χʱ
%         percentile = fzero(@(x) prctile(vector, x)-value, 50);
        
%% ��ô��������
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

