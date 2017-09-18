function judgeResult =  CoinAnalysis(pairs,closeprices)

judgeResult = [];
len_pairs = size(pairs,1);
for i = 1:len_pairs
    % 计算残差和回归系数
    P1 = closeprices(:,pairs(i,1));
    P2 = closeprices(:,pairs(i,2));
    
    % Engle-Granger cointegration test
    stationaryJudge = egcitest([P1,P2]);
    % null hypothesis: no cointegration
    % stationaryJudge=1: reject the null hypothesis
    if stationaryJudge==0
        continue;
    end
    
    % 残差
    result = regstats(P1,P2);
    residual = result.r;
    
%     % 自相关检验，相关系数大于0.3时认为存在自相关
%     autoCorrJudgeTemp = xcorr(residual);
%     autoCorrJudgeTemp(autoCorrJudgeTemp==max(autoCorrJudgeTemp))=0;
%     autoCorrJudge = logical(max(autoCorrJudgeTemp)>0.3);
% 
%     if autoCorrJudge==1
%         continue;
%     end
%     
%     % 异方差性检验
%     heterJudge = archtest(residual);
%     % null hypothesis: exhibits no conditional heteroscedasticity
%     % heterJudge =1: rejection of the null of no ARCH effects
%     if heterJudge==1
%         continue;
%     end
     
    % 正态性检验
    normJudge = jbtest(residual);
    % null hypothesis: the data are normally distributed
    % normJudge=1 indicates that the null hypothesis can be rejected at the 5% level
    if normJudge==0
        judgeResult = [judgeResult; pairs(i,:)];
    end
end

end