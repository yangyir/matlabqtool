function [ Qmat ] = vmat2qmat( Vmat, pMat )
% 把股数矩阵Qmat转成金额矩阵Vmat
% 数量 * 价格 = 金额， 但价格有复权问题，相应的，数量跟价格相对应
% [ Vmat ] = tradeQmat2tradeVmat( Qmat, pMat)
% pMat：价格矩阵，可以自己给，默认从dh取close，后复权
% -------------
% 程刚，初版本，20150521


%% 预处理
if ~isa( Vmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的Qmat');
end

if ~exist('pMat', 'var')
    pMat = th.dhPriceMat(Vmat);
end


%% main
Qmat            = Vmat.getCopy;
Qmat.des2       = '数量';
Qmat.datatype   = '数量';
Qmat.data       = Vmat.data ./ pMat.data;

end

