%% run heding backtest
clear all;
error = [];
vol = [0.2:0.05:0.6];
for i = 1:length(vol)
    i
h1.vol = vol(i);    
h1 = deltahedging_backtest;

h1.init_etf50settings();
h1.total_val = 1000000;  
h1.invest_frac = 0.6;


% ����������Ȩ�۸�������
h1.cal_theo_price();
h1.cal_theo_option_pnl();

%% �ȼ�� delta�Գ� 


h1.hedge_time_interval = 240; % ���X���ӵ���delta��XΪԭʼ������Сʱ�����ı���
h1.update_deltaseq();
h1.deltahedging_holdingseq_et();

h1.cal_hedging_pnl();
error(i,:) = h1.hedging_cpnl -h1.theo_option_cpnl;
h1.comparison_plot();
hold on
% h1.hedging_cpnl(end)

end








