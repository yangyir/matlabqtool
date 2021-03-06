function [ output_args ] = toExcel( obj, filename )
%TOEXCEL toExcel把Matrix2DBase写入excel中
% 格式：[ obj ] = toExcel(obj, filename, sheetname)
% sheetname（默认code_data）中放Bars.headers, Bars.data
% filename默认des_des2_className.xlsx，默认类型.xlsx
% 不需要savepath，如要指定，写进filename里
% --------------------------------------------------------
% 程刚；150506

%% 预处理
% 默认xlsx类型
className = class(obj);
if ~exist('filename', 'var')
    % 默认文件名
    filename = [obj.des '_' obj.des2 '_' className '.xlsx'];
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
% if ~exist('sheetname', 'var')
%     sheetname = [obj.des2 '_data'];    
% end

% 检验有没有data, 若无则生成，同时记录有无，最后要还原
if isnan(obj.data)
    error('data域为空');
end



%% 写入内容
% 规则：ｚ轴展开，即写成Nz个   Ny*Nx　

for i = 1 : Nz
    sheetname = zProps(i);
    
    data2D = obj.data(i,:,:);
        
    % 先合成，再一次写入，效率高
    all_data = [obj.xProps; num2cell(data2D)];
% xlswrite([savepath,'/', filename], all_data, sheetname);
    xlswrite( filename, all_data, sheetname);
    
end


end

