function [ ] = plot_quote_surf_tau_m(obj, z_val_fieldname, plot_type, m_type)
% only QuoteOpt
%Import
% z_val_fieldname : impvol, delta, gamma, theta, vega.etc
% plot_type : m_Z , tau_Z , 3D
% m_type : M, M_tau, M_shift, Z
%Export
% 图形句柄
% wuyunfeng 20170615

if ~exist('z_val_fieldname', 'var')
    z_val_fieldname = 'impvol';
end
if ~exist('plot_type', 'var')
    plot_type = 'm_Z';
end
if ~exist('m_type', 'var')
    m_type = 'M_shift';
end
assert(ismember(plot_type, {'m_Z', 'tau_Z', '3D'}));
assert(ismember(m_type, {'M', 'M_tau', 'M_shift', 'Z'}))


% 判断数据是否是QuoteOpt
if isa(obj.data, 'QuoteOpt')
else
    error('数据类型不是QuqoteOpt')
end


data   = obj.data;
des2   = obj.des2;
yProps = obj.yProps;
xProps = obj.xProps;
nT     = length(yProps);
nK     = length(xProps);

% 剔除非标准合约并且获得数据
pre_dividend_flags = false(nT, nK);
z_property_data    = nan(nT, nK);
m_data   = nan(nT, nK);
tau_data = nan(nT, nK);
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
        z_property_data(t, k) = val;
        pre_dividend_flags(t, k) = data(t, k).is_pre_dividend;
        if data(t, k).is_obj_valid
            tau_data(t, k) = data(t, k).('tau');
            m_data(t, k)   = data(t, k).(m_type);
        else
            tau_data(t, k) = nan;
            m_data(t, k)   = nan;
        end
    end
end
remove_idx = sum(pre_dividend_flags, 1) > 0;
z_property_data(:, remove_idx) = [];
tau_data(:, remove_idx) = [];
m_data(:, remove_idx)   = [];
xProps(remove_idx)      = [];

% legend str
legend_tau_ = sort(unique(tau_data(:)));
legend_tau_(isnan(legend_tau_)) = [];
legend_tau_str_ = num2cell(legend_tau_);
legend_tau_str_ = cellfun(@(x)sprintf('%.4f', x), legend_tau_str_, 'UniformOutput', false);


% 进行作图
if strcmp(plot_type, 'm_Z')
    
    z_property_data = z_property_data';
    m_data          = m_data';
    
    % plot
    plot(m_data, z_property_data, '*-', 'LineWidth', 2);
    grid on;
    
    % legend
    legend(legend_tau_str_, 'Location', 'best')
    
    % other settings 
    set(gca, 'FontWeight', 'bold')
    title(des2, 'FontWeight', 'bold')
    m_type(m_type == '_') = '-';
    xlabel(m_type, 'FontWeight', 'bold')
    ylabel(z_val_fieldname, 'FontWeight', 'bold')
    
elseif strcmp(plot_type, 'tau_Z')
    
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
    nK = size(m_data, 2);
    x_ = repmat(x_, 1, nK);
    legend_ = num2cell(xProps);
    legend_ = cellfun(@num2str, legend_, 'UniformOutput', false);
    % 作图
    hold on;
    for k = 1:nK
        xk_    = x_(:, k);
        value_  = z_property_data(:, k);
        nanidx_ = isnan(value_);
        xk_(nanidx_)    = [];
        value_(nanidx_) = [];
        plot(xk_, value_, '*-', 'LineWidth', 2, 'Color', color_order_(mod(k, color_order_len_)+1, :));
    end
    hold off;
    grid on;
    legend(legend_, 'Location', 'best')
    set(gca, 'XTick', 1:nT, 'FontWeight', 'bold', 'XTickLabel', legend_tau_str_)
    title(des2, 'FontWeight', 'bold')
    xlabel('tau', 'FontWeight', 'bold')
    ylabel(z_val_fieldname, 'FontWeight', 'bold')
    
else
   
    % 3D
    nK = size(m_data, 2);
    [ mesh_T ] = meshgrid(1:nT, 1:nK);
    z_property_data = z_property_data';
    handle_   = surf(m_data', mesh_T, z_property_data);
    hold on;
    
    set(handle_, 'LineWidth', 1, 'Marker', '*', 'MarkerSize', 3)
    ylabel('tau', 'FontWeight', 'bold');
    m_type(m_type == '_') = '-';
    xlabel(m_type, 'FontWeight', 'bold');
    zlabel(z_val_fieldname, 'FontWeight', 'bold');
    
    title(des2, 'FontWeight', 'bold');
    set(gca, 'YTick', 1:nT, 'FontWeight', 'bold', 'YTickLabel', legend_tau_str_)
    hold off;
    
end











end