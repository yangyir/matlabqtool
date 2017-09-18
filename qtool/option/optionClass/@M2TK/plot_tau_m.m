function [ ] = plot_tau_m(obj)
% tau m作图

% 判断数据是否是QuoteOpt
if isa(obj.data, 'QuoteOpt')
else
    error('数据类型不是QuqoteOpt')
end

data = obj.data;
des2 = obj.des2;
yProps = obj.yProps;
xProps = obj.xProps;
nT   = length(yProps);
nK   = length(xProps);


% 获取数据
pre_dividend_flags = false(nT, nK); % 去除分红前的合约
null_opt_flags     = false(nT, nK); % 非合约的位置
M_Opt_data    = nan(nT, nK);
tao_Opt_data  = nan(nT, nK);
MHat_Opt_data = nan(nT, nK);
for t = 1:nT
    for k = 1:nK
        if data(t, k).is_obj_valid
            % M
            val = data(t, k).('M');
            if isempty(val),
                val = nan;
            end
            M_Opt_data(t, k) = val;
            % tau
            val = data(t, k).('tau');
            if isempty(val),
                val = nan;
            end
            tao_Opt_data(t, k) = val;
            % MHat
            val = data(t, k).('M_shift');
            if isempty(val),
                val = nan;
            end
            MHat_Opt_data(t, k) = val;
            sClose = data(t, k).S;
        else
            M_Opt_data(t, k)    = nan;
            tao_Opt_data(t, k)  = nan;
            MHat_Opt_data(t, k) = nan;
            null_opt_flags(t, k) = true;
        end
        pre_dividend_flags(t, k) = data(t, k).is_pre_dividend;
    end
end
remove_idx = sum(pre_dividend_flags, 1) > 0;
xProps(remove_idx) = [];
M_Opt_data(:, remove_idx)    = [];
tao_Opt_data(:, remove_idx)  = [];
MHat_Opt_data(:, remove_idx) = [];
null_opt_flags(:, remove_idx) = [];
M_Opt_data    = M_Opt_data';
tao_Opt_data  = tao_Opt_data';
MHat_Opt_data = MHat_Opt_data';
null_opt_flags = null_opt_flags';
null_opt_flags = null_opt_flags(:);
M_Opt    = M_Opt_data(:);
tao_Opt  = tao_Opt_data(:);
MHat_Opt = MHat_Opt_data(:);
% 去除非合约的位置
M_Opt(null_opt_flags)    = [];
tao_Opt(null_opt_flags)  = [];
MHat_Opt(null_opt_flags) = [];

%% iso M_hat

subplot(1, 2, 1);

plot(M_Opt, tao_Opt, 'r.','MarkerSize', 5);
MHat_scale = (linspace(min(MHat_Opt),max(MHat_Opt),8))';
taoScale = linspace(0,max(tao_Opt)*1.2,100);

isoLine = MHat_scale*sqrt(taoScale);

for i = 1:length(MHat_scale)
    hold on;
    plot(isoLine(i,:),taoScale);
end

xlabel('ln(K/S)');
ylabel('tao');
title(sprintf('%s isoMHat', des2));
legend('M','iso MHat','location','best');
hold off

%% iso K
subplot(1, 2, 2);
plot(MHat_Opt, tao_Opt,'r.','MarkerSize', 5);
K_scale  = (min(xProps):0.05:max(xProps))';
taoScale = linspace(0.05,max(tao_Opt)*1.2,100);
isoLine  = log(K_scale./sClose(1))*(ones(1,length(taoScale))./sqrt(taoScale));

for i = 1:length(K_scale)
    hold on;
    plot(isoLine(i,:),taoScale);
end

xlabel('MHat');
ylabel('tao');
title(sprintf('%s isoK', des2));
legend('MHat','iso K','location','best');
hold off







end