function [ obj ] = fromExcel( obj, filename )
% 从excel，csv读入矩阵，存成Matrix2DBase
% ---------------
% 程刚，20150614，一个粗糙的应急版本



%% 预处理



% 取得data的大小



%% main
[~, ~, raw] = xlsread(filename);


%% 如果有，读取xProps
xProps = raw(1,2:end);



% 如果是数字，变成string
xProps2 = cell(size(xProps));
for i = 1:length(xProps)
    p = xProps{i};
    if isa( p, 'double'),  
        p_str = num2str( p); 
        xProps2{i} = p_str;
    else
        xProps2{i} = p;
    end
end


%% 如果有，读取yProps
yProps = raw(2:end,1);

% 如果是数字，变成string
yProps2 = cell(size(yProps));
for i = 1:length(yProps)
    p = yProps{i};
    if isa(p, 'double'),  
        p_str = num2str(p); 
        yProps2{i} = p_str;
    else
        yProps2{i} = p;
    end
end




%% 读取data
data1 = raw(2:end, 2:end);
data2 = cell2mat(data1);



%% 整理一下
obj.xProps = xProps2;
obj.yProps = yProps2;
obj.data   = data2;
obj.autoFill;




end

