% % ������ӯ������,�������R�ǽ���ӯ�����
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