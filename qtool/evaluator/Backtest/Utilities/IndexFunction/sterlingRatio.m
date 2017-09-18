%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算sterling ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sterlingR = sterlingRatio( R,Rf,slicesPerDay)
loc = isnan(R) | isnan(Rf);
R (loc) = [];
Rf(loc) = [];
md = MD(R);
md(md==0) = [];
sterlingR = -mean(R-Rf)/mean(md);

sterlingR = sterlingR*(250*slicesPerDay);
% 本子函数用于计算回撤
    function md = MD(Data)
        high = zeros(size(Data));
        md = zeros(size(Data));
        
        for t = 2:length(Data)
            high(t)=max(high(t-1),Data(t));
            md(t)=Data(t)-high(t);
        end
    end
end

