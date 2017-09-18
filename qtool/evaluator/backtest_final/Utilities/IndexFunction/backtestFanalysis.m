%%%%%%%%%%%%%%%%%%%%%%%%%% backtestF analysis %%%%%%%%%%%%%%%%%%%%%%%

% 对 backtestF.m 的结果做更准确的每笔交易gap、每日收益rev、
% 最大损失maxDrawdown等结果的分析。
% 输入接口直接对应 backtestF.m 输出的 result和 输入的bars、
% configure


function[result_anal] = backtestFanalysis(result ,bars ,configure)

    account = result.Detail.account;
    tradeList = result.Detail.tradeList;

    %% calculating

    % gap

    [nrow,~] = size(tradeList);
    result_anal.gap = zeros(nrow,1);

    for i = 1:nrow
        gap_temp = account(bars.time == tradeList(i,4)) -...
            account(bars.time == tradeList(i,3));
        result_anal.gap(i) = gap_temp / (configure.multiplier *...
            bars.open(find(bars.time == tradeList(i,3))+1) *...
            (1 + configure.cost));
    end

    % rev

    timeSlice = mode(diff(bars.time));
    slicesPerDay = fix(1/24*4.5/timeSlice);
    [nrow,~] = size(account);
    result_anal.rev = zeros(nrow/slicesPerDay,1);

    for i = 1:length(result_anal.rev)
        rev_temp = account(slicesPerDay*i) - account(slicesPerDay*(i-1)+1);
        result_anal.rev(i) = rev_temp / (configure.multiplier *...
            mean(bars.close((slicesPerDay*(i-1)+1):(slicesPerDay*i))));
    end

    % maxDrawdown

    % 针对 backtestF_analysis 的 maxDrawDown 计算修改的版本
    % 由于IF00的策略目前测试都是每次只开1手，原来计算方法，会
    % 人为使 DrawDown 逐渐变小，故做如下修改：
    % 将最大回撤重新定义为，总回撤值/每次回撤开始点开一手IF合约
    % 的价格

    lowLevel = account;
    for i = 1:(length(account)-1)
        if account(end-i)<lowLevel(end-i+1)
            lowLevel(end-i)=account(end-i);
        else
            lowLevel(end-i) = lowLevel(end-i+1);
        end
    end
    drawDown = (account-lowLevel)./(configure.multiplier * bars.open);

    result_anal.maxDrawdown = max(drawDown);
    time_tmp = find(drawDown==result_anal.maxDrawdown,1,'first');
    result_anal.maxDrawdownBegT = datestr(bars.time(time_tmp));
    result_anal.maxDrawdownEndT = datestr(bars.time(find(lowLevel==...
        lowLevel(time_tmp),1,'last')));
    
    % final NAV
    
    result_anal.finalNAV = prod(result_anal.gap+1);
    
end

