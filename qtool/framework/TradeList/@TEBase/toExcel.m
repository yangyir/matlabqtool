function [ obj ] = toExcel(obj, filename, sheetname)
% toExcel��TEBase.headers, TEBase.data(��Ϊ�������ɣ�д��excel��
% ��ʽ��[ obj ] = toExcel(obj, filename, sheetname)
% sheetname��Ĭ��'data'���з�Ticks.headers, Ticks.data
% filenameĬ��my_className.xlsx��Ĭ������.xlsx
% savepathĬ�ϵ�ǰ�������ר��д��filename��
% --------------------------------------------------------
% �̸գ�140806


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
    sheetname = ['data'];    
end


% ������黹�Ǻܾ���ģ��Ƿ�ǿ���������ˣ�

% % ǿ����������data
% obj.toTable;

% ������û��data, ����������
if isempty(obj.data) || isempty(obj.headers)
    obj.toTable;
end

if isnan(obj.data),     obj.toTable; end

% Ĭ�ϵ�ǰ·��


%% д������

% �Ⱥϳɣ���һ��д�룬Ч�ʸ�
all_data = [obj.headers; num2cell(obj.data)];
xlswrite(filename, all_data, sheetname);


end
