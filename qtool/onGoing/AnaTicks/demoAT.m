%% *****************************************************************
% version 1.0, luhuaibao, 2014.5.30
% ����AnaTicks�࣬�����ticks���л�������ͳ��
 




%% *************************** ǰ�ڴ��� *****************************
clear;
clc, close all ;
 


% ��ǰ·��
currPath        = fileparts(mfilename('fullpath'));
cd(currPath);

% ���ɱ���·��
fileName        =   'result'  ;

savePath        = [currPath, '\',fileName,'\'] ;
if ~isdir(savePath),mkdir(savePath); end


% ���ݴ洢·��
fileNameData        =   'data'  ;

savePathData        = [currPath, '\',fileNameData,'\'] ;
if ~isdir(savePathData ),mkdir(savePathData ); end

% set path
addpath(genpath(currPath));




%% *************************** loadData ***************************** 
loadAT ; 

%% *************************** testAT ***************************** 
% testAT ; 

%% *************************** orderDepth ***************************** 
% orderDepth

%% ****** [ ] = plotPanKou( ts, cur, pre_win, post_win );
% �̸գ�140609
help AnaTicks.plotPanKou
figure
AnaTicks.plotPanKou( ifTicks, 1903);

figure
AnaTicks.plotPanKou(stockTicks, 1903);

%% ****** [prct]  = percentileP(ticks, currentTk, valuePrice, win, type)
% �̸գ�140609
help AnaTicks.percentileP
price   = ifTicks.askP(1903,1)
prct    = AnaTicks.percentileP( ifTicks, 1903, price, 1800, 'ask')

%% ****** [value] = percentileV(ticks, currentTk, percentile, win, type)
% �̸գ�140609
help AnaTicks.percentileV
percentile  = 90
value       = AnaTicks.percentileV( ifTicks, 1903, 90, 1800, 'ask')      
      
%% ****** [ spread0, spTicks ] = pairSpread(ticks1, ticks2, type, timeType, commonTime)
help AnaTicks.pairSpread
dt = '20130408';
ticks1 = Fetch.dmTicks('IF0Y00', dt, dt);
ticks2 = Fetch.dmTicks('IF0Y01', dt, dt);
ticks3 = Fetch.dmTicks('IF0Y02', dt, dt);

[sp,spTicks] = AnaTicks.pairSpread(ticks1, ticks2);
% sp2 = AnaTicks.pairSpread(ticks1, ticks3);

iplot.value_hist(sp);
AnaTicks.plotBas(spTicks);

%% ******  [] = animate_pankou(ticks, stk, etk, step, pauseSec)  ******
help AnaTicks.animate_pankou
AnaTicks.animate_pankou(ifTicks, 2, 200, 1, 0.2);

%% ******  [] = animate_line_pankou(ticks, stk, etk, step, twindow, pauseSec);
help AnaTicks.animate_line_pankou
AnaTicks.animate_line_pankou(ifTicks, 2200, 2300);   

