function [ indAbsContFinal,indAbsContInter] = EvalAbsContY( nav,riskFree,benchmark )
%% Compute continuous indicators for absolute yield of portfolio.
% We calculate intermediate ones, which are daily series, and final ones, 
% which are structs with scalar members.
%% Initialize
indAbsContInter = SingleAsset;
indAbsContInter.dates = nav.dates;
dateSpan = size(nav.dates,1);
init = zeros(dateSpan,1);
rfScalar = mean(riskFree.data)*250;
benchmarkDailyYield = benchmark.data(2:end)./benchmark.data(1:end-1)-1;
%% Compute and assemble intermediate indicator
% Normalized nav. 1
normNav = nav.data./nav.data(1);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,normNav,'NormalizedNav');

% Daily continuous yield. The first day is set to zero. 2
dailyYieldCont = init;
dailyYieldCont(2:end) = log(nav.data(2:end)./nav.data(1:end-1));
indAbsContInter = sa.update_SingleAsset(indAbsContInter,dailyYieldCont,'DailyContinuousYield');

% Accumulated continuous yield as day series. 3
accumYieldContDS = init;
accumYieldContDS(2:end) = log(normNav(2:end));
indAbsContInter = sa.update_SingleAsset(indAbsContInter,accumYieldContDS,'AccumulatedContinuousYield');

% Max daily rally. 4
maxDailyRally = max_sequence(dailyYieldCont);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,maxDailyRally,'MaxDailyRally');

% max daily drop. 5
maxDailyDrop = -max_sequence(-dailyYieldCont);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,maxDailyDrop,'MaxDailyDrop');

% history daily high. 6
histDailyHigh = max_sequence(normNav);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,histDailyHigh,'HistoryHigh');

% history daily low. 7
histDailyLow = -max_sequence(-normNav);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,histDailyLow,'HistoryLow');

% drowdown as day series. 8
drawdownDS = init;
for i = 2:dateSpan
    drawdownDS(i) = log(histDailyHigh(i)/normNav(i));
end
indAbsContInter = sa.update_SingleAsset(indAbsContInter,drawdownDS,'Drawdown');

% max drawdown as day series. 9
maxDrawdownDS = max_sequence(drawdownDS);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,maxDrawdownDS,'MaxDrawdown');

% rally as day series. 10
rallyDS = init;
for i = 2:dateSpan
    rallyDS(i) = log(normNav(i)/histDailyLow(i));
end
indAbsContInter = sa.update_SingleAsset(indAbsContInter,rallyDS,'Rally');

% max rallay as day series. 11
maxRallyDS = max_sequence(rallyDS);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,maxRallyDS,'MaxRally');


% future low as day series. 12
futureLowDS = normNav;
for i = 1:dateSpan-1
    futureLowDS(dateSpan-i) = min(futureLowDS(dateSpan-i+1),normNav(dateSpan-i));
end
indAbsContInter = sa.update_SingleAsset(indAbsContInter,futureLowDS,'FutureLow');

% future drops as day series. 13
futureDropDS = init;
for i = 1:dateSpan-1
    futureDropDS(i) = log(normNav(i)/futureLowDS(i));
end
indAbsContInter = sa.update_SingleAsset(indAbsContInter,futureDropDS,'FutureDrop');

% max future drops as day sereis. 14
maxFutureDropDS = max_sequence(futureDropDS);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,maxFutureDropDS,'MaxFutureDrop');


% number of consecutive rally days. 15
numConsecRally = init;
for i = 2:dateSpan
    if dailyYieldCont(i)>0
        numConsecRally(i) = 1+numConsecRally(i-1);
    else
        numConsecRally(i) = 0;
    end
end
indAbsContInter = sa.update_SingleAsset(indAbsContInter,numConsecRally,'ConsecutiveRallyNum');

% max number of consecutive rally. 16
maxNumConsecRally = max_sequence(numConsecRally);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,maxNumConsecRally,'MaxConsecutiveRallyNum');

% number of consecutive drop days. 17
numConsecDrop = init;
for i = 2:dateSpan
    if dailyYieldCont(i)<0
        numConsecDrop(i) = 1+numConsecDrop(i-1);
    else
        numConsecDrop(i) = 0;
    end
end
indAbsContInter = sa.update_SingleAsset(indAbsContInter,numConsecDrop,'ConsecutiveDropNum');

% max number of consecutive drop. 18
maxNumConsecDrop= max_sequence(numConsecDrop);
indAbsContInter = sa.update_SingleAsset(indAbsContInter,maxNumConsecDrop,'MaxConsecutiveDropNum');

