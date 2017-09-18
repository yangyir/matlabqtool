function [ score ] = momentumStart( seq,window_param )
%MOMENTUMSTART gives high score to momentum starting points
% score           取值[ -4 : +4 ], pos: up trend; neg: down trend
% seq             待打分序列
% window_param    取值(0,1),默认0.01, 中心移平半窗长 = window_param * length(seq) 
% ver1.0; Cheng,Gang; 20130409
% ver1.1; Cheng,Gang; 20130416; 加入window_param变量



%% pre-process
if ~exist('window_param', 'var') 
    window_param = 0.01;
end

%% CMA(Centric Mov. Avg.中心移平) as trend
len = length(seq);
semi_window = ceil(len * window_param);
cma = tai.Cma( seq, semi_window);


%% cma 的斜率(比导数平滑）, k一阶，kk二阶
[k, kk ] = calck(cma);


%% 分层，离散打分
score = nan(len,1);

pct = [0;30;45;55;70;100];
pctl = prctile(k, pct);

% 仅根据一阶导 
score( k<pctl(2)                ) = -2;
score( pctl(2)<=k & k<pctl(3)   ) = -1;
score( pctl(3)<=k & k<pctl(4)   ) = 0;
score( pctl(4)<=k & k<pctl(5)   ) = 1;
score( k>=pctl(5)               ) = 2;

% 也根据二阶导
dscore = zeros(len,1);
dscore( k<pctl(2) & kk<0        ) = -2;
score = score + dscore;

dscore = zeros(len,1);
dscore( k>=pctl(5) & kk>0       ) = 2;
score = score + dscore;



end

