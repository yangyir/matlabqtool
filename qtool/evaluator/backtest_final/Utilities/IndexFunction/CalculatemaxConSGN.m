%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ����������ӯ��ʱ��������������ʱ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [maxConWinSlices,maxConLoseSlices]=CalculatemaxConSGN(Returns)

Returns(Returns>0)=1;
Returns(Returns<0)=-1;
count=zeros(2,length(Returns));
j=1;
if Returns(1)==1
    count(1,1)=1;
elseif Returns(1)==-1
    count(2,1)=1;
end


for Index=2:length(Returns)
    if Returns(Index)==1
        count(1,j)=count(1,j)+1;
    elseif Returns(Index-1)==1 &&Returns(Index)~=1
        j=j+1;
    elseif Returns(Index-1)==-1
        count(2,j)=count(2,j)+1;
    elseif Returns(Index-1)==-1 &&Returns(Index)~=-1
        j=j+1;
    end
end

% ȡ���ֵ
maxConWinSlices=max(count(1,:));
maxConLoseSlices = max(count(2,:));
end