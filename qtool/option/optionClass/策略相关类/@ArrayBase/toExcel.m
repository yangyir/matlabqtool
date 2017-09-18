function [ filename ] = toExcel(obj, filename, sheetname, start_pos, end_pos)
% toExcel��TEBase.headers, TEBase.data(��Ϊ�������ɣ�д��excel��
% ��ʽ��[ obj ] = toExcel(obj, filename, sheetname)
% sheetname��Ĭ��'data'���з�Ticks.headers, Ticks.data
% filenameĬ��my_className.xlsx��Ĭ������.xlsx
% savepathĬ�ϵ�ǰ�������ר��д��filename��
% ���Ʒ�:�޸�һ��Bug��empty case:ԭ[if end_pos <= start_pos]�޸�Ϊ[if end_pos < start_pos]
% --------------------------------------------------------
% �̸գ�140806
% ���Ʒ壻161117


%% Ԥ����

% Ĭ��xlsx����
className = class(obj);
if ~exist('filename', 'var')
    filename = [ 'my_' className '.xlsx'];
else
    po = strfind(filename, '.xls');
    if isempty(po)
        % �����չ��
        filename = [filename '.xlsx']; 
    else
        po = po(end);
        ext = filename(po:end);
        if ~strcmp(ext, '.xls') ||  ~strcmp(ext, '.xlsx') ...
        || ~strcmp(ext, '.xlsm') || ~strcmp(ext, '.xlsb')
            % �ı���չ��
            filename = [filename(1:po-1) '.xlsx'];
        end
    end
end


% Ĭ��sheetnames
if ~exist('sheetname', 'var')
    sheetname = class(obj.node);
end

if ~exist('start_pos', 'var')
    start_pos = 1;
end

if ~exist('end_pos', 'var')
    end_pos = start_pos + length(obj.node) - 1; 
end

% empty case
if end_pos < start_pos
    return;
end
% ǿ����������data
obj.toTable(start_pos, end_pos);



%% д������
all_data = obj.table;
if isempty(all_data), all_data = {''}; end
xlswrite(filename, all_data, sheetname);


end
