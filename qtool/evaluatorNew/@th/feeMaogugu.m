function [ port ] = feeMaogugu( tradeVmat, feeRatio )
% 使用交易额矩阵TradeVmat粗略估算手续费：直接算每天的，累加，没有recursive
% [ port ] = feeMaogugu( tradeVmat, feeRatio )
% --------------------
% 程刚，20150524，初版本



%% 前处理：所有手续费率
% 判断类型
if ~isa(tradeVmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的tradeVmat');
end

% 临时
if ~exist('feeRatio', 'var')
    warning('使用默认手续费率');
end

% 手续费，按实际情况来。TODO：单独写一个函数，或者让DH做一个函数
assetsCell = tradeVmat.xProps;
buyFeeRatio = zeros(size(assetsCell));
sellFeeRatio = zeros(size(assetsCell));

for i = 1: length(assetsCell)
    astStr = assetsCell{i};
    pre = astStr(1:2);
    if strcmp(pre, '60') || strcmp(pre, '00') % 沪深股票
        buyFeeRatio(i)  = 0.0001; 
        sellFeeRatio(i) = 0.00106;

        % 股指期货
    elseif strcmp(pre, 'IF') || strcmp(pre,'IC') || strcmp(pre, 'IH') ...
            || strcmp(pre,'if') || strcmp(pre, 'ic') || strcmp(pre,'ih')
        buyFeeRatio(i)  = 0.000029;
        sellFeeRatio(i) = 0.000029;
    
        
    elseif strcmp(pre, '50' ) % 基金
        buyFeeRatio(i)  = 0.001;
        sellFeeRatio(i) = 0.001;

        % 还有很多其他类型资产
        
        
    end
    
end

%% main
% 算手续费矩阵
d       = tradeVmat.data;
vec1    = ones(size(tradeVmat.yProps));
feeBuy  = d .* (d>=0) .* ( vec1 * buyFeeRatio ); 
feeSell = - d .* (d<0) .* ( vec1 * sellFeeRatio );

% 总手续费
ttlFeeBuy   = nansum( feeBuy, 2);
ttlFeeSell  = nansum( feeSell, 2);
ttlFee      = ttlFeeBuy + ttlFeeSell;

%  记录结果
port        = SingleAsset;
port.des    = '投资组合';
port.des2   = '交易手续费';
port.yProps = tradeVmat.yProps;

port.insertCol( cumsum(ttlFee), '累计总手续费');
port.insertCol( ttlFeeBuy, '买费');
port.insertCol( ttlFeeSell, '卖费');
port.insertCol( ttlFee, '总手续费');



end

