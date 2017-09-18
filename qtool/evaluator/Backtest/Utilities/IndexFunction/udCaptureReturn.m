%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������Ϊ���������в������档RbmΪ�г������ʣ�UCR��DCRΪ�����в������档
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ UCR, DCR ] = udCaptureReturn( Rbm,Rt )
% matlab code
j=0;
k=0;
lenRbm = length(Rbm);
for i=1:lenRbm
    if Rbm(i)>=0
        Rt1(j+1) = Rt(i);
        j = j+1;
    else
        Rt2(k+1) = Rt(i);
        k=k+1;
    end
end
%��ȡ�г����к�����ʱ������Rt1��Rt2��������ʱ�ڵ�������¼��j��k��

if j>0
    sUCR = prod(1+Rt1);
    UCR = nthroot(sUCR,j)-1;
else UCR = [];
end

if k>0
    sDCR = prod(1+Rt2);
    DCR = nthroot(sDCR,k)-1;
else DCR = [];
end

end

