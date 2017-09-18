function [ port ] = tradeVmat2volume( tradeVmat )
% 从交易矩阵计算交易额： 买额、卖额、净买额、总交易额等
%[ port ] = tradeVmat2volume( tradeVmat )
% --------------------
% 程刚，20150524，初版本

%% 前处理
% 判断类型
if ~isa(tradeVmat, 'TsMatrix')
    error('本函数只接受TsMatrix类型的tradeMat');
end

% 打开DH


%% 
port = SingleAsset;
port.des  = '投资组合';
port.des2 = '买额、卖额、净买额、总交易额等';
port.yProps = tradeVmat.yProps;

d       = tradeVmat.data;
ttlBuy  = nansum( d .* (d>=0) , 2);
ttlSell = - nansum( d.* (d<0),    2);
ttlNet  = ttlBuy - ttlSell;
ttlTrade = ttlBuy + ttlSell;

port.insertCol( ttlBuy, '买额');
port.insertCol( ttlSell, '卖额');
port.insertCol( ttlNet, '净买额');
port.insertCol( ttlTrade, '总交易额');






end

