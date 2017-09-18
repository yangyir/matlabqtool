function maxConGainTime = maxConGainTime(nav)
% 最大持续盈利次数
% nav 资产净值，可接受矩阵
% ------------------
% Pan,qichao
% 程刚，20150510，小改
% 唐一鑫，20150511，将参数调整为仅接受nav而不接受rate,故同时删去flag
% 程刚，20150529，如果全部是赢，会出现逻辑问题，加一句L33处



%% main

Rate = log(nav(2:end,:)./nav(1:end-1,:));


[nPeriod, nAsset]=size(Rate);
maxConGainTime = zeros(1, nAsset);

for jAsset= 1:nAsset
    
    tempConGain = 0;
    for iPeriod = 1:nPeriod
        if Rate(iPeriod,jAsset) > 0
            tempConGain = tempConGain + 1;
            continue;
        end
        maxConGainTime(jAsset) = max(maxConGainTime(jAsset),tempConGain);
        tempConGain = 0;
    end
    
    % 如果全部都是赢，需要跳到这一句
    maxConGainTime(jAsset) = max(maxConGainTime(jAsset),tempConGain);

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