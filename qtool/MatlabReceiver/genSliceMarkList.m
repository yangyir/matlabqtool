function [ fullList ] = genSliceMarkList( sliceMark )
%GENSLICEMARKLIST generate a full list of slice marks, according the seed
%mark.
%%
if sliceMark<100
    step = sliceMark;
else
    step = sliceMark-mod(sliceMark,100);
end
fullList = (91500+mod(sliceMark,100)):step:151500;
fullList(mod(fullList,10000)>5959) = [];
fullList(mod(fullList,100)>59)=[];
fullList(fullList>113000&fullList<130000) = [];

% 113000 and 130000 are the same mark, delete the latter
if max(diff(fullList))==17000
    fullList(fullList==113000)=[];
end

end
