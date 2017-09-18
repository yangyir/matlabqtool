function [ ] = demo2()
%DEMO2 此处显示有关此函数的摘要
%此处显示详细说明

%% TODO

clear all; 
format compact
format short g
rehash;

pricer(1:3) = OptPricer;
K = [1.8,2.3,2.5];
figure
hold on
for i = 1:3
    
    pricer(i).fillOptInfo(1000000, '自制期权', 510050, datenum('2016-03-15'), K(i), 'call')
    pricer(i).currentDate = today;
    pricer(i).calcTau;
    pricer(i).S = [1.7:0.02:2.5];
    pricer(i).sigma = 0.3;
    pricer(i).calcPx() ;
    pricer(i).calcDelta() ;
    subplot(3,1,i)
    plot(pricer(i).S,pricer(i).delta)
    title(['K = ',num2str( K(i) ),'的Delta对S的作图'])
    xlabel('S')
    ylabel('delta')
    
end

% 进行画图，可以使用subplot


end

