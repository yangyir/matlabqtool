function [extremaHigh, extremaLow, currentStat] = LastExtrema(data, mu_up, mu_down)
% �������ĸߵ㣬�͵�,�Լ���ǰ���½������������������ļ�ֵ�㣩
% ����trendAnalysis
% ���hhigh �� llow������lastExtrema���޶���ȥ����,����ʹ��б�����жϼ�ֵ��

%% Ԥ����
[stat, lastSure] = trendAnalysis( data, mu_up, mu_down );

nPeriod = size(stat,1);
extremaHigh = nan(nPeriod, 1);
extremaLow  = nan(nPeriod, 1);
currentStat = zeros(nPeriod,1);

%% ���㲽
idxExtrema = unique(lastSure);
valExtrema = nan(size(idxExtrema));
valExtrema(1) = nan;
valExtrema(2:end) = data(idxExtrema(2:end));

for i = 2 : size(idxExtrema,1)
    if stat(idxExtrema(i)) == 1 % ���������Ǿֲ��ߵ�
        valHigh = valExtrema(i);
        valLow  = valExtrema(i-1);
        currentStat(lastSure == idxExtrema(i)) = 1;
    else                        % ����������Ǿֲ��͵�
        valHigh = valExtrema(i-1);
        valLow  = valExtrema(i);
        currentStat(lastSure == idxExtrema(i)) = -1;
    end
    extremaHigh(lastSure == idxExtrema(i)) = valHigh;
    extremaLow(lastSure  == idxExtrema(i)) = valLow;
end

end %EOF

    
    







