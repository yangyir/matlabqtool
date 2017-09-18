function [ ] = demo_test_v1(  )
%DEMO TEST
% 干的事情是：
% 从excel中初始化当日所有期权信息
% 然后，建立一个structure，算payoff，画图
% 考虑期权成本，暂用理论价格
% ---------------------------
% 黄勉，20160126
% 吴云峰，fantuanxiaot，20160126
% 黄勉，20160128，修改drawpayoff 函数，加入cost
% 黄勉/吴云峰，20160128，增加table，方便使用
% 吴云峰，20160229，基于OptPricer的获取的方法进行替代
% 吴云峰/黄勉，20160316，结合OptPricer/OptInfo 方法
% 黄勉，20160316，增加设定每张期权波动率
% 黄勉，20160316，增加两个例子

%% -------------------------------清空一下------------------------%%

clc
clear
close all
format compact
format short g

%% -------------------------------初始化( 注意是基于optPricer )-----------------------------%%

%path = 'D:\intern\optionClass\@OptInfo\';       % 根据情况修改
path = 'I:\new\intern\optionClass\';   % Mian Huang local path
fn = 'OptInfo.xlsx';                             % 根据情况修改

%% --------------------------------读取数据---------------------------------------------%%

[ ~ , m2tkCallPricer , m2tkPutPricer ] = OptPricer.init_from_sse_excel( [ path , fn ] );
% 这是获取得到OptPricer的数据

%% 画组合图

[ ~, m2tkCallinfo, m2tkPutinfo ] = OptInfo.init_from_sse_excel( [path, fn] );


%% -------------构建期权组合 -------------------%%

sPricer = Structure;
sInfo   = Structure;
L = length( m2tkCallinfo.xProps );

% 取所有T相同的合约出来， 是否取成2维的？
k = 3;
for i = 1:L
    sPricer.optPricers(1,i) = m2tkCallPricer.data(k,i);
    sPricer.optPricers(2,i) = m2tkPutPricer.data(k,i);
    sInfo.optInfos( 1 , i ) = m2tkCallinfo.data( k , i );
    sInfo.optInfos( 2 , i ) = m2tkPutinfo.data( k , i );
end

%% 在structure sPricer 里计算期权价格，然后利用sInfo 画图
% 需要一个函数确定s.num 位置/ 修改为tabel类型更好
% 检查当前价
% S; 
% 第一行是call 量，第二行是put 量

sInfo.num = zeros(2,L); 
% s.num(1,4:7)  = [-0,1,0,0];
% s.num(2,3:9) =  [ 1, -2, 0, 0, 1, -1, 1];

RowNames = cellfun( @num2str , num2cell( m2tkCallPricer.xProps ) , ...
    'UniformOutput' , false );
t2 = table( sInfo.num(1,:)',sInfo.num(2,:)',...
    'RowNames',RowNames,...
    'VariableNames',{'call','put'});

t2{ {'2.05'}  , {'put'}}   = -1; % 直接输入相应买入卖出量
t2{ {'2.05'}  , {'call'}} = -1;    % '2' 跟‘2.0’不一样

t2{ {'2.1'}  , {'call'}}   = 1; % 直接输入相应买入卖出量
t2{ {'1.8'}  , {'put'}} = 1;    % '2' 跟‘2.0’不一样

% 现在可以计算期权组合的定价
% 取出数据
% s.num(1,6) = 1;
sInfo.num   = table2array(t2)'; 
sPricer.num = sInfo.num;
sInfo.S     = 2.15;
sPricer.S   = sInfo.S;

% 可以对每一张期权设定不同的波动率
for i = 1:L
    sPricer.optPricers(1,i).sigma = 0.2;
    sPricer.optPricers(2,i).sigma = 0.4;
end
cost      = sPricer.calcPx;

ST = 1.6:0.05:2.8;
% s2.calcPayoff( ST );
sInfo.drawPayoff( ST , cost);


%% demo of two strategies
% 1, stock repair, long 1 ATM call sell 2 OTM call 
% plus one best C-P and a bear spread  
sInfo.S   = 2.1;
sPricer.S = sInfo.S;
sInfo.num = zeros(2,L); 
RowNames = cellfun( @num2str , num2cell( m2tkCallPricer.xProps ) , ...
    'UniformOutput' , false );
t2 = table( sInfo.num(1,:)',sInfo.num(2,:)',...
    'RowNames',RowNames,...
    'VariableNames',{'call','put'});
t2{ {'2'}  , {'call'}} = 1; % 直接输入相应买入卖出量
t2{ {'2.05'}  , {'call'}} = -2;    % '2' 跟‘2.0’不一样

t2{ {'2.1'}  , {'call'}} = 1; % 直接输入相应买入卖出量
t2{ {'2.1'}  , {'put'}} = -1;    % '2' 跟‘2.0’不一样

t2{ {'1.95'}  , {'call'}} = 2; % 直接输入相应买入卖出量
t2{ {'1.8'}  , {'call'}} = -2;    % '2' 跟‘2.0’不一样
sInfo.num   = table2array(t2)'; 
sPricer.num = sInfo.num;
cost      = sPricer.calcPx;
ST = 1.6:0.05:2.6;
sInfo.drawPayoff( ST , cost);

% 2, sell 1 strip with low K then buy one call 
% plus one best C-P and a bear spread  
sInfo.S   = 2.1;
sPricer.S = sInfo.S;
sInfo.num = zeros(2,L); 

RowNames = cellfun( @num2str , num2cell( m2tkCallPricer.xProps ) , ...
    'UniformOutput' , false );
t2 = table( sInfo.num(1,:)',sInfo.num(2,:)',...
    'RowNames',RowNames,...
    'VariableNames',{'call','put'});


t2{ {'1.85'}  , {'call'}} = -1; % 直接输入相应买入卖出量
t2{ {'1.85'}  , {'put'}} = -1;    % '2' 跟‘2.0’不一样

t2{ {'1.9'}  , {'call'}} = 1; % 直接输入相应买入卖出量

% 现在可以计算期权组合的定价
% 取出数据
% s.num(1,6) = 1;
sInfo.num   = table2array(t2)'; 
sPricer.num = sInfo.num;
% 可以对每一张期权设定不同的波动率
for i = 1:L
    sPricer.optPricers(1,i).sigma = 0.2;
    sPricer.optPricers(2,i).sigma = 0.4;
end
cost  = sPricer.calcPx;

ST = 1.6:0.05:2.6;
% s2.calcPayoff( ST );
sInfo.drawPayoff( ST , cost);


%% -------------计算50ETF期权组合的期望payoff---------------%%
% 需要考虑ST的分布
% 首先设置ST数据

ST = 1.6:0.05:2.8;
% 可以进行向量计算
payOff = sInfo.calcPayoff( ST );
EF = mean( payOff );
str = sprintf( '期权组合的期望payoff为 = %.3f' , EF );
disp( str );


end

