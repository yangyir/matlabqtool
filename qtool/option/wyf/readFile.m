
function readFile(file)
%  file是文件夹的名称
% demo
%  file = 'F:\myDriversFile\MyDriversMatlab\Mfiles13\20150207';
%  readFile(file)

if ~isdir(file)
    warndlg('您输入的文件夹的名称不存在','警告');
    return;
end

allNameStr = dir(file);

if length(allNameStr) < 3
    warndlg('您输入的文件夹没有任何数据','警告');
    return;
end

for i = 3:length(allNameStr)
    
    disp(['********************第',num2str(i - 2),'个数据处理完毕********************'])
    
    filename = [file , '\' ,allNameStr(i).name];
    data = readFileOne(filename);
    
    %  输送到workspace上
    baseName = ['Data_',allNameStr(i).name];
    assignin('base',baseName,data);
    
end



end


function tempData4 = readFileOne(filename)
% demo
%  data = readFileOne('test');

tempData1 = textread(filename,'%s','delimiter','\n');

tempData2 = regexp(tempData1 , '		','split');

nLength = length(tempData2{1});

tempData3 = cell(length(tempData2),nLength);

for i = 1:length(tempData2)
    tempData3(i,:) = regexp(tempData2{i} ,'	','split');
end

dataLength = cellfun( @length , tempData3(1,:) );
sumLength = sum( cellfun(@length,tempData3(1,:))  ) ;
tempData4 = cell( length(tempData2) , sumLength );

for i = 1:length(tempData2)
    lines = tempData3( i , :);
    linesData = [];
    for j = 1: nLength
        linesData = [linesData lines{j}];
    end
    tempData4(i,:) = linesData;
end

tempData4(:,end) = [];

end


