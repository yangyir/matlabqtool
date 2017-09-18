function [ posQmat ] = tradeQmat2posQmat( tradeQmat )
% 构造posMat，并由tradeMat累加得出posMat，只能对Qmat做
% 不检查tradeMat的可实现行
% [ posQmat ] = tradeQmat2posQmat( tradeQmat )
% ---------------
% 程刚，20150521，初版本
% 程刚，20150524，改正逻辑错误：只能用Qmat进行计算


%% 预处理

% 判断类型
if ~isa(tradeQmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的tradeMat');
end

% 初始仓位 0


%%
posQmat      = tradeQmat.getCopy;
posQmat.des  = '持仓矩阵';
posQmat.des2 = '数量';
posQmat.datatype = '整数(实数)';

% tradeMat 数据生成，假设初始仓位为0
d1 = tradeQmat.data;
d2 = zeros( size(d1) );
d2 = cumsum(d1, 1); 

posQmat.data = d2;


%% 取整
th.setIntQmat(posQmat, 'floor');

end

