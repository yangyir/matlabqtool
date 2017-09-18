%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ�������Ǳ���ȡ�TR��RfΪ���������к��޷�������������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function upPotentialR = upsidePotentialRatio( TR,Rf)
  upPotentialR = PM(TR,Rf,1,1)/nthroot(PM(TR,Rf,2,0),2);
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

