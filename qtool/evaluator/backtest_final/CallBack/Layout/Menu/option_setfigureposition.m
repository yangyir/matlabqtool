%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于设置图形界面在屏幕的位置
% 一般为1*4矩阵。第一个值代表左下横坐标，第二个值代表左下纵坐标，
% 第三个值代表宽度，第四个值代表高度。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  f = option_setfigureposition(f,path_backtest_configure,type)

if nargin <2
    type = 1;
end

prompt = {'左下横坐标:','左下纵坐标:','宽度','高度'};
dlg_title = '图形界面在屏幕中位置';
num_lines = 1;
def =cellstr(num2str(f'));
input_arg = inputdlg(prompt,dlg_title,num_lines,def);

if ~isempty(input_arg )
    if type == 1
        %  设置为文本
        input_arg2 = cellstr(strcat(['''';'''';'''';''''],char(input_arg)));
        %  写到初始设置文件中
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