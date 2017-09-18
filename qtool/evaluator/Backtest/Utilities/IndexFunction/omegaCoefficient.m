%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算omega系数 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function omegaC = omegaCoefficient( R,Rf)

loc = isnan(R) | isnan(Rf);

R (loc) = [];
Rf(loc) = [];
if size(R,1)>1
    omegaC = mean(R-Rf)/PM(R,Rf,1,0)+1;
else
    omegaC = nan;
end

% 计算偏矩，HorL~=0时为高偏矩，HorL==0时是低偏矩，TR、Rf是收益率序列和无风险收益序列，n表示偏矩的阶数
    function PM = PM( TR,Rf,n,HorL )
        %HorL not zero stands for H; 0 stands for L
        difRR = TR - Rf;
        lenTR = length(TR);
        if HorL == 0
            baseRR = min(difRR,zeros(lenTR,1));
        else
            baseRR = max(difRR,zeros(lenTR,1));
        end
        sTRR = sum(baseRR.^n);
        PM = sTRR/lenTR;
        %PM = nthroot(sTRR/(lenTR-1),n);
    end
end

