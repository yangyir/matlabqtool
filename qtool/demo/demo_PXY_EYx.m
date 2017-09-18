%% load data
tic

clear;
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130116.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130117.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130118.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130121.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130122.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130123.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130124.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130125.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130128.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130129.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130130.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130131.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130104.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130107.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130108.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130109.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130110.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130111.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130114.mat');
load('Y:\qdata\IF\intraday_bars_10s_daily\IF0Y00_20130115.mat');




%% 连接多段日数据

% seq = bars.vwap;

% seq = linkSeqs({    IF0Y00_20130116.vwap, ...
%                     IF0Y00_20130117.vwap, ...
%                     IF0Y00_20130118.vwap, ...
%                     IF0Y00_20130121.vwap, ...
%                     IF0Y00_20130122.vwap, ...
%                     IF0Y00_20130123.vwap, ...
%                     IF0Y00_20130124.vwap, ...
%                     IF0Y00_20130125.vwap, ...
%                     IF0Y00_20130128.vwap, ...
%                     IF0Y00_20130129.vwap, ...
%                     IF0Y00_20130130.vwap, ...
%                     IF0Y00_20130131.vwap  } );


seq = [     IF0Y00_20130116.vwap; ...
            IF0Y00_20130117.vwap; ...
            IF0Y00_20130118.vwap; ...
            IF0Y00_20130121.vwap; ...
            IF0Y00_20130122.vwap; ...
            IF0Y00_20130123.vwap; ...
            IF0Y00_20130124.vwap; ...
            IF0Y00_20130125.vwap; ...
            IF0Y00_20130128.vwap; ...
            IF0Y00_20130129.vwap; ...
            IF0Y00_20130130.vwap; ...
            IF0Y00_20130131.vwap  ];
toc

%% Y:= 目标分数，此处用上涨情况，用k表示
tic

y = calck(seq);

figure;
hist(y,200);


toc

%% X：=指标情况，以rsi为例，并单独看分布
tic

[~, ~, ~, ll]   = tai.Leadlag(seq);
x               = ll.lead - ll.lag;

figure
hist(x,200);

toc


%% 联合概率函数 pxy，并看分布
tic
ynodes = -1:0.05:1;
xnodes = -4:0.1:4;
[pxy, N ]  = PXY(x,y,1,xnodes,ynodes);

toc


%% 条件期望 E(Y|X),x的函数
tic
[EY_x, xnodes,xcount] = EYx( x, y, 1, xnodes);

% figure
% plot( xnodes, EY_x, '-*');

toc



