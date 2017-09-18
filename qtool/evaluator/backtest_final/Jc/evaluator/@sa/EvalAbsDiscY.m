function [ indAbsDiscFinal,indAbsDiscInter] = EvalAbsDiscY( nav,riskFree,benchmark )
%% Compute discrete indicators for absolute yield of portfolio.
% We calculate intermediate ones, which are daily series, and final ones, 
% which are structs with scalar members.
%% Initialize
indAbsDiscInter = SingleAsset;
indAbsDiscInter.dates = nav.dates;
dateSpan = size(nav.dates,1);
init = zeros(dateSpan,1);
rfScalar = mean(riskFree.data)*250;
benchmarkDailyYield = benchmark.data(2:end)./benchmark.data(1:end-1)-1;
%% Compute and assemble intermediate indicator
% Normalized nav. 1
normNav = nav.data./nav.data(1);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,normNav,'NormalizedNav');

% Daily discrete yield. The first day is set to zero. 2
dailyYieldDisc = init;
dailyYieldDisc(2:end) = nav.data(2:end)./nav.data(1:end-1)-1;
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,dailyYieldDisc,'DailyDiscreteYield');

% Accumulated discrete yield as day series. 3
accumYieldDiscDS = init;
accumYieldDiscDS(2:end) = normNav(2:end) - 1;
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,accumYieldDiscDS,'AccumulatedDiscreteYield');

% Max daily rally. 4
maxDailyRally = max_sequence(dailyYieldDisc);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,maxDailyRally,'MaxDailyRally');

% max daily drop. 5
maxDailyDrop = -max_sequence(-dailyYieldDisc);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,maxDailyDrop,'MaxDailyDrop');

% history daily high. 6
histDailyHigh = max_sequence(normNav);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,histDailyHigh,'HistoryHigh');

% history daily low. 7
histDailyLow = -max_sequence(-normNav);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,histDailyLow,'HistoryLow');

% drowdown as day series. 8
drawdownDS = init;
for i = 2:dateSpan
    drawdownDS(i) = 1-normNav(i)/histDailyHigh(i);
end
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,drawdownDS,'Drawdown');

% max drawdown as day series. 9
maxDrawdownDS = max_sequence(drawdownDS);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,maxDrawdownDS,'MaxDrawdown');

% rally as day series. 10
rallyDS = init;
for i = 2:dateSpan
    rallyDS(i) = normNav(i)/histDailyLow(i)-1;
end
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,rallyDS,'Rally');

% max rallay as day series. 11
maxRallyDS = max_sequence(rallyDS);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,maxRallyDS,'MaxRally');


% future low as day series. 12
futureLowDS = normNav;
for i = 1:dateSpan-1
    futureLowDS(dateSpan-i) = min(futureLowDS(dateSpan-i+1),normNav(dateSpan-i));
end
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,futureLowDS,'FutureLow');

% future drops as day series. 13
futureDropDS = init;
for i = 1:dateSpan-1
    futureDropDS(i) = 1-futureLowDS(i)/normNav(i);
end
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,futureDropDS,'FutureDrop');

% max future drops as day sereis. 14
maxFutureDropDS = max_sequence(futureDropDS);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,maxFutureDropDS,'MaxFutureDrop');


% number of consecutive rally days. 15
numConsecRally = init;
for i = 2:dateSpan
    if dailyYieldDisc(i)>0
        numConsecRally(i) = 1+numConsecRally(i-1);
    else
        numConsecRally(i) = 0;
    end
end
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,numConsecRally,'ConsecutiveRallyNum');

% max number of consecutive rally. 16
maxNumConsecRally = max_sequence(numConsecRally);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,maxNumConsecRally,'MaxConsecutiveRallyNum');

% number of consecutive drop days. 17
numConsecDrop = init;
for i = 2:dateSpan
    if dailyYieldDisc(i)<0
        numConsecDrop(i) = 1+numConsecDrop(i-1);
    else
        numConsecDrop(i) = 0;
    end
end
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,numConsecDrop,'ConsecutiveDropNum');

% max number of consecutive drop. 18
maxNumConsecDrop= max_sequence(numConsecDrop);
indAbsDiscInter = sa.update_SingleAsset(indAbsDiscInter,maxNumConsecDrop,'MaxConsecutiveDropNum');

