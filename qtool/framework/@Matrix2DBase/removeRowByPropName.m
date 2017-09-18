function [ idx ] =  removeRowByPropName(obj, propNameStr)
% 删去名称对应的一行
% [ idx ] = removeRowByPropName(obj, propNameStr)
%     propNameStr: 删去的行的名称
%     idx: 删去行的原行号
% --------------------
% 程刚，20150519，初版本

idx = find(   strcmp(propNameStr, obj.yProps)   );

if isempty(idx)
    error('错误：没有找到列属性名(yProps):\''%s\''', propNameStr);
else %~isempty(idx)
    % 删一行
    obj.removeRow(idx);
end


end

