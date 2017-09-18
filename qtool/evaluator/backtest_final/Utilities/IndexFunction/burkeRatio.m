%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算burke ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function burkeR = burkeRatio( R,Rf,slicesPerDay )
loc = isnan(R) | isnan(Rf);

R (loc) = [];
Rf(loc) = [];
md = MD(R);
md(md==0) = [];
burkeR = mean(R-Rf)/norm(md);
burkeR = burkeR*(250*slicesPerDay);
% 这个子函数用于计算回撤
    function md = MD(Data)
        high = zeros(size(Data));
        md = zeros(size(Data));
        for t = 2:length(Data)
            high(t)=max(high(t-1),Data(t));
            md(t)=Data(t)-high(t);
        end
    end

end

