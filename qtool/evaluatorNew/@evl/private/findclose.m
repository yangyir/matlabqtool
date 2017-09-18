function [item] = findclose(sequence , value)
% ��һ����sequence���������value������
% --------------------------------
% ��һ�Σ�20150730

minvalue = inf;
k = 0;
for i = 1 : length(sequence)
    delta = abs(sequence(i) -  value);
    if(minvalue > delta)
        minvalue = delta;
        k = i;
    end
end

item = k;

end