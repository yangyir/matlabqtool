function [  ] = insertCol(obj, colVec, nameStr, idx)
%在Matrix2D中插入一列，改变obj.data和obj.xProps
% [  ] = insertCol(obj, colVec, nameStr, idx)
% colVec: 要插入的列向量，类型须为数据，长度要吻合，如有多列只取第一列
% nameStr: xProps中插入的列序列名，比如日期，默认'newCol'
% idx: 制定插入地点，0表示最后插入，默认0
% ----------------------
% 程刚，20150519,初版本



%% 预处理
% check nan
if isnan( colVec )
    error('error: colVec为空!');
end


if ~exist('idx', 'var')
    idx = 0;
end

if ~exist('nameStr', 'var')
    nameStr = 'newCol';
end

% check type
% if strcmp( class(colVec), 'double' )

% check size
[y1, x1] = size(colVec);
if isempty(obj.data)
    [y2, ~] = size(obj.yProps);
    [~, x2] = size(obj.xProps);
else
    [y2, x2] = size(obj.data);
end

if y1~=y2
    error('colVec长度%d, 应为%d', y1, y2);
end

if x1 ~= 1
    colVec = colVec(:, 1);
    warning('rowVec有%d列，仅取第一列', x1);
end



%% main

if idx == 0 || idx > x2 % 在最后插入
    obj.xProps{end+1}  = nameStr;
    obj.data(:, end+1) = colVec;
elseif idx > 0  % 在第idx行插入
    % 后移一格
    obj.xProps(idx+1:end+1)     = obj.xProps(idx:end);
    obj.data(:, idx+1:end+1)    = obj.data(:, idx:end);

    % 在第idx行写入数据
    obj.xProps{ idx }   = nameStr;
    obj.data(:, idx)    = colVec;
end


end

