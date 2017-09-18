%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算上行潜力比。TR、Rf为收益率序列和无风险收益率序列
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function upPotentialR = upsidePotentialRatio( TR,Rf)
  upPotentialR = PM(TR,Rf,1,1)/nthroot(PM(TR,Rf,2,0),2);
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

