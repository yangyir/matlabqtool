function [ n ] = payoff_cjy( s )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
% s是 0，1序列
% n是数到连续3个1时s的下标
cnt = 0;

for i= 1:50 
    if s(i) == 0 
        cnt = 0;
    elseif s(i) == 1
        cnt = cnt + 1;
    end
    
    if cnt == 3
        break;
    end
    
end


n = i;

end

