function [ ] =  removeCol(obj, idx)
% 删去一行，改变obj.yProps和obj.data和obj.Ny
% [ ] =  removeCol(obj, idx)
%     idx: 待删除列列号
% ----------------
% 程刚，20150519，初版本
% TODO: 能否改成接受参数idx 或 nameStr


%% 预处理
% 判断idx范围正常

if idx < 0 || idx > length(obj.xProps) 
    error('idx=%d，超出范围！',idx);
end


%% main
obj.xProps(idx)  = [];
obj.data(:, idx) = [];
obj.autoFill;



end

