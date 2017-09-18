function [ indOprnDayFinal,indOprnDayInter] = EvalYY( YY)
%EVAL2 Evaluation based on Position
% [ indOprnDayFinal,indOprnDayInter] = EvalYY( YY)
% สนำร
%{
%% pre - check
if ~isa(pos, TsMatrix) | ~isa(price, TsMatrix) return; end
%}

%% Calculate intermediate day operation indicators


indOprnDayInter = SingleAsset;
indOprnDayInter.dates = YY.dates;
% TotBuys               1
% TotSells              2
% NetTurnover           3
% TotTurnover           4
% NumBuys               5
% NumSells              6
% BuysSellsRatio        7
% BuysNavRatio          8
% SellsNavRatio         9
% NumOperations         10
% NumPosition           11
% TurnoverRatio         12
% AccumToRatio          13
% Leverage              14
nav = YY.data(:,1);
totBuys = YY.data(:,6);
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,totBuys,'TotBuys');
totSells = YY.data(:,7);
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,totSells,'TotSells');
netTurnover = totBuys+totSells;
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,netTurnover,'NetTurnover');
totTurnover = totBuys-totSells;
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,totTurnover,'TotTurnover');
numBuys = YY.data(:,8);
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,numBuys,'NumBuys');
numSells = YY.data(:,9);
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,numSells,'NumSells');
buysToRatio = totBuys./totTurnover;
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,buysToRatio,'BuysToRatio');
buysNavRatio = totBuys./nav;
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,buysNavRatio,'BuysNavRatio');
sellsNavRatio = -totSells./nav;
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,sellsNavRatio,'SellsNavRatio');
numOperations = numSells+numBuys;
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,numOperations,'NumOperations');
numPosition = YY.data(:,10);
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,numPosition,'NumPosition');
turnoverRatio = totTurnover./nav;
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,turnoverRatio,'TurnoverRatio');
accumToRatio = cumsum(turnoverRatio);
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,accumToRatio,'AccumToRatio');
equityValue = YY.data(:,3);
leverage = equityValue./nav;
indOprnDayInter = sa.update_SingleAsset(indOprnDayInter,leverage,'Leverage');

%% Calculate final day operation indicators
indOprnDayFinal.avgNumPosition = mean(numPosition(2:end));
indOprnDayFinal.maxNumPosition = max(numPosition(2:end));
indOprnDayFinal.minNumPosition = min(numPosition(2:end));
indOprnDayFinal.avgLeverage = mean(leverage(2:end));
indOprnDayFinal.maxLeverage = max(leverage(2:end));
indOprnDayFinal.minLeverage = min(leverage(2:end));
indOprnDayFinal.avgTurnoverRatio = mean(turnoverRatio(2:end));
indOprnDayFinal.maxTurnoverRatio = max(turnoverRatio(2:end));
indOprnDayFinal.avgBuysNavRatio = mean(buysNavRatio(2:end));
indOprnDayFinal.maxBuysNavRatio = max(buysNavRatio(2:end));
indOprnDayFinal.avgSellsNavRatio = mean(sellsNavRatio(2:end));
indOprnDayFinal.maxSellsNavRatio = max(sellsNavRatio(2:end));
numOprn = numBuys+numSells;
indOprnDayFinal.avgNumOprn = mean(numOprn(2:end));
indOprnDayFinal.maxNumOprn = max(numOprn(2:end));
indOprnDayFinal.minNumOprn = min(numOprn(2:end));

end

