%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ϊ����������Ե�callback�������뵥���ļ��������в��ԣ����������ļ��У���
%
% ����Ҫע�����㣺1�����Ժ������������ļ�������һ��
%                2����������ò�Ҫ��matlab������m�ļ����غϡ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StrategyExample = file_importmultistrategy_callback(StrategyExample,Path,Path2,type)

if nargin < 4
    type =1;
end

%  ѡ��һ���ļ���
folder_name = uigetdir(Path2 ,'ѡ��һ���ļ���');
if ~(folder_name == 0 )
    % ��ȡ�ļ����������ļ���
    FileName = dir(folder_name);
    FileName = struct2cell(FileName);
    FileName = (FileName(1,3:end))';
else
    FileName ={};
end
%  ����.m�ļ�
if ~isempty(FileName)
    index = cellfun(@(x) ismember((length(x)-1),strfind(x,'.m')),FileName);
    FileName = FileName(index);
    for Index = 1:length(FileName)
        FileName{Index}(end-1:end) = [];
    end
else
    return;
end

%  ���浽��������
FileName = setdiff(FileName,StrategyExample(:,1));
if ~isempty(FileName)
    newstrategyexample = cell(size(FileName,1),size(StrategyExample,2));
    for Index2 = 1:length(FileName)
        if ~ismember(FileName(Index2),StrategyExample(:,1))
            newstrategyexample(Index2,1) = FileName(Index2);
        end
    end
    
    StrategyExample = [StrategyExample;newstrategyexample];
    
    if type == 1
        xlswrite(Path,StrategyExample,'strategy');
    else
        Path = strrep(Path,'.xlsx','.mat');
        save (Path,'StrategyExample');
    end

end

end