%% ������Ѱ�Ҽ�ֵ�㣬���ݼ�ֵ����Ϣ�������е����ڵ����ƣ���������Ϊ[3-(-3)],���У��õ���δ����Ϣ

% Zhang,Yan

% load('sPrice.mat');
% data=price;
% 


load('Y:\qdata\IF\intraday_bars_30s_monthly\IF0Y00_201006.mat')


bars = IF0Y00_20100609;
price = bars.close;




%% ���� target
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



