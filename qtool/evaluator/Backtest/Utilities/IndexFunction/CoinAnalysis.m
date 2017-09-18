function judgeResult =  CoinAnalysis(pairs,closeprices)

judgeResult = [];
len_pairs = size(pairs,1);
for i = 1:len_pairs
    % ����в�ͻع�ϵ��
    P1 = closeprices(:,pairs(i,1));
    P2 = closeprices(:,pairs(i,2));
    
    % Engle-Granger cointegration test
    stationaryJudge = egcitest([P1,P2]);
    % null hypothesis: no cointegration
    % stationaryJudge=1: reject the null hypothesis
    if stationaryJudge==0
        continue;
    end
    
    % �в�
    result = regstats(P1,P2);
    residual = result.r;
    
%     % ����ؼ��飬���ϵ������0.3ʱ��Ϊ���������
%     autoCorrJudgeTemp = xcorr(residual);
%     autoCorrJudgeTemp(autoCorrJudgeTemp==max(autoCorrJudgeTemp))=0;
%     autoCorrJudge = logical(max(autoCorrJudgeTemp)>0.3);
% 
%     if autoCorrJudge==1
%         continue;
%     end
%     
%     % �췽���Լ���
%     heterJudge = archtest(residual);
%     % null hypothesis: exhibits no conditional heteroscedasticity
%     % heterJudge =1: rejection of the null of no ARCH effects
%     if heterJudge==1
%         continue;
%     end
     
    % ��̬�Լ���
    normJudge = jbtest(residual);
    % null hypothesis: the data are normally distributed
    % normJudge=1 indicates that the null hypothesis can be rejected at the 5% level
    if normJudge==0
        judgeResult = [judgeResult; pairs(i,:)];
    end
end

end