%% Compute and assemble final indicator
indAbsDiscFinal.meanDailyYield = mean(dailyYieldDisc);
indAbsDiscFinal.stdDailyYield = std(dailyYieldDisc);
indAbsDiscFinal.maxDrawdown = maxDrawdownDS(end);
indAbsDiscFinal.maxDailyRally = maxDailyRally(end);
indAbsDiscFinal.maxDailyDrop = maxDailyDrop(end);
indAbsDiscFinal.maxNumConsecRally = maxNumConsecRally(end);
indAbsDiscFinal.maxNumConsecDrop = maxNumConsecDrop(end);
indAbsDiscFinal.maxRally = maxRallyDS(end);
indAbsDiscFinal.maxFutureDrop = maxFutureDropDS(end);
indAbsDiscFinal.accumYield = accumYieldDiscDS(end);
indAbsDiscFinal.skewnessDailyYield = skewness(dailyYieldDisc);
indAbsDiscFinal.excessKurtosisDailyYield = kurtosis(dailyYieldDisc)-3;
% Added 2013-03-15
indAbsDiscFinal.meanAnnualYield = (1+indAbsDiscFinal.meanDailyYield)^250-1;
indAbsDiscFinal.stdAnnualYield = (indAbsDiscFinal.stdDailyYield)*sqrt(250);
indAbsDiscFinal.pos1sigmaAnnual = indAbsDiscFinal.meanAnnualYield + indAbsDiscFinal.stdAnnualYield;
indAbsDiscFinal.pos2sigmaAnnual = indAbsDiscFinal.meanAnnualYield + 2*indAbsDiscFinal.stdAnnualYield;
indAbsDiscFinal.pos3sigmaAnnual = indAbsDiscFinal.meanAnnualYield + 3*indAbsDiscFinal.stdAnnualYield;
indAbsDiscFinal.neg1sigmaAnnual = indAbsDiscFinal.meanAnnualYield - indAbsDiscFinal.stdAnnualYield;
indAbsDiscFinal.neg2sigmaAnnual = indAbsDiscFinal.meanAnnualYield - 2*indAbsDiscFinal.stdAnnualYield;
indAbsDiscFinal.neg3sigmaAnnual = indAbsDiscFinal.meanAnnualYield - 3*indAbsDiscFinal.stdAnnualYield;
indAbsDiscFinal.dropVsRallyProb = sum(dailyYieldDisc<0)/sum(dailyYieldDisc>0);
indAbsDiscFinal.dropRiskAnnual = sqrt(lpm(dailyYieldDisc,rfScalar,2)*250);
indAbsDiscFinal.sharpeRatio = eval.SharpeRatio(normNav,rfScalar,'val');
indAbsDiscFinal.beta = eval.Beta(normNav, benchmark.data,'val');
indAbsDiscFinal.alpha = eval.Alpha( normNav, benchmark.data, rfScalar,'val');
indAbsDiscFinal.burkeRatio = eval.BurkeRatio(normNav, rfScalar,'val');
indAbsDiscFinal.calmarRatio = eval.CalmarRatio( normNav, rfScalar,'val');
indAbsDiscFinal.yieldExclMax  = eval.RetExclMax(normNav,'val');
indAbsDiscFinal.sortinoRatio = eval.SortinoRatio( normNav, rfScalar,'val');
indAbsDiscFinal.treynorRatio = eval.TreynorRatio( normNav, benchmark.data, rfScalar,'val');
indAbsDiscFinal.infoRatio = eval.infoRatio(normNav,benchmark.data,'val');
%
% indAbsDiscFinal.sharpeRatio = eval.SharpeRatio(dailyYieldDisc(2:end),rfScalar);
% indAbsDiscFinal.beta = eval.Beta(dailyYieldDisc(2:end), benchmarkDailyYield);
% indAbsDiscFinal.alpha = eval.Alpha( dailyYieldDisc(2:end), benchmarkDailyYield, rfScalar);
% indAbsDiscFinal.burkeRatio = eval.BurkeRatio(dailyYieldDisc(2:end), rfScalar);
% indAbsDiscFinal.calmarRatio = eval.CalmarRatio( dailyYieldDisc(2:end), rfScalar);
% indAbsDiscFinal.yieldExclMax  = eval.RetExclMax(dailyYieldDisc(2:end));
% indAbsDiscFinal.sortinoRatio = eval.SortinoRatio( dailyYieldDisc(2:end), rfScalar);
% indAbsDiscFinal.treynorRatio = eval.TreynorRatio( dailyYieldDisc(2:end), benchmarkDailyYield, rfScalar);
% indAbsDiscFinal.infoRatio = eval.infoRatio(dailyYieldDisc(2:end),benchmarkDailyYield);
%
indAbsDiscFinal.upRatio = eval.upr(dailyYieldDisc,rfScalar);
indAbsDiscFinal.valueAtRisk = portvrisk(indAbsDiscFinal.meanDailyYield-rfScalar, indAbsDiscFinal.stdDailyYield,0.05);

end % function