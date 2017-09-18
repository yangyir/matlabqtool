function [ ] = demo(  )
%DEMO 
% 干的事情是：
% 从excel中初始化当日所有期权信息
% 然后，建立一个structure，算payoff，画图
% ---------------------------
% 程刚，20160124

%% -------------------------------清空一下------------------------%%
% clc; clear all; rehash;
% close all

format compact

%% -------------------------------初始化-----------------------------%%

path = 'T:\intern\optionClass\ @OptInfo\';       % 根据情况修改
fn = 'OptInfo.xlsx';                            % 根据情况修改
[ ~, m2tkCallinfo, m2tkPutinfo ] = OptInfo.init_from_sse_excel( [path, fn] );

%% -------------构建期权组合 -------------------%%

s = Structure;
L = length(m2tkCallinfo.xProps);

% 取所有T相同的合约出来， 是否取成2维的

for i = 1:L
    s.optInfos(1,i) = m2tkCallinfo.data(1,i);
    s.optInfos(2,i) = m2tkPutinfo.data(1,i);
end

s.num = zeros(2,L);
s.num(1,4:7)  = [-1,2,0,-4];
s.num(2,3:9) =  [ 1, -2, 0, 0, 1, -1, 1];
ST = 2.5;
s.calcPayoff( ST );
s.drawPayoff;

%% ---------------计算50ETF期望payoff---------------------------%%

% 首先设置ST数据
ST = 1.6:0.05:2.8;
% 可以进行向量计算
payOff = s.calcPayoff( ST );
EF = mean( payOff );
str = sprintf( '期权组合的期望payoff为 = %.3f' , EF );
disp( str );

end

