function [] = prune(obj)
%% ��ȥ����ռ�


if obj.capacity==obj.latest
    return;
end

obj.capacity = obj.latest;

for i = 1:length(obj.headers)
    obj.(obj.headers{i})(obj.latest+1:end) = [];
end
end
