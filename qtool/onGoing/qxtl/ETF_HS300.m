%% 看ETF和沪深300的跟踪关系




code  = '510300.SH';
etf = DH_Q_HFP_StockSlice('510300.SH','2014-01-01','2014-10-27','ClosePrice',1,1);

code = '000300.SH';
hs300 = DH_Q_HFP_StockSlice('000300.SH','2014-01-01','2014-10-27','ClosePrice',1,1);


code = 'IF0Y00';
if0  = DH_Q_HFP_FutureSlice('IF0Y00.CFE','2014-01-01','2014-10-20','ClosePrice',1)
% 去掉9：30前和15：00后的
tm = if0(:,1);
tm = tm - floor(tm);
if0(tm>15/24,:) = [];
tm = if0(:,1);
tm = tm - floor(tm);
if0(tm<=9.51/24,:) = [];


save('data1.mat', 'etf', 'hs300','if0');

%%
figure(1);hold off
plot(etf(:,2)*1000 );
hold on;
plot(hs300(:,2),'r');
plot(if0(:,2),'g');

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

