function [ patterns,id ] = excldPa( patterns,sless )
%EXCLDPA        �޳�С����patterns
%version 1.0, �������ز���id
%version 2.0�������ز���id����ʾ�޳���id,���к�

np = size(patterns,1);
id = 1:np;
id = id';
for i = 1:np
    npp = size(patterns{i,1},1);
    if npp < sless
        patterns{i,:}=[];
    end
end
% ����������˳��һ�����ܷ�
id = id(cellfun('isempty',patterns));
patterns(cellfun('isempty',patterns))=[];

end

