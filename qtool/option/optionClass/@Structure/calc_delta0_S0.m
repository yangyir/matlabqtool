function [S0, delta0] = calc_delta0_S0(obj, S_min, S_max, step, flagVolsurfAccuracy)
% ����ʹ��delta=0�ĵ�S0
% [S0, delta0] = calc_delta0_S0( S_min, S_max, step, flagVolsurfAccuracy)
% flacVolsurfAccuracy: S��ͬʱ�Ƿ�������sigma��0���ٶȿ죬�ֲڣ�Ĭ�ϣ�1�ǣ��ٶ��������ȸߣ�
% -----------------------------
% �콭��20160329

if ~exist('S_min', 'var')
    S_min = 1.5;
end

if ~exist('S_max' , 'var')
    S_max = 2* S_min;
end

if ~exist('step', 'var')
    step = (S_max - S_min)/1000;
end

if ~exist('flagVolsurfAccuracy', 'var')
    flagVolsurfAccuracy = 0;
end

S = S_min : step : S_max;
tempS = obj.getCopy;
delta = 0.0;
% calc delta of S;
L = length(S);


if flagVolsurfAccuracy == 1
    
    % ��ϸ������ÿ����ͬ��Sʹ�ò�ͬ��sigma
    for i = 1:L
        tempS.S = S(i);
        tempS.inject_environment_params();
        try
            delta(i) = tempS.calcDelta;
        catch e
            delta(i) = 10000;
            disp(e);
        end
    end
    
else
    % �ֲڴ��������vol����S���仯����20������
    % ������S��Χ����ʱ
    tempS.S  = ( S_min + S_max ) /2 ;
    tempS.inject_environment_params();
    
    for j = 1:length(tempS.optPricers)
        tempS.optPricers(j).S = S;
    end
    delta = tempS.calcDelta;
    
end

% check delta == 0;
delta_abs = abs(delta);
% ����
[sorted_delta, idx] = sort(delta_abs, 'ascend');

% ֻȡ��һ�����������жദdelta0������
for j = 1:L
    if(sorted_delta(j) < 0.01)
        S0      = S(idx(j));
        delta0  = delta(idx(j));
        return;
    end
end

disp('û���ҵ�delta0��S0��,delta��С�ĵ�Ϊ��');
S0      = S(idx(1));
delta0  = delta(idx(1));

end
