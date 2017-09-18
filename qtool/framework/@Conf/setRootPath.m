function [ obj ] = setRootPath( obj, rootPath )
% 设置rootPath, 中间涉及到一些默认值，有优先级

%% 
if ~exist('rootPath', 'var') 
    
    % 几个备选rootPath，按优先级排列
    p = cell(1,1);
    p{1} = 'V:\root\';
    p{2} = 'D:\work\root\';
    p{3} = 'C:\work\root\';
    
    for i = 1:length(p)
        e(i) = exist(p{i}, 'dir');
    end
    
    idx = find( e > 0, 1, 'first' ) ;
    if isempty(idx), idx = 1; end;
        
    % 默认为存在的优先的备选
    rootPath = p{idx};       
        
end

obj.config.rootPath = rootPath;

end

