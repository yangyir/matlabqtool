function [ idx ]     = setByPropName( obj, vector, idx, nameStr, direction)
% 设置一列/行的值，如该列/行不存在，则插入列/行
% [ idx ]     = setByPropName( obj, vector, idx, nameStr, direction);
%     vector： 要设置的值
%     idx：    设置在哪一列/行
%     nameStr：列/行的名称
%     direction：列 还是 行
    
%   Detailed explanation goes here


%% 先查nameStr对应的列/行是否存在


%% 再查vector和obj.data的长度是否吻合


%% 如果存在，则改写

%% 如果不存在，则插入

%% 更新Nx，Ny等信息

end

