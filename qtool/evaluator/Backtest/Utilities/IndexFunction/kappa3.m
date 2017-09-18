%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ���Kappa3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function kappaC = kappa3( R,Rf )
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

kappaC = mean(R-Rf)/nthroot(PM(R,Rf,3,0),3);
% ����ƫ�أ�HorL~=0ʱΪ��ƫ�أ�HorL==0ʱ�ǵ�ƫ�أ�TR��Rf�����������к��޷����������У�n��ʾƫ�صĽ���
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

