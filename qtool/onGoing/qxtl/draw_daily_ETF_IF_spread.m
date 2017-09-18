%% 作图

sdt = '2014-10-20';
edt = '2014-11-3';

DH;



code  = '510300.SH';
etf = DH_Q_HFP_StockSlice('510300.SH',sdt,edt,'ClosePrice',1,1);


code = '000300.SH';
hs300 = DH_Q_HFP_StockSlice('000300.SH',sdt,edt,'ClosePrice',1,1);


code = 'IF0Y00';
if0  = DH_Q_HFP_FutureSlice('IF0Y00.CFE',sdt,edt,'ClosePrice',1)
% 去掉9：30前和15：00后的
tm = if0(:,1);
tm = tm - floor(tm);
if0(tm>15/24,:) = [];
tm = if0(:,1);
tm = tm - floor(tm);
if0(tm<=9.51/24,:) = [];

%% 作图
figure(1);hold off
plot(etf(:,2)*1000 );
hold on;
plot(hs300(:,2),'r');
plot(if0(:,2),'g');
legend('ETF', '沪深300', 'IF0');
title(sprintf('原始值, %s:%s',sdt,edt));


figure(2);hold off
sp = etf(:,2)*1000-hs300(:,2);
plot(sp);
hold on;
len = size(if0,1);
sp2 = if0(:,2) - etf(1:len,2)*1000;
sp2 = -sp2;
plot(sp2,'r');
grid on
legend('etf-hs300','etf-if0')
title(sprintf('%s:%s期现差, std=%0.2f',sdt,edt,std(sp)));

figure(3);hold off;
sp3 = if0(:,2)-hs300(:,2);
plot(sp3);
hold on;
len = size(if0,1);
sp4 = if0(:,2) - etf(1:len,2)*1000;
sp4 = sp4 + mean(sp);
plot(sp4,'r');
grid on
legend('if0-hs300','if0-etf')
title(sprintf('%s:%s期现差, std=%0.2f, %0.2f',sdt,edt,std(sp3),std(sp4)));


figure(4); hold off
plot(sp3);
hold on
grid on
legend('if0-hs300');
title(sprintf('%s:%s期现差, std=%0.2f',sdt,edt,std(sp3)));




