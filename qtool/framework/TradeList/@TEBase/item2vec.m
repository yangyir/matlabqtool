function [itemVec] = item2vec(obj,seqNo)
itemVec = zeros(length(seqNo),length(obj.headers));

for i = 1:length(obj.headers)
    itemVec(:,i) = obj.(obj.headers{i})(seqNo);
end

end