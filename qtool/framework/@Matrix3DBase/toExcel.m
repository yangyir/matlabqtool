function [ output_args ] = toExcel( obj, filename )
%TOEXCEL toExcel��Matrix2DBaseд��excel��
% ��ʽ��[ obj ] = toExcel(obj, filename, sheetname)
% sheetname��Ĭ��code_data���з�Bars.headers, Bars.data
% filenameĬ��des_des2_className.xlsx��Ĭ������.xlsx
% ����Ҫsavepath����Ҫָ����д��filename��
% --------------------------------------------------------
% �̸գ�150506

%% Ԥ����
% Ĭ��xlsx����
className = class(obj);
if ~exist('filename', 'var')
    % Ĭ���ļ���
    filename = [obj.des '_' obj.des2 '_' className '.xlsx'];
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
% if ~exist('sheetname', 'var')
%     sheetname = [obj.des2 '_data'];    
% end

% ������û��data, ���������ɣ�ͬʱ��¼���ޣ����Ҫ��ԭ
if isnan(obj.data)
    error('data��Ϊ��');
end



%% д������
% ���򣺣���չ������д��Nz��   Ny*Nx��

for i = 1 : Nz
    sheetname = zProps(i);
    
    data2D = obj.data(i,:,:);
        
    % �Ⱥϳɣ���һ��д�룬Ч�ʸ�
    all_data = [obj.xProps; num2cell(data2D)];
% xlswrite([savepath,'/', filename], all_data, sheetname);
    xlswrite( filename, all_data, sheetname);
    
end


end

