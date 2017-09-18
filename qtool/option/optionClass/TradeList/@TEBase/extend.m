function [] = extend(obj,addCapacity)
%% À©Õ¹¿Õ¼ä
% À©Õ¹

if nargin ==1
    addCapacity =1000;
end

obj.capacity = obj.capacity +addCapacity;

for i = 1:length(obj.headers)
    obj.(obj.headers{i}) = [obj.(obj.headers{i}) ; zeros(addCapacity,1)];
end
end