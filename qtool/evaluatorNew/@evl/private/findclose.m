function [item] = findclose(sequence , value)
% 找一列数sequence中最靠近给的value的日期
% --------------------------------
% 唐一鑫，20150730

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