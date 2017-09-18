%% run hedging error study

% 1 验证如下结论
% If the market is range bound, hedging a short option
% position at a lower vol. hurts, and we need to use large vol.
% If the market is trending, hedging a short option
% position at a higher vol. hurts, and we need to use small vol.


% 以上结论仅验证对 ATM call 成立
% 对 deep ITM  不成立

%% ATM Call
h1 = hedging_error;
h1.option_type = 'call';
h1.data_type = 'Down_Trend';
h1.K = 2.0;     % ATM call
h1.gen_data();
h1.cal_delta();
h1.cal_cpnl();
% if 'WN, high vol gives better result than low vol
% if 'Trend', high vol gives worse result than low vol
figure() 
hold on
plot(h1.deltalow_cpnl,'r')
plot(h1.deltahigh_cpnl,'b')
legend('low vol','high vol')
hold off

h1.cal_theo_price();
h1.c0_path(1)



%% ATM Put
h1 = hedging_error;
h1.option_type = 'put';
h1.data_type = 'Down_Trend';
h1.K = 2.0;     % ATM call
h1.gen_data();
plot(h1.S_path)
h1.cal_delta();
h1.cal_cpnl();
% if 'WN, high vol gives better result than low vol
% if 'Trend', high vol gives worse result than low vol
figure() 
hold on
plot(h1.deltalow_cpnl,'r')
plot(h1.deltahigh_cpnl,'b')
legend('low vol','high vol')
hold off



%% ITM, OTM options
h1 = hedging_error;
h1.K = 1.8;     % ITM OTM call
h1.len = 100;
h1.data_type = 'Down_Trend';
h1.gen_data();

h1.option_type = 'put';
h1.cal_delta();
h1.cal_cpnl();
% if 'WN, high vol gives better result than low vol
% if 'Trend', high vol gives worse result than low vol
figure() 
hold on
plot(h1.deltalow_cpnl,'r')
plot(h1.deltahigh_cpnl,'b')
legend('low vol','high vol')
title('call')
hold off

%plot(h1.S_path)

h1.option_type = 'put';
h1.cal_delta();
h1.cal_cpnl();
% if 'WN, high vol gives better result than low vol
% if 'Trend', high vol gives worse result than low vol
figure() 
hold on
plot(h1.deltalow_cpnl,'r')
plot(h1.deltahigh_cpnl,'b')
legend('low vol','high vol')
title('put')
hold off



%% 2 验证hedging error spread

% hedging pnl seems better than the theoretical high option price path

% most case it is true, except for deep ITM put

%% high path
h1 = hedging_error;
h1.option_type = 'put';
h1.data_type = 'BM';
h1.K = 2.0;     % ATM call
h1.gen_data();
h1.cal_delta();
h1.cal_theo_price();
h1.cal_cpnl();

figure() 
hold on
plot(h1.c_high_path - h1.c_high_path(1),'r')
plot(h1.deltahigh_cpnl,'b')
legend('high vol path','high vol hedging pnl')
hold off

%% c0 path
h1 = hedging_error;
h1.option_type = 'put';
h1.data_type = 'BM';
h1.K = 2.5;     % ATM call
h1.gen_data();
h1.cal_delta();
h1.cal_theo_price();
h1.cal_cpnl();

figure() 
hold on
plot(h1.c0_path,'r')
plot(h1.deltahigh_cpnl + h1.c_high_path(1),'b')
legend('high vol path','high vol hedging pnl')
hold off

figure() 
hold on
plot(h1.c0_path,'r')
plot(h1.deltalow_cpnl + h1.c_high_path(1),'b')
legend('high vol path','high vol hedging pnl')
hold off

%% verify the second conclusion
% most case it is true, except for deep ITM put

for j = 1:20
h1 = hedging_error;
h1.option_type = 'call';
h1.data_type = 'BM';
h1.K = 1.4;     % ATM call
h1.gen_data();
h1.cal_delta();
h1.cal_theo_price();
h1.cal_cpnl();

h1.deltahigh_cpnl(end) + h1.c_high_path(1)-h1.c0_path(end)


end





