function [ obj ] = toExcel(obj, filename, sheetname1, sheetname2)
% toExcel��Ticks.headers, Ticks.data, Ticks.data2(��Ϊ�������ɣ�д��excel��
% ��ʽ��[ obj ] = toExcel(obj, filename, sheetname1, sheetname2)
% sheetname1��Ĭ��code_data���з�Ticks.headers, Ticks.data
% sheetname2��Ĭ��code_info���з�Ticks.data2
% filenameĬ��code.xlsx��Ĭ������.xlsx
% savepathĬ�ϵ�ǰ�������ר��д��filename��
% --------------------------------------------------------
% �̸գ�140715


%% Ԥ����

% Ĭ��xlsx����
className = class(obj);
if ~exist('filename', 'var')
    filename = [obj.code '_' className '.xlsx'];
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
if ~exist('sheetname1', 'var')
    sheetname1 = [obj.code '_data'];    
end

if ~exist('sheetname2', 'var')
    sheetname2 = [obj.code '_info'];
end


% ������û��data, ����������
if isempty(obj.data) || isempty(obj.data2) || isempty(obj.headers)
    obj.toTable;
end

if isnan(obj.data),     obj.toTable; end
% if isnan(obj.data2),    obj.toTable; end
% if isnan(obj.headers),  obj.toTable; end

% Ĭ�ϵ�ǰ·��


%% д������

% �Ⱥϳɣ���һ��д�룬Ч�ʸ�
all_data = [obj.headers; num2cell(obj.data)];
xlswrite(filename, all_data, sheetname1);


% xlswrite(filename, obj.data, sheetname1, 'A2');
% xlswrite(filename, obj.headers, sheetname1, 'A1');

xlswrite(filename, obj.data2, sheetname2, 'A1');



end

