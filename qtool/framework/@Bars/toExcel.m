function [ obj ] = toExcel(obj, filename, sheetname1, sheetname2)
% toExcel��Bars.headers, Bars.data, Bars.data2(��Ϊ�������ɣ�д��excel��
% ��ʽ��[ obj ] = toExcel(obj, filename, sheetname1, sheetname2)
% sheetname1��Ĭ��code_data���з�Bars.headers, Bars.data
% sheetname2��Ĭ��code_info���з�Bars.data2
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


% ������û��data, ���������ɣ�ͬʱ��¼���ޣ����Ҫ��ԭ
dataWasEmpty = 0;
if isempty(obj.data) || isempty(obj.data2) || isempty(obj.headers)
    obj.toTable;
    dataWasEmpty = 1;
end

if isnan(obj.data),     obj.toTable;     dataWasEmpty = 1; end

% Ĭ�ϵ�ǰ·��


%% д������

% �Ⱥϳɣ���һ��д�룬Ч�ʸ�
all_data = [obj.headers; num2cell(obj.data)];
xlswrite(filename, all_data, sheetname1);

xlswrite(filename, obj.data2, sheetname2, 'A1');

%% ��ԭ
if dataWasEmpty
    obj.data = [];
    obj.data2 =[];
    obj.headers = [];
end

end

