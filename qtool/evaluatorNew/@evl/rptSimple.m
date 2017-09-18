function [ txt, txt2 ] = rptSimple( nav, varargin)
% 计算常见指标，输出到txt。需要matlab2014版
% [ txt, txt2 ] = rptSimple( nav, varargin)
%   nav：净值曲线
%   benchmark： 如有，位置必须是第二个
% 用 varname, varvalue 的形式输入以下变量：
%   rfr：无风险收益，默认5%
%   period：数据周期，可取如下值： d365, d360, d245, w, m, q, y, 默认为d245
%   benchmark：如有，则多算一些相对收益的指标，否则不算
% -----------------
% 程刚，20150529，初版本
% 唐一鑫，20150719，将输入格式改为('varName',varValue)的形式，其中
%   nav和benchmark只需输入varValue而不用varName

% %% 前处理
% if ~exist('rfr', 'var')
%     rfr = 0.05;
% end
% if ~exist('period', 'var')
%     period = 'd245';
% end
% 
% GIVEN_BENCHMARK = 1;
% if ~exist('benchmark', 'var')
%     GIVEN_BENCHMARK = 0;    
% end
% 
% % 归一化，nav
% nav = nav / nav(1);
% L   = length(nav);

%% Rewrite preprocessing

p = inputParser;

% The Default value for each parameter 
defaultRfr = 0.05;
defaultPeriod = 'd245';
defaultBenchmark = zeros(length(nav),1);

% Add Parser to Input and Set validation
addRequired(p,'nav',@isnumeric);
addParameter(p,'rfr',defaultRfr,@isnumeric);
addParameter(p,'period',defaultPeriod,@(x) strcmp(x,'d365') ...
    | strcmp(x,'d360') | strcmp(x,'d245') | strcmp(x,'m')...
    | strcmp(x,'w') | strcmp(x,'q') |strcmp(x,'y') == 1);
addOptional(p,'benchmark',defaultBenchmark,@isnumeric);

parse(p,nav,varargin{:});

GIVEN_BENCHMARK = 1;

if any (p.Results.benchmark) == 0
    GIVEN_BENCHMARK = 0;
end

nav = p.Results.nav;
rfr = p.Results.rfr;
period = p.Results.period;
benchmark = p.Results.benchmark;


% 归一化，nav
nav = nav / nav(1);
L   = length(nav);    








% 初始化输出
txt = '';
txt2 = '';

%% 计算各种指标
aYield      = evl.annualYield(nav, period);
aVol        = evl.annualVol( nav, period);
maxConGain  = evl.maxConGainTime( nav);
mddVal      = evl.maxDrawDownVal(nav);
mdd         = evl.maxDrawDown(nav);
ldd         = evl.longestDrawDown(nav);

% 需要rfr的指标
sharpeR     = evl.SharpeRatio(  nav, rfr, period);
calmarR     = evl.CalmarRatio(  nav, rfr, period);
burkeR      = evl.BurkeRatio(   nav, rfr);


%% 文字
txt = '';
txt = sprintf('%s区间长度: %d\n',      txt, L);
txt = sprintf('%s区间收益: %0.1f%%\n', txt, nav(end)/nav(1)*100-100);
txt = sprintf('%s年化收益: %0.1f%%\n', txt, aYield*100);
txt = sprintf('%s年化vol:  %0.1f%%\n', txt, aVol*100);
txt = sprintf('%s最大回撤: %0.1f%%\n', txt, mdd*100);
txt = sprintf('%s最长回撤：%d\n',     txt, ldd);
txt = sprintf('%s最长连赢：%d\n',     txt, maxConGain);
txt = sprintf('%sSharpeR: %0.2f\n', txt, sharpeR);
txt = sprintf('%sCalmarR: %0.2f\n', txt, calmarR);


%% 如果给了Benchmark，多算一些指标
% 需要benchmark的指标
if GIVEN_BENCHMARK
    b  = benchmark(:,1);
    % 归一化，benchmark
    b = b / b(1);

    % 计算
    alpha       = evl.alpha(nav,b);
    beta        = evl.beta(nav,b);
    sortinoR    = evl.SortinoRatio(nav,b);
    treynorR    = evl.TreynorRatio( nav, b);
    infoR       = evl.InfoRatio( nav, b);
    
    % 输出
    txt2 = '';
    txt2 = sprintf('%salpha:   %0.2f\n', txt2, alpha);
    txt2 = sprintf('%sbeta:    %0.2f\n', txt2, beta);
    txt2 = sprintf('%sinfoR:   %0.2f\n', txt2, infoR);
    txt2 = sprintf('%sSortinoR:%0.2f\n', txt2, sortinoR);
    txt2 = sprintf('%sTreynorR:%0.2f\n', txt2, treynorR);
end


end

