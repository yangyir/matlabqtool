function maxConGainTime = maxConGainTime(nav)
% ������ӯ������
% nav �ʲ���ֵ���ɽ��ܾ���
% ------------------
% Pan,qichao
% �̸գ�20150510��С��
% ��һ�Σ�20150511������������Ϊ������nav��������rate,��ͬʱɾȥflag
% �̸գ�20150529�����ȫ����Ӯ��������߼����⣬��һ��L33��



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
    
    % ���ȫ������Ӯ����Ҫ������һ��
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