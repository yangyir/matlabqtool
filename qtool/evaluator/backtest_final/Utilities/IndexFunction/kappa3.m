%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算Kappa3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function kappaC = kappa3( R,Rf )
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

kappaC = mean(R-Rf)/nthroot(PM(R,Rf,3,0),3);
% 计算偏矩，HorL~=0时为高偏矩，HorL==0时是低偏矩，TR、Rf是收益率序列和无风险收益序列，n表示偏矩的阶数
    function PM = PM( R,Rf,n,HorL )
        difRR = R - Rf;
        lenTR = length(R);
        if HorL == 0
            baseRR = min(difRR,zeros(lenTR,1));
        else
            baseRR = max(difRR,zeros(lenTR,1));
        end
        sTRR = sum(baseRR.^n);
        PM = sTRR/lenTR;
        
    end

end