%% Compute and assemble final indicator
indAbsContFinal.meanDailyYield = mean(dailyYieldCont);
indAbsContFinal.stdDailyYield = std(dailyYieldCont);
indAbsContFinal.maxDrawdown = maxDrawdownDS(end);
indAbsContFinal.maxDailyRally = maxDailyRally(end);
indAbsContFinal.maxDailyDrop = maxDailyDrop(end);
indAbsContFinal.maxNumConsecRally = maxNumConsecRally(end);
indAbsContFinal.maxNumConsecDrop = maxNumConsecDrop(end);
indAbsContFinal.maxRally = maxRallyDS(end);
indAbsContFinal.maxFutureDrop = maxFutureDropDS(end);
indAbsContFinal.accumYield = accumYieldContDS(end);
indAbsContFinal.skewnessDailyYield = skewness(dailyYieldCont);
indAbsContFinal.excessKurtosisDailyYield = kurtosis(dailyYieldCont)-3;
% Added 2013-03-15
indAbsContFinal.meanAnnualYield = (1+indAbsContFinal.meanDailyYield)^250-1;
indAbsContFinal.stdAnnualYield = (indAbsContFinal.stdDailyYield)*sqrt(250);
indAbsContFinal.pos1sigmaAnnual = indAbsContFinal.meanAnnualYield + indAbsContFinal.stdAnnualYield;
indAbsContFinal.pos2sigmaAnnual = indAbsContFinal.meanAnnualYield + 2*indAbsContFinal.stdAnnualYield;
indAbsContFinal.pos3sigmaAnnual = indAbsContFinal.meanAnnualYield + 3*indAbsContFinal.stdAnnualYield;
indAbsContFinal.neg1sigmaAnnual = indAbsContFinal.meanAnnualYield - indAbsContFinal.stdAnnualYield;
indAbsContFinal.neg2sigmaAnnual = indAbsContFinal.meanAnnualYield - 2*indAbsContFinal.stdAnnualYield;
indAbsContFinal.neg3sigmaAnnual = indAbsContFinal.meanAnnualYield - 3*indAbsContFinal.stdAnnualYield;
indAbsContFinal.dropVsRallyProb = sum(dailyYieldCont<0)/sum(dailyYieldCont>0);
indAbsContFinal.dropRiskAnnual = sqrt(lpm(dailyYieldCont,rfScalar,2)*250);
% indAbsContFinal.sharpeRatio = eval.SharpeRatio(normNav,rfScalar,'val');
% indAbsContFinal.beta = eval.Beta(normNav, benchmark.data,'val');
% indAbsContFinal.alpha = eval.Alpha( normNav, benchmark.data, rfScalar,'val');
% indAbsContFinal.burkeRatio = eval.BurkeRatio(normNav, rfScalar,'val');
% indAbsContFinal.calmarRatio = eval.CalmarRatio( normNav, rfScalar,'val');
% indAbsContFinal.yieldExclMax  = eval.LretExclMax(normNav,'val');
% indAbsContFinal.sortinoRatio = eval.SortinoRatio( normNav, rfScalar,'val');
% indAbsContFinal.treynorRatio = eval.TreynorRatio( normNav, benchmark.data, rfScalar,'val');
% indAbsContFinal.infoRatio = eval.infoRatio(normNav,benchmark.data,'val');
%
indAbsContFinal.sharpeRatio = eval.SharpeRatio(dailyYieldCont(2:end),rfScalar);
indAbsContFinal.beta = eval.Beta(dailyYieldCont(2:end), benchmarkDailyYield);
indAbsContFinal.alpha = eval.Alpha( dailyYieldCont(2:end), benchmarkDailyYield, rfScalar);
indAbsContFinal.burkeRatio = eval.BurkeRatio(dailyYieldCont(2:end), rfScalar);
indAbsContFinal.calmarRatio = eval.CalmarRatio( dailyYieldCont(2:end), rfScalar);
indAbsContFinal.yieldExclMax  = eval.LretExclMax(dailyYieldCont(2:end));
indAbsContFinal.sortinoRatio = eval.SortinoRatio( dailyYieldCont(2:end), rfScalar);
indAbsContFinal.treynorRatio = eval.TreynorRatio( dailyYieldCont(2:end), benchmarkDailyYield, rfScalar);
indAbsContFinal.infoRatio = eval.infoRatio(dailyYieldCont(2:end),benchmarkDailyYield);
%
indAbsContFinal.upRatio = eval.upr(dailyYieldCont,rfScalar);
indAbsContFinal.valueAtRisk = portvrisk(indAbsContFinal.meanDailyYield-rfScalar,indAbsContFinal.stdDailyYield,0.05);

end % function