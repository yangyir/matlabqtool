function [ ] = plot_quote_surface(obj, z_val_fieldname, plot_type)
% only QuoteOpt
% plot_type:  K_Z / T_Z
%Import
% z_val_fieldname : impvol, delta, gamma, theta, vega, last.etc
% plot_type : K_Z , T_Z , 3D
%Export
% 图形句柄
% wuyunfeng 20170612

if ~exist('plot_type', 'var')
    plot_type = 'K_Z';
end
if ~exist('z_val_fieldname', 'var')
    z_val_fieldname = 'impvol';
end
assert(ismember(plot_type, {'K_Z', 'T_Z', '3D'}));

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

% 剔除非标准合约
pre_dividend_flags = false(nT, nK);
plot_data = nan(nT, nK);
for t = 1:nT
    for k = 1:nK
        if strcmp(z_val_fieldname, 'vega/theta')
            val = data(t, k).('vega')/data(t, k).('theta');
        else
            val = data(t, k).(z_val_fieldname);
        end
        if isempty(val)
            val = nan;
        end
        plot_data(t, k) = val;
        pre_dividend_flags(t, k) = data(t, k).is_pre_dividend;
    end
end
remove_idx = sum(pre_dividend_flags, 1) > 0;
xProps(remove_idx)       = [];
plot_data(:, remove_idx) = [];

% 作图
% 2D
if strcmp(plot_type, 'K_Z')
    
    plot_data = plot_data';
    strike_   = xProps';
    strike_   = repmat(strike_, 1, nT);
    % 作图
    plot(strike_, plot_data, '*-', 'LineWidth', 2);
    grid on;
    legend(yProps, 'Location', 'best')
    set(gca, 'FontWeight', 'bold')
    title(des2, 'FontWeight', 'bold')
    xlabel('K', 'FontWeight', 'bold')
    ylabel(z_val_fieldname, 'FontWeight', 'bold')
    
elseif strcmp(plot_type, 'T_Z')
    
    % 一条线一条线的画
    color_order_ = [...
        0.8 0 1;...
        1 0 0;...
        0.2 0.8 0;...
        0 1 1;...
        0 0 1;...
        1 0.4 0;...
        0.6 0 0.2;...
        0.6 0.6 0;...
        0.6 0.4 1;...
        ];
    color_order_len_ = size(color_order_, 1);
    
    x_ = (1:nT)';
    nK = length(xProps);
    x_ = repmat(x_, 1, nK);
    legend_ = num2cell(xProps);
    legend_ = cellfun(@num2str, legend_, 'UniformOutput', false);
    % 作图
    hold on;
    for k = 1:nK
        xk_    = x_(:, k);
        value_ = plot_data(:, k);
        nanidx_ = isnan(value_);
        xk_(nanidx_)    = [];
        value_(nanidx_) = [];
        plot(xk_, value_, '*-', 'LineWidth', 2, 'Color', color_order_(mod(k, color_order_len_)+1, :));
    end
    hold off;
    grid on;
    legend(legend_, 'Location', 'best')
    set(gca, 'XTick', 1:nT, 'FontWeight', 'bold', 'XTickLabel', yProps)
    title(des2, 'FontWeight', 'bold')
    xlabel('T', 'FontWeight', 'bold')
    ylabel(z_val_fieldname, 'FontWeight', 'bold')
    
else
    
    % 3D
    [mesh_T, mesh_Strike] = meshgrid(1:nT, xProps);
    plot_data = plot_data';
    handle_   = surf(mesh_Strike, mesh_T, plot_data);
    hold on;
    
    set(handle_, 'LineWidth', 1, 'Marker', '*', 'MarkerSize', 3)
    ylabel('T', 'FontWeight', 'bold');
    xlabel('K', 'FontWeight', 'bold');
    zlabel(z_val_fieldname, 'FontWeight', 'bold');
    
    title(des2, 'FontWeight', 'bold');
    set(gca, 'YTick', 1:nT, 'FontWeight', 'bold', 'YTickLabel', yProps)
    hold off;
    
end







end