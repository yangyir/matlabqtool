function [  ] = insertRow(obj, rowVec, nameStr, idx)
%在Matrix2D中插入一行，改变obj.data和obj.yProps
% [  ] = insertRow(obj, rowVec, nameStr, idx)
% rowVec: 要插入的行向量，类型须为数据，长度要吻合，如有多行只取第一行
% nameStr: yProps中插入的序列名，比如日期，默认'newRow'
% idx: 制定插入地点，0表示最后插入，默认0
% ----------------------
% 程刚，20150519,初版本



%% 预处理
% check nan
if isnan( rowVec )
    error('error: rowVec为空!');
end

if ~exist('idx', 'var')
    idx = 0;
end

if ~exist('nameStr', 'var')
    nameStr = 'newRow';
end

% check type
% if strcmp( class(rowVec), 'double' )

    
% check size
[y1, x1] = size(rowVec);
if isempty(obj.data)
    [y2, ~] = size(obj.yProps);
    [~, x2] = size(obj.xProps);
else
    [y2, x2] = size(obj.data);
end

if x1~=x2
    error('rowVec长度%d, 应为%d', x1, x2);
end

if y1 ~= 1
    rowVec = rowVec(1,:);
    warning('rowVec有%d行，仅取第一行', y1);
end



%% main

if idx == 0 || idx > y2 % 在最后插入
    obj.yProps{end+1} = nameStr;
    obj.data(end+1,:) = rowVec;
elseif idx > 0  % 在第idx行插入
    % 后移一格
    obj.yProps(idx+1:end+1)     = obj.yProps(idx:end);
    obj.data(idx+1:end+1, :)    = obj.data(idx:end, :);

    % 在第idx行写入数据
    obj.yProps{idx}     = nameStr;
    obj.data(idx,:)     = rowVec;
end




end

