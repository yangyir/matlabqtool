function [ ] = insertVec(obj, vector, nameStr, direction, idx)
% 在matrix2D插入行或列
% [ ] = insertVec(obj, vector, nameStr, direction, idx)
%     vector: 要插入的列/行向量，类型须为数据，长度要吻合，如有多列/行只取第一列/行
%     nameStr: 要插入的列序列名，比如日期，默认'newCol'或'newRow'
%     direction: 1-列向量；2-行向量。默认根据vector自动判定
%     idx:  指定插入地点，0表示最后插入，默认0
% ----------------------
% 程刚,20150519,初版本


%% 预处理
% check nan
if isnan( vector )
    error('error: vector为空!');
end

% 自动判定direction
if ~exist('direction', 'var')
    [y1, x1] = size(vector);
    if y1>x1
        tmpStr = '列向量';
        direction = 1;
    else
        tmpStr = '行向量';
        direction = 2;
    end
    warning('未知向量方向，自动判定为%s', tmpStr   );
end

 
if ~exist('idx', 'var'),        
    idx     = 0;            
end

if ~exist('nameStr', 'var'),
    if direction ==1
        nameStr = 'newCol';
    elseif direction == 2
        nameStr = 'newRow';
    else
        nameStr = 'newVector';
    end
end



%% main
% 分别调用插入行向量和列向量的函数实现
if direction == 1 %列向量
    insertCol(obj, vector, nameStr, idx);
elseif direction == 2 %行向量
    insertRow(obj, vector, nameStr, idx);
end




end

