function [ tradeQmat ] = posQmat2tradeQmat( posQmat )
% 从持仓矩阵转换到交易矩阵，只能使用数量矩阵Qmat
% 如果是价值矩阵，不能简单相减求tradeMat
% [ tradeQmat ] = posQmat2tradeQmat( posQmat )
% --------------------
% 程刚，初版本，20150521
% 程刚，20150524，改正逻辑错误：只能用Qmat进行计算


%% 预处理

% 判断类型
if ~isa(posQmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的posMat');
end

%% 
tradeQmat        = posQmat.getCopy;
tradeQmat.des    = '交易矩阵';
tradeQmat.des2   = '资产数量'; 
tradeQmat.datatype = '整数（实数）';

d1          = posQmat.data;
d2          = zeros( size(d1) );
d2(2:end,:) = d1(2:end, :) - d1(1:end-1, :);
d2(1, : )   = d1( 1, : ); 

tradeQmat.data = d2;

%% 取整
th.setIntQmat(tradeQmat, 'floor');



end

