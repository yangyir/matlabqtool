function [ indFinal, indAbsDiscInter,indAbsContInter,indRelDiscInter,indRelContInter] = EvalY( Y, riskFreeRate,benchmark )
%%
%% 
% params1 =
% ...

%% calculate indicators
[indFinal.AbsDisc,indAbsDiscInter] = sa.EvalAbsDiscY(Y,riskFreeRate,benchmark);
[indFinal.AbsCont,indAbsContInter] = sa.EvalAbsContY(Y,riskFreeRate,benchmark);
[indFinal.RelDisc,indRelDiscInter] = sa.EvalRelDiscY(Y,riskFreeRate,benchmark);
[indFinal.RelCont,indRelContInter] = sa.EvalRelContY(Y,riskFreeRate,benchmark);

end

