function [] = add(obj,obj2)
% Лузм
if obj2.latest ==0
    return;
end

for i = 1:length(obj.headers)
    obj.(obj.headers{i})(obj.latest+1:obj.latest+obj2.latest) = obj2.(obj.headers{i})(1:obj2.latest);
end

obj.isSorted = 0;
obj.latest = obj.latest+obj2.latest;
if obj.capacity<obj.latest
    obj.capacity = obj.latest;
end

end