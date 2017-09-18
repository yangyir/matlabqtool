% structure of sig mining

clear all; clc; close all; rehash;
DH

%% set path and environment
addpath(genpath('V:\root\qtool\data\'));
addpath(genpath('V:\root\qtool\framework'));
addpath(genpath('v:\root\qtool\indicator'));
workpath= 'd:\huajun\focus\sigMining\';
if ~exist(workpath, 'dir'), mkdir(workpath);end
cd(workpath);
cachepath = [workpath, 'cache\'];
if ~exist(cachepath, 'dir'), mkdir(cachepath);end

%% set sample
init_date ='20130101' ;
last_date ='20130130' ;
universe  ='000300.SH' ;
stockList = DH_E_S_IndexComps(universe, init_date,0 );
if isempty(stockList), error('require at least one stock'); end


 for iStock = 1:length(stockList)
    stockCode = cell2mat(stockList(iStock));
    
    
    stockFile = [cachepath, 'Bars',stockCode(1:6),'_',init_date,'_',last_date,'.mat' ];
    
    if ~exist(stockFile, 'file')
        tic
        try
            [sBars, sFlag] = Fetch.dbStockBars(stockCode, init_date, last_date, 1, 1);
        catch
            continue;
        end
        toc
        if sFlag
            save(stockFile, 'sBars','stockCode', 'init_date', 'last_date');
        else 
            continue;
        end
    end
    
    load(stockFile);
    
    sigTest = sig(sBars);
    
    %% set ind and param
    tic
    setIndicator;
    toc

    %% set sig and tag
    tic
    sigTest.setSig(@sign);
    toc

    
    %% set test and param
    
    tic
    disp('一个bar变化');
    sigReport1= sigTest.testSig(@defaultEval);
    toc
    
    
    tic
    disp('5个bar变化');
    t.nStep = 5;
    t.overlap = 1;
    sigReport2 = sigTest.testSig(@defaultEval, 'param',t);
    toc
    
    tic
    disp('15个bar变化');
    t.nStep = 15;
    t.overlap = 1;
    sigReport3 = sigTest.testSig(@defaultEval, 'param',t);
    toc
    
    tic
    disp('30个bar变化');
    t.nStep = 30;
    t.overlap = 1;
    sigReport4 = sigTest.testSig(@defaultEval, 'param',t);
    toc
    
    tic
    disp('60个bar变化');
    t.nStep = 60;
    t.overlap = 1;
    sigReport5 = sigTest.testSig(@defaultEval, 'param',t);
    toc
    
    tic
    disp('180个bar变化');
    t.nStep = 180;
    t.overlap = 1;
    sigReport6 = sigTest.testSig(@defaultEval, 'param',t);
    toc
    
    
    save(stockFile, 'sigTest','sigReport*','-append');

 end


