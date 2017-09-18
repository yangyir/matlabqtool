%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڼ���calmar ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calmarR = calmarRatio( R,Rf,slicesPerDay)
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];

md = MD(R);
md(md==0)=[];
if isempty(md)
    calmarR = nan;
else
    calmarR = -mean(R-Rf)/min(md);
end

calmarR = calmarR*(250*slicesPerDay);
% ���Ӻ������ڼ���س�
    function md = MD(Data)
        high = zeros(size(Data));
        md = zeros(size(Data));
        
        for t = 2:length(Data)
            high(t)=max(high(t-1),Data(t));
            md(t)=Data(t)-high(t);
        end
    end
end

