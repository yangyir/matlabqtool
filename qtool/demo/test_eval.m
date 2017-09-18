%% Evaluation test
clear;
clc;
%% Import and transform original data
disp('Importifng initial data:');
tic
% price and position is imported as a TsMatrix
price = importdata('_price.mat');
price.data = processNaN(price.data);
dates = price.dates;
[dateSpan,assetNum] = size(price.data);

position = importdata('_position.mat');
benchmark = importdata('_benchmark.mat');

fundInitValue = 200000000;
slippageRatio = zeros(dateSpan, assetNum);
volume = 100000000*ones(size(price.data));
riskFreeRate = 0.000075*ones(dateSpan,1);
riskFreeRate = build_SingleAsset('RiskFree',riskFreeRate,dates);
commissionIndex = 0.001;
toc

%% Evaluate portfolio
tic
disp('Calculating:');
% Calculate portfolio value. 
% Y = net value of portfolio,
% YY = netValue, cashValue, equityValue, accumCommission, accumSlippage.
[Y,YY,tradelist] = sa.CalcY(position,fundInitValue,price,commissionIndex,slippageRatio,volume);

% EvalY, statistics of yield vector.
[indFinal,indAbsDiscInter,indAbsContInter,indRelDiscInter,indRelContInter] = sa.EvalY(Y,riskFreeRate,benchmark);

% EvalYY, statistics of day series 
[indOprnDayFinal,indOprnDayInter] = sa.EvalYY(YY);

% EvalTradelist, statistics of operations
[indOprnInter,indOprnFinal] = sa.EvalTradelist(tradelist);
toc

%% Output Result
disp('Outputing:')
% writing speed of write2excel is also slow when data is large.
write2excel('Y.xlsx',sa.tsm2cell(Y),'Yield',sa.tsm2cell(YY),'Yield_Detail');
write2excel('EvalY.xlsx',my_struct2cell(indFinal),'FinalInd',sa.tsm2cell(indAbsDiscInter),'AbsDisc',sa.tsm2cell(indAbsContInter),...
    'AbsCont',sa.tsm2cell(indRelDiscInter),'RelDisc',sa.tsm2cell(indRelContInter),'RelCont');
write2excel('EvalYY.xlsx',my_struct2cell(indOprnDayFinal),'OperationFinalInd',sa.tsm2cell(indOprnDayInter),'OperationInterInd');