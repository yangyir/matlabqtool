function [ obj ] = toExcel(obj, filename, sheetname)
% toExcel把TEBase.headers, TEBase.data(如为空则生成）写入excel中
% 格式：[ obj ] = toExcel(obj, filename, sheetname)
% sheetname（默认'data'）中放Ticks.headers, Ticks.data
% filename默认my_className.xlsx，默认类型.xlsx
% savepath默认当前，否则可专门写进filename里
% --------------------------------------------------------
% 程刚；140806


%% 预处理

% 默认xlsx类型
className = class(obj);
if ~exist('filename', 'var')
    filename = [ 'my_' className '.xlsx'];
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
if ~exist('sheetname', 'var')
    sheetname = ['data'];    
end


% 这个检验还是很纠结的，是否强制生成算了？

% % 强制重新生成data
% obj.toTable;

% 检验有没有data, 若无则生成
if isempty(obj.data) || isempty(obj.headers)
    obj.toTable;
end

if isnan(obj.data),     obj.toTable; end

% 默认当前路径


%% 写入内容

% 先合成，再一次写入，效率高
all_data = [obj.headers; num2cell(obj.data)];
xlswrite(filename, all_data, sheetname);


end
