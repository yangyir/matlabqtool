function [ vec, idx ]  = getVecByPropName( obj, target_prop, direction)
% 取出一列或一行，使用该行/列的属性名或值
% 如果有同名的属性，只能取第一个
% [ vec, idx ]  = getVecByPropName( obj, target_prop, direction)
%     propNameStr: 属性名
%     direction: 取列向量（ 1，'列', 'x') 还是 行向量（2，'行', 'y')。默认1
%     vec：取出的列/行向量
%     idx：是data的第几列/行
% --------------
% 程刚，20150517


%% 预处理
if ~exist('direction', 'var')
    direction = 1;
end

%%
switch direction
    case {1,'列','x'}
        if isa(obj.xProps, 'char')
            ix = find(   strcmp(target_prop, obj.xProps)   );
        else
            ix = find( target_prop == obj.xProps);
        end
        if isempty(ix)
            error('错误：getVecByPropName没有找到列属性名(xProps):\''%s\''', target_prop);
        else %~isempty(ix)
            % 取一列
            vec = obj.data(:,ix);
            idx = ix;
        end
        
    case {2, '行', 'y'}
        if isa(obj.xProps, 'char')
        iy = find(   strcmp(target_prop, obj.yProps)  );
        else
            iy = find( target_prop == obj.yProps );
        end
        if isempty(iy)
            error('错误：getVecByPropName没有找到行属性名(yProps):\''%s\''', target_prop);
        else %~isempty(iy)
            % 取一行
            vec = obj.data(iy,:);
            idx = iy;
        end
        
end

end

