%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڽ�ͼ�ν��汣��Ϊjpeg��׺��ͼƬ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file_save_callback(f)

[FileName,FilePath] = uiputfile('*.jpeg');
if ~(FileName == 0)
    FileName = strcat(FilePath,FileName);
    saveas(f,FileName);
end
end