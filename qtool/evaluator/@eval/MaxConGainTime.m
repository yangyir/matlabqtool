
function maxConGainTime = MaxConGainTime( navOrRate, flag)
% 最大持续盈利次数
% navOrRate 资产净值或比率
% flag 'val'表示净值，'pct'表示百分比变化。默认为'pct'

if nargin < 2
    flag = 'pct';
end

if strcmp( flag, 'val');
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
end

[nPeriod, nAsset]=size(navOrRate);
maxConGainTime = zeros(1, nAsset);

for jAsset= 1:nAsset
    
    tempConGain = 0;
    for iPeriod = 1:nPeriod
        if navOrRate(iPeriod,jAsset) > 0
            tempConGain = tempConGain + 1;
            continue;
        end
        maxConGainTime(jAsset) = max(maxConGainTime(jAsset),tempConGain);
        tempConGain = 0;
    end
end

end
%{
previous version
     function maxConGainTimeRet = maxConGainTime(R)
         R(R>0) = 1;
         if R(end) == 1
             R = [R;-1];
         end
         indexMax = 0;
         maxTemp = 0;
         for i = 1:length(R)
             if R(i) == 1
                 maxTemp = maxTemp + 1;
             else
                 indexMax = indexMax + 1;
                 maxGain(indexMax) = maxTemp;
                 maxTemp = 0;
             end
         end
         maxConGainTimeRet = max(maxGain);
     end
%}