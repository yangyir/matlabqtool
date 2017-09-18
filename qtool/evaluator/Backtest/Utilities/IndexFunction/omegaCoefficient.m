%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ���omegaϵ�� 
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

% ����ƫ�أ�HorL~=0ʱΪ��ƫ�أ�HorL==0ʱ�ǵ�ƫ�أ�TR��Rf�����������к��޷����������У�n��ʾƫ�صĽ���
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

