function [ obj ] = toExcel(obj, filename, sheetname1, sheetname2)
% toExcel把Ticks.headers, Ticks.data, Ticks.data2(如为空则生成）写入excel中
% 格式：[ obj ] = toExcel(obj, filename, sheetname1, sheetname2)
% sheetname1（默认code_data）中放Ticks.headers, Ticks.data
% sheetname2（默认code_info）中放Ticks.data2
% filename默认code.xlsx，默认类型.xlsx
% savepath默认当前，否则可专门写进filename里
% --------------------------------------------------------
% 程刚；140715


%% 预处理

% 默认xlsx类型
className = class(obj);
if ~exist('filename', 'var')
    filename = [obj.code '_' className '.xlsx'];
else
    po = strfind(filename, '.xls');
    if isempty(po)
        % 添加扩展名
        filename = [filename '.xlsx']; 
    else
        po = po(end);
        ext = filename(po:end);
        if ~strcmp(ext, '.xls') ||  ~strcmp(ext, '.xlsx') ...
        || ~strcmp(ext, '.xlsm') || ~strcmp(ext, '.xlsb')
            % 改变扩展名
            filename = [filename(1:po-1) '.xlsx'];
        end
    end
end


% 默认sheetnames
if ~exist('sheetname1', 'var')
    sheetname1 = [obj.code '_data'];    
end

if ~exist('sheetname2', 'var')
    sheetname2 = [obj.code '_info'];
end


% 检验有没有data, 若无则生成
if isempty(obj.data) || isempty(obj.data2) || isempty(obj.headers)
    obj.toTable;
end

if isnan(obj.data),     obj.toTable; end
% if isnan(obj.data2),    obj.toTable; end
% if isnan(obj.headers),  obj.toTable; end

% 默认当前路径


%% 写入内容

% 先合成，再一次写入，效率高
all_data = [obj.headers; num2cell(obj.data)];
xlswrite(filename, all_data, sheetname1);


% xlswrite(filename, obj.data, sheetname1, 'A2');
% xlswrite(filename, obj.headers, sheetname1, 'A1');

xlswrite(filename, obj.data2, sheetname2, 'A1');



end

