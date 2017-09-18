function [S0, delta0] = calc_delta0_S0(obj, S_min, S_max, step, flagVolsurfAccuracy)
% 计算使得delta=0的点S0
% [S0, delta0] = calc_delta0_S0( S_min, S_max, step, flagVolsurfAccuracy)
% flacVolsurfAccuracy: S不同时是否重新算sigma（0否，速度快，粗糙，默认；1是，速度慢，精度高）
% -----------------------------
% 朱江，20160329

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
    
    % 精细处理，对每个不同的S使用不同的sigma
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
    % 粗糙处理，不理会vol随着S而变化，快20倍以上
    % 适用于S范围不大时
    tempS.S  = ( S_min + S_max ) /2 ;
    tempS.inject_environment_params();
    
    for j = 1:length(tempS.optPricers)
        tempS.optPricers(j).S = S;
    end
    delta = tempS.calcDelta;
    
end

% check delta == 0;
delta_abs = abs(delta);
% 排序
[sorted_delta, idx] = sort(delta_abs, 'ascend');

% 只取第一个，不处理有多处delta0点的情况
for j = 1:L
    if(sorted_delta(j) < 0.01)
        S0      = S(idx(j));
        delta0  = delta(idx(j));
        return;
    end
end

disp('没有找到delta0的S0点,delta最小的点为：');
S0      = S(idx(1));
delta0  = delta(idx(1));

end
