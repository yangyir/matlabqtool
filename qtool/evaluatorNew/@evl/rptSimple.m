function [ txt, txt2 ] = rptSimple( nav, varargin)
% ���㳣��ָ�꣬�����txt����Ҫmatlab2014��
% [ txt, txt2 ] = rptSimple( nav, varargin)
%   nav����ֵ����
%   benchmark�� ���У�λ�ñ����ǵڶ���
% �� varname, varvalue ����ʽ�������±�����
%   rfr���޷������棬Ĭ��5%
%   period���������ڣ���ȡ����ֵ�� d365, d360, d245, w, m, q, y, Ĭ��Ϊd245
%   benchmark�����У������һЩ��������ָ�꣬������
% -----------------
% �̸գ�20150529�����汾
% ��һ�Σ�20150719���������ʽ��Ϊ('varName',varValue)����ʽ������
%   nav��benchmarkֻ������varValue������varName

% %% ǰ����
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
% % ��һ����nav
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


% ��һ����nav
nav = nav / nav(1);
L   = length(nav);    








% ��ʼ�����
txt = '';
txt2 = '';

%% �������ָ��
aYield      = evl.annualYield(nav, period);
aVol        = evl.annualVol( nav, period);
maxConGain  = evl.maxConGainTime( nav);
mddVal      = evl.maxDrawDownVal(nav);
mdd         = evl.maxDrawDown(nav);
ldd         = evl.longestDrawDown(nav);

% ��Ҫrfr��ָ��
sharpeR     = evl.SharpeRatio(  nav, rfr, period);
calmarR     = evl.CalmarRatio(  nav, rfr, period);
burkeR      = evl.BurkeRatio(   nav, rfr);


%% ����
txt = '';
txt = sprintf('%s���䳤��: %d\n',      txt, L);
txt = sprintf('%s��������: %0.1f%%\n', txt, nav(end)/nav(1)*100-100);
txt = sprintf('%s�껯����: %0.1f%%\n', txt, aYield*100);
txt = sprintf('%s�껯vol:  %0.1f%%\n', txt, aVol*100);
txt = sprintf('%s���س�: %0.1f%%\n', txt, mdd*100);
txt = sprintf('%s��س���%d\n',     txt, ldd);
txt = sprintf('%s���Ӯ��%d\n',     txt, maxConGain);
txt = sprintf('%sSharpeR: %0.2f\n', txt, sharpeR);
txt = sprintf('%sCalmarR: %0.2f\n', txt, calmarR);


%% �������Benchmark������һЩָ��
% ��Ҫbenchmark��ָ��
if GIVEN_BENCHMARK
    b  = benchmark(:,1);
    % ��һ����benchmark
    b = b / b(1);

    % ����
    alpha       = evl.alpha(nav,b);
    beta        = evl.beta(nav,b);
    sortinoR    = evl.SortinoRatio(nav,b);
    treynorR    = evl.TreynorRatio( nav, b);
    infoR       = evl.InfoRatio( nav, b);
    
    % ���
    txt2 = '';
    txt2 = sprintf('%salpha:   %0.2f\n', txt2, alpha);
    txt2 = sprintf('%sbeta:    %0.2f\n', txt2, beta);
    txt2 = sprintf('%sinfoR:   %0.2f\n', txt2, infoR);
    txt2 = sprintf('%sSortinoR:%0.2f\n', txt2, sortinoR);
    txt2 = sprintf('%sTreynorR:%0.2f\n', txt2, treynorR);
end


end

