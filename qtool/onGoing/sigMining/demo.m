% demo of signal mining on Bars
% huajun 2014/9/12

clear all;
clc;
rehash;

%% set path 
addpath(genpath('V:\root\qtool\data\'));
addpath(genpath('V:\root\qtool\framework'));
addpath(genpath('v:\root\qtool\indicator'));
workpath= 'd:\huajun\focus\sigMining\';


if ~exist(workpath, 'dir'), mkdir(workpath);end
cd(workpath);
cachepath = [workpath, 'cache\'];
if ~exist(cachepath, 'dir'), mkdir(cachepath);end

%% set sample
config.stockCode = '000012.SZ';
config.bgnDate   = '20140501';
config.endDate   = '20140701';

%% get data 
filename = [cachepath, 'Bars',config.stockCode(1:6),'.mat' ];
if ~exist(filename, 'file')
    tic
    [sBars, sflag] = Fetch.dbStockBars(config.stockCode, config.bgnDate, config.endDate,1, 1);
    toc
    save(filename,'config', 'sBars');
end

load(filename)

sigTest = sig(sBars);

%% indicator

% specify indicator method and param

%%%%%%%%%%
% insert more indicators
[ aroon_long, aroon_short, aroon_rs] = tai.Aroon(sBars.high,sBars.low);
[ macd_long,  macd_short,  macd_rs ] = tai.Macd(sBars.close);

%%%%%%%%%%

sigTest.indVal = [aroon_long, aroon_short, macd_long, macd_short];

% add indicator method and param
sigTest.indName = {'aroon_long_default', 'aroon_short_default', 'macd_long_default', 'macd_short_default'};

%% signal prediction test

% default parameter


sigTest.setSig(@sign);
sigTest.sigTag = {1, -1};
sigTest.sigName = {'sign_pos','sign_neg'};

evalParam.nStep = 30;
evalParam.overlap = 1;
evalParam.retThread = 0.0005;

sigReport = sigTest.testSig(@defaultEval, evalParam);

%% entry signal based on indicator
sigTest.setEntry(@ind2entry);

%% exit signal
tic
exitParam.nT = 1/2; % ����
exitParam.nB =[];
exitParam.stopWin =[];
exitParam.stopLoss = [];
exitParam.WMStart = [];
exitParam.WMExit = [];
sigTest.setExit( exitParam);
toc
%% convert to tradelist
%��ʼ�ʽ�
tradeParam.initNav  = 0;
% ��Լ����
tradeParam.instrType = 0;
% ��Լ����
tradeParam.instrID = {'a'};
% ��������
tradeParam.cmsnRate = 0.0001 ;
% ��֤�����
tradeParam.marginRate =  1;
% ��Լ����
tradeParam.multiplier = 1;
% ����۸�
tradeParam.settlePrice = 2100;
% ����ʱ��
tradeParam.settleTime = today;

[tradePfm, tradeList] = sigTest.testTrade(tradeParam);

% substrategy
nStrategy = unique(sigTest.entry(:,5));
tradeList1 = tradeList.slctByStrategy(1);


