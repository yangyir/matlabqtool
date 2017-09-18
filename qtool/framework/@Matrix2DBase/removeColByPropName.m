function [ idx ] = removeColByPropName(obj, propNameStr)
% 删去名称对应的一列
% [ idx ] = removeColByPropName(obj, propNameStr)
%     propNameStr: 删去列的名称
%     idx: 删去列的原行号 
% --------------------
% 程刚，20150519，初版本

idx = find(   strcmp(propNameStr, obj.xProps)   );

if isempty(idx)
    error('错误：没有找到列属性名(xProps):\''%s\''', propNameStr);
else %~isempty(ix)
    % 删一列
    removeCol(obj, idx);
end


end

