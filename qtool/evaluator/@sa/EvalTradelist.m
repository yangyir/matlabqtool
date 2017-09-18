function [ indOprnInter,indOprnFinal] = EvalTradelist( tradelist)
%% Compute operation indicator at transaction leval.
%

%% trade list
% trade list as a SingleAsset
% code          1
% dPosition     2
% price         3
% operation     4
% Slippage      5
% Volume        6
% Participation 7


%% Compute intermediate trade operation indicator
percentVector = (0:0.005:0.20)';
indOprnInter.oprnPropDistrAbs = intervalCount(tradelist.oprnProportion,percentVector);

avgOprnProp = mean(tradelist.oprnProportion);
stdOprnProp = std(tradelist.oprnProportion);
sigmaVector = (-4.0:0.2:4.0)';
relPercentVector = avgOprnProp + stdOprnProp*sigmaVector;
indOprnInter.oprnPropDistrRel = intervalCount(tradelist.oprnProportion,relPercentVector);
indOprnInter.oprnPropDistrRel(:,1) = sigmaVector;
indOprnInter.oprnPropDistrRel(1:end-1,2) = sigmaVector(2:end);
%% Compute final trade operation indicator
indOprnFinal.meanOprnProp = avgOprnProp;
indOprnFinal.stdOprnProp = stdOprnProp;
indOprnFinal.maxOprnProp = max(tradelist.oprnProportion);
indOprnFinal.minOprnProp = min(tradelist.oprnProportion);

end

