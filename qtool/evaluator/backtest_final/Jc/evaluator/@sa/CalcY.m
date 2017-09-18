function [ nav, portfolio,tradelist ] = CalcY(position,fundInitValue,price,commission_index,slippageRatio,volume)
%% Calculate net value of portfolio
%
%%

% Dates and assets
DATES = price.dates;
[dateSpan, numAsset] = size(price.data);

portfolio = SingleAsset;
portfolio.dates = DATES;

% Position
positionValue = price.data.*position.data;
dPosition = diff(position.data);

% Compute operation and slippage

operations = vertcat(zeros(1,numAsset),dPosition.*price.data(1:end-1,:));

slippage = operations.*slippageRatio;
commission = compute_commission(operations, commission_index);


% Compute net value of portfolio
stockValue = sum(positionValue,2);
netTurnover = sum(operations,2);
cashValue = fundInitValue*ones(dateSpan,1)-cumsum(netTurnover);
accumSlippage = cumsum(sum(slippage,2));
accumCommission = cumsum(sum(commission,2));
portfolioValue = cashValue+stockValue-accumSlippage-accumCommission;

nav = sa.build_SingleAsset('PortfolioNetValue',portfolioValue,DATES);

portfolio.tstypes = {'PortfolioValue','CashValue','EquityValue','AccumCommission','accumSlippage'};
portfolio.data = horzcat(portfolioValue,cashValue,stockValue,accumCommission,accumSlippage);

totBuys = sum(operations.*(operations>0),2);
portfolio = sa.update_SingleAsset(portfolio,totBuys,'TotBuys');
totSells = sum(operations.*(operations<0),2);
portfolio = sa.update_SingleAsset(portfolio,totSells,'TotSells');
numBuys = sum(operations>0,2);
portfolio = sa.update_SingleAsset(portfolio,numBuys,'NumBuys');
numSells = sum(operations<0,2);
portfolio = sa.update_SingleAsset(portfolio,numSells,'NumSells');
numPosition = sum(position.data>0,2);
portfolio = sa.update_SingleAsset(portfolio,numPosition,'NumPosition');
%% Create tradelist
oprnProp = bsxfun(@rdivide,operations,nav.data);
[tradeColumn,tradeRow] = ind2sub(size(operations'),find(operations'));
tradelist.dates = price.dates(tradeRow);
tradelist.codes = price.assets(:,tradeColumn)';
matrixIndexing = sub2ind(size(operations),tradeRow,tradeColumn);

tradelist.dPosition = dPosition(sub2ind(size(dPosition),tradeRow-1,tradeColumn));
tradelist.price = price.data(matrixIndexing);
tradelist.operation = operations(matrixIndexing);
tradelist.oprnProportion = abs(oprnProp(matrixIndexing));
tradelist.slippage = slippage(matrixIndexing);
tradelist.commission = commission(matrixIndexing);
tradelist.volume = volume(matrixIndexing);
tradelist.participation = abs(tradelist.operation)./tradelist.volume;

%{
%CALCY Summary of this function goes here
%   Detailed explanation goes here


%% 识别和转换：X
% val_X
% pct_X
% n_val_X
if strcmp(X.datatype, 'pct') 
    pct_X = X.data
    %转换
    val_X = pct2valX(pct_X)
elseif strcmp(X.datatype, 'val')
    val_X = X.data
end

%% 识别和转换: Pos
% nPos
% vPos
% pctPos
% d_nPos
% d_vPos
% d_pctPos
% Trades

if strcmp(Pos.datatype, 'pct')


  
%% 通道一：绝对通道
val_X
n_Pos
val_Y = val_X.*n_Pos;


% %% 通道二：相对通道
% pct_X;
% pct_Pos;
% pct_Y = pct_X.* pct_Pos ;

%}
end

