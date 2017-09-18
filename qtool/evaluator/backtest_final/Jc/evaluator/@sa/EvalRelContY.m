function [ indRelContFinal,indRelContInter] = EvalRelContY( nav, riskFree,benchmark )
%% Compute continuous indicators for Relative yield of portfolio.
% We calculate intermediate ones, which are daily series, and final ones, 
% which are structs with scalar members.
%% Initialize
if ~isequal(nav.dates, benchmark.dates)
    error('Portfolio and benchmark date stamp not match!');
end

relY = nav.data./benchmark.data;
relY = sa.build_SingleAsset('RelativeYield',relY,nav.dates);
[indRelContFinal, indRelContInter] = sa.EvalAbsContY(relY,riskFree,benchmark);

end % function