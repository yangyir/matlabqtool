%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������������ͼ�ν�������Ļ��λ��
% һ��Ϊ1*4���󡣵�һ��ֵ�������º����꣬�ڶ���ֵ�������������꣬
% ������ֵ�����ȣ����ĸ�ֵ����߶ȡ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  f = option_setfigureposition(f,path_backtest_configure,type)

if nargin <2
    type = 1;
end

prompt = {'���º�����:','����������:','���','�߶�'};
dlg_title = 'ͼ�ν�������Ļ��λ��';
num_lines = 1;
def =cellstr(num2str(f'));
input_arg = inputdlg(prompt,dlg_title,num_lines,def);

if ~isempty(input_arg )
    if type == 1
        %  ����Ϊ�ı�
        input_arg2 = cellstr(strcat(['''';'''';'''';''''],char(input_arg)));
        %  д����ʼ�����ļ���
        xlswrite(path_backtest_configure,input_arg2,'Layout','B1:B4');
        f = [str2double(input_arg{1,1}),str2double(input_arg{2,1}),str2double(input_arg{3,1}),str2double(input_arg{4,1})];
    else
        Figure_Position = [str2double(input_arg{1,1}),str2double(input_arg{2,1}),str2double(input_arg{3,1}),str2double(input_arg{4,1})];
        path_backtest_configure = strrep(path_backtest_configure,'.xlsx','.mat');
        save (path_backtest_configure,'Figure_Position','-append');
        f = Figure_Position;
    end
end


end