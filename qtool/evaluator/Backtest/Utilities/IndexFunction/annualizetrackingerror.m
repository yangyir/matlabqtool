%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算年化跟踪误差
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function trackingError = annualizetrackingerror(R,Rm,Step)

loc = isnan(R) | isnan(Rm);
R (loc) = [];
Rm (loc) = [];

trackingError = (sum((R-Rm).^2)/(length(R)-1))^0.5;

% 计算年化系数
switch Step
    case 1
        annualCoe = 250;
    case 2
        annualCoe = 52;
    case 3
        annualCoe = 12;
    case 4
        annualCoe = 4;
    case 5
        annualCoe = 2;
    case 6
        annualCoe = 1;
    otherwise
        error('Please check the period value, it should be an integer between 1 to 6.');
end

trackingError = trackingError*(annualCoe^0.5);

end

