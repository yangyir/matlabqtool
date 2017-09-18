%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于将图形界面保存为jpeg后缀的图片
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file_save_callback(f)

[FileName,FilePath] = uiputfile('*.jpeg');
if ~(FileName == 0)
    FileName = strcat(FilePath,FileName);
    saveas(f,FileName);
end
end