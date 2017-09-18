%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数为批量导入策略的callback，即导入单个文件夹中所有策略（不包括子文件夹）。
%
% 这里要注意两点：1、策略函数名必须与文件名保持一致
%                2、策略名最好不要与matlab中已有m文件名重合。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StrategyExample = file_importmultistrategy_callback(StrategyExample,Path,Path2,type)

if nargin < 4
    type =1;
end

%  选择一个文件夹
folder_name = uigetdir(Path2 ,'选择一个文件夹');
if ~(folder_name == 0 )
    % 读取文件夹中所有文件名
    FileName = dir(folder_name);
    FileName = struct2cell(FileName);
    FileName = (FileName(1,3:end))';
else
    FileName ={};
end
%  保留.m文件
if ~isempty(FileName)
    index = cellfun(@(x) ismember((length(x)-1),strfind(x,'.m')),FileName);
    FileName = FileName(index);
    for Index = 1:length(FileName)
        FileName{Index}(end-1:end) = [];
    end
else
    return;
end

%  保存到策略样例
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