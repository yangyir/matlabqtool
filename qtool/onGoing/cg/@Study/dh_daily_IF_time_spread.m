function [] = dh_daily_IF_time_spread(inear, ifar)
% dh_daily_IF_time_spread 计算每日的跨期套利差
% 利用DH取数据
% 程刚; 140617

%%
if ~exist('inear', 'var'), inear = 3; end
if ~exist('ifar', 'var'),   ifar = 4; end
 
%% 数据
tdayStr     = datestr(today,'yyyy-mm-dd');
datesStr    = DH_D_TR_MarketTradingday(3,'2010-04-16',tdayStr);

% 当日17点前，还没有当日的数据，会出错
if hour(now) < 17
    datesStr    = datesStr(1:end-1,:);
end

df.today       = datenum(datesStr);
df.todayStr    = datesStr;

ifClose         = nan(size(datesStr,1), 4);
ifClose(:,1)    = DH_Q_DQ_Future('IF0Y00',datesStr,'Close');
ifClose(:,2)    = DH_Q_DQ_Future('IF0Y01',datesStr,'Close');
ifClose(:,3)    = DH_Q_DQ_Future('IF0Y02',datesStr,'Close');
ifClose(:,4)    = DH_Q_DQ_Future('IF0Y03',datesStr,'Close');

code        = DH_E_FS_IF_ContiContr({'IF0Y00','IF0Y01','IF0Y02','IF0Y03'},datesStr);

df.stlDate       = nan( size(datesStr,1), 4);
df.stlDate(:,1)  = datenum( DH_D_F_FLastDay(code(1,:)) );
df.stlDate(:,2)  = datenum( DH_D_F_FLastDay(code(2,:)) );
df.stlDate(:,3)  = datenum( DH_D_F_FLastDay(code(3,:)) );
df.stlDate(:,4)  = datenum( DH_D_F_FLastDay(code(4,:)) );


%% 算 discount factors
% 参数
RFR = 0.044;

df.remDays  = df.stlDate - df.today * ones(1,4);
df.rfr      = RFR * ones(length(df.today), 1);
df.rfr(end-150:end) = 0.03;
df.value    = exp( df.remDays .* (df.rfr*ones(1,4)) / 360 );

% ifStl       = DH_Q_DQ_Future(code,tdayStr,'Settle');
% spotClose   = DH_Q_DQ_Index('000300.SH',datesStr,'Close');

%% 算 spread
 
% inear   = 3
% ifar    = 4
theo_sp = ifClose(:,inear) .* ( df.value(:, inear) - df.value(:, ifar) ) ./ df.value(:, inear) ; 
real_sp = ifClose(:,inear) - ifClose(:,ifar);


figure(201); hold off
plot(real_sp, 'b');
hold on;
plot(theo_sp, 'r');
legend('real', 'theoritical');
title(sprintf('Til %s: Spread between IF0Y0%d and IF0Y0%d', datesStr(end,:), inear-1, ifar-1));


figure(202); hold off
bar(real_sp - theo_sp);
title(sprintf('Til %s: Spread between IF0Y0%d and IF0Y0%d', datesStr(end,:), inear-1, ifar-1));

mean( real_sp - theo_sp)

figure(203); hold off;
plot(ifClose(:,inear), 'r');
hold on;
plot(ifClose(:,ifar), 'b');
legend('near', 'far');
title(sprintf('Til %s: Spread between IF0Y0%d and IF0Y0%d', datesStr(end,:), inear-1, ifar-1));


figure(204);
iplot.value_hist(real_sp-theo_sp);


%% spread和IF似乎相关性高
time    = 1:size(ifClose, 1);
line1   = theo_sp - real_sp;
line2   = ifClose(:,1);
cor12   = corr(line1, line2);

figure(206); hold off
plotyy(time, line1, time, line2);
hold on;
legend('theo-real', 'IF');
title(sprintf('corr = %0.3f', cor12));

end