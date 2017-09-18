function [ outCell ] = my_struct2cell( inStruct )
%% Convert a struct to cell array.
%
%%
outCell = [];
% flag = 1, members of inStruct is all scalar.
flag =1;
if ~isstruct(inStruct)
    error('Input argument should be a struct')
end

fnames = fieldnames(inStruct);
content = struct2cell(inStruct);

% Now, spread,if any, nonscalar members for struct.
numField = size(fnames,1);
for i = 1:numField
    member_i = inStruct.(fnames{i});
    if isstruct(member_i)
        if i>1&&~isequal(fieldnames(member_i),fieldnames(inStruct.(fnames{i-1})))
            error('Fieldname of substruct not consistent.');
        end
        flag = 0;
        outCell = horzcat(outCell,my_struct2cell(member_i));
    end      
end

if flag
    outCell = horzcat(fnames,content);
else
    outCell(:,3:2:2*numField)=[];
    outCell = vertcat(horzcat({' '},fnames'),outCell);
end
end


