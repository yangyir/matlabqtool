function [ n ] = payoff_cjy( s )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% s�� 0��1����
% n����������3��1ʱs���±�
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

