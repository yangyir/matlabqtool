%% *****************************************************************
% 2013.12.11��
% 1.  ��ȡ��Ʊ����

% version 1.0, luhuaibao, 2013.12.11




%% *************************** ǰ�ڴ��� *****************************
clear;
clc, close all ;

stockName = '600000.SH' ; 
startDate = '2013-12-01';
endDate = '2013-12-11';
sliceSeconds = 60 ; 
reType = 3 ; % qian fu quan 





%% *************************** ����·�� *****************************

addpath(     genpath('V:\qtool\'), '-begin' );
 

% ��ǰ·��
currPath        = fileparts(mfilename('fullpath'));
cd(currPath);

% ���ɱ���·��
fileName        =   stockName  ;

savePath        = [currPath, '\',fileName,'\'] ;
if ~isdir(savePath),mkdir(savePath); end

% set path
addpath(genpath(currPath));





%% *************************** ������ȡ *****************************

bars = Fetch.stockBars(stockName,startDate, endDate,sliceSeconds, reType );





%% *************************** ������ *****************************

% ��ȡ���� 
% dstart  =  '20110905'  ;
% dend    =   '20111230'   ;

 

%% *************************** ���ݱ��� *****************************

% �����ʽ��600000.SH_20131201_20131211_60s

 save([savePath, '\',stockName,'_',datestr(startDate,'yyyymmdd'),'_',datestr(endDate,'yyyymmdd'),'_',num2str(sliceSeconds),'s.mat'],'bars');
