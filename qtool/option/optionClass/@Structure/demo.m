function [ ] = demo(  )
%DEMO 
% 干的事情是：
% 从excel中初始化当日所有期权信息( OptInfo )
% DEMO的框架是建立在Structure的optInfos上的
% 然后，建立一个structure，算payoff，画图
% ---------------------------
% 程刚，20160124

%% -------------------------------清空一下------------------------%%

clc
close all
format compact
format short g

%% -------------------------------初始化-----------------------------%%

% 这里的值是OptInfo的值
path = 'D:\intern\optionClass\@OptInfo\';       % 根据情况修改
%path = 'I:\new\intern\optionClass\@OptInfo\';  % Mian Huang local path
fn = 'OptInfo.xlsx';                           % 根据情况修改
[ ~, m2tkCallinfo, m2tkPutinfo] = OptInfo.init_from_sse_excel( [path, fn] );

%% -------------构建期权组合 -------------------%%

sStructure = Structure;
L = length(m2tkCallinfo.xProps);

for i = 1:L
    sStructure.optInfos(1,i) = m2tkCallinfo.data(1,i);
    sStructure.optInfos(2,i) = m2tkPutinfo.data(1,i);
end

sStructure.num = zeros(2,L);
sStructure.num(1,4:7)  = [-1,2,0,-4];
sStructure.num(2,3:9) =  [ 1, -2, 0, 0, 1, -1, 1];
% 设置到期的ST的值
ST = 2.5;
sStructure.calcPayoff( ST );
sStructure.drawPayoff;

%% ---------------计算50ETF期望payoff---------------------------%%

% 首先设置ST数据
ST = 1.6:0.05:2.8;
% 可以进行向量计算
payOff = sStructure.calcPayoff( ST );
EF = mean( payOff );
str = sprintf( '期权组合的期望payoff为 = %.3f' , EF );
disp( str );


end

