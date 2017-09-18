function [ patterns,id ] = excldPa( patterns,sless )
%EXCLDPA        剔除小样本patterns
%version 1.0, 不带返回参数id
%version 2.0，带返回参数id，表示剔除的id,即行号

np = size(patterns,1);
id = 1:np;
id = id';
for i = 1:np
    npp = size(patterns{i,1},1);
    if npp < sless
        patterns{i,:}=[];
    end
end
% 以下两步的顺序一定不能反
id = id(cellfun('isempty',patterns));
patterns(cellfun('isempty',patterns))=[];

end

