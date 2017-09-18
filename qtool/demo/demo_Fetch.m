%% *****************************************************************
% 2013.12.11：
% 1.  提取股票数据

% version 1.0, luhuaibao, 2013.12.11




%% *************************** 前期处理 *****************************
clear;
clc, close all ;

stockName = '600000.SH' ; 
startDate = '2013-12-01';
endDate = '2013-12-11';
sliceSeconds = 60 ; 
reType = 3 ; % qian fu quan 





%% *************************** 设置路径 *****************************

addpath(     genpath('V:\qtool\'), '-begin' );
 

% 当前路径
currPath        = fileparts(mfilename('fullpath'));
cd(currPath);

% 生成保存路径
fileName        =   stockName  ;

savePath        = [currPath, '\',fileName,'\'] ;
if ~isdir(savePath),mkdir(savePath); end

% set path
addpath(genpath(currPath));





%% *************************** 进行提取 *****************************

bars = Fetch.stockBars(stockName,startDate, endDate,sliceSeconds, reType );





%% *************************** 后处理中 *****************************

% 截取样本 
% dstart  =  '20110905'  ;
% dend    =   '20111230'   ;

 

%% *************************** 数据保存 *****************************

% 保存格式：600000.SH_20131201_20131211_60s

 save([savePath, '\',stockName,'_',datestr(startDate,'yyyymmdd'),'_',datestr(endDate,'yyyymmdd'),'_',num2str(sliceSeconds),'s.mat'],'bars');
