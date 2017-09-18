%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数作用为计算上下行捕获收益。Rbm为市场收益率，UCR、DCR为上下行捕获收益。
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
%获取市场上行和下行时的收益Rt1、Rt2，上下行时期的数量记录在j、k中

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

