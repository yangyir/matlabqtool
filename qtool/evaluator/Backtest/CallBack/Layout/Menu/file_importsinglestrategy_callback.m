
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ϊ����������Ե�callback
%
% ����Ҫע�����㣺1�����Ժ������������ļ�������һ��
%                2����������ò�Ҫ��matlab������m�ļ����غϡ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function StrategyExample = file_importsinglestrategy_callback(StrategyExample,Path,type)

if nargin < 3
    type = 1;
end

% ��ȡ�ļ�����·��
[FileName,~] = uigetfile('*.m','Pick a file','MultiSelect', 'on');


if iscell(FileName)
    % ����.m�ļ�
    index = cellfun(@(x) ismember((length(x)-1),strfind(x,'.m')),FileName);
    FileName = FileName(index);
    % ��׺ȥ��
    for Index = 1:length(FileName)
        FileName{Index}(end-1:end) = [];
    end
    
elseif FileName == 0
    return;
else
    if strcmp(FileName(end-1:end),'.m')
        FileName(end-1:end) = [];
        FileName = cellstr(FileName);
    end
end

% ������Ĳ�������д����������
FileName = setdiff(FileName,StrategyExample(:,1));
if ~isempty(FileName)
    newstrategyexample = cell(size(FileName,1),size(StrategyExample,2));
    for Index2 = 1:length(FileName)
        if ~ismember(FileName(Index2),StrategyExample(:,1))
            newstrategyexample(Index2,1) = FileName(Index2);
        end
    end
    
    StrategyExample = [StrategyExample;newstrategyexample];
    if  type ==1
        xlswrite(Path,StrategyExample,'strategy');
    else
        Path = strrep(Path,'.xlsx','.mat');
        save (Path,'StrategyExample');
    end

end
end