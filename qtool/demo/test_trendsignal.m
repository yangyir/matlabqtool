%% 对数据寻找极值点，根据极值点信息给出所有点所在的趋势，趋势量化为[3-(-3)],其中，用到了未来信息

% Zhang,Yan

% load('sPrice.mat');
% data=price;
% 


load('Y:\qdata\IF\intraday_bars_30s_monthly\IF0Y00_201006.mat')


bars = IF0Y00_20100609;
price = bars.close;




%% 生成 target
[trendsig_short]=tgt.trendsignal(price,0.015,0.015,4);
[trendsig_medium]=tgt.trendsignal(price,0.05,0.05,4);
[trendsig_long]=tgt.trendsignal(price,0.09,0.09,4);
trendsig=trendsig_short+trendsig_medium+trendsig_long;



figure(2)


hold all; 
% bars.plot;a
plot(price);
hold on 
bars.plotind(trendsig, '>0');

hold off;



