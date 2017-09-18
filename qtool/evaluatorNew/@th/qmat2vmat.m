function [ Vmat ] = qmat2vmat( Qmat, pMat)
% 把Qmat手数矩阵转成金额矩阵Vmat
% [ Vmat ] = tradeQmat2tradeVmat( Qmat, pMat)
% pMat：价格矩阵，可以自己给，默认从dh取close，后复权
% -------------
% 程刚，初版本，20150521



%% 预处理
if ~isa( Qmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的Qmat');
end

if ~exist('pMat', 'var')
    pMat = th.dhPriceMat(Qmat);
end



%% main
Vmat            = Qmat.getCopy;
Vmat.des2       = '金额';
Vmat.datatype   = '金额';
Vmat.data       = Qmat.data .* pMat.data;


end

