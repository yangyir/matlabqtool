
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数为单个导入策略的callback
%
% 这里要注意两点：1、策略函数名必须与文件名保持一致
%                2、策略名最好不要与matlab中已有m文件名重合。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function StrategyExample = file_importsinglestrategy_callback(StrategyExample,Path,type)

if nargin < 3
    type = 1;
end

% 获取文件名和路径
[FileName,~] = uigetfile('*.m','Pick a file','MultiSelect', 'on');


if iscell(FileName)
    % 保留.m文件
    index = cellfun(@(x) ismember((length(x)-1),strfind(x,'.m')),FileName);
    FileName = FileName(index);
    % 后缀去掉
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

% 将导入的策略名，写入数据样例
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