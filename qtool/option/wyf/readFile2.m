
function tempData = readFile2(filename)
%  这是读取带有逗号的数据
% demo
%  Data = readFile2('20150207.out_9002.out');

data = textread(filename,'%s','delimiter','\n','headerlines',1);

%  进行分裂

data = regexp(data,',','split');
nCol = length(data{1});

tempData = cell( length(data) , nCol );
for i = 1:length(data)
    tempData(i,:) = data{i};
end

clear('data')

end