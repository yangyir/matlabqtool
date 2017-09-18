function [ hFig ] = plot_absrela_smitermsurf_oripoint(obj, abs_rela, smitermsurf, oripoint, hFig, varargin)
%Import
% 绝对|相对|绝对相对 smiles|terms|surf 有原始点|无原始点
% abs_rela: absolute relative
% smitermsurf: smiles terms surf
% oripoint: origi原始点 fit拟合点 origifit原始拟合点
% hFig 作图的figure句柄的输入
%DEMO
% qms_.put_surf_.plot_absrela_smitermsurf_oripoint('relative', 'smiles', 'origifit', figure(1), 2)
% qms_.put_surf_.plot_absrela_smitermsurf_oripoint('absolute', 'terms', 'origifit', figure(1))
% qms_.put_surf_.plot_absrela_smitermsurf_oripoint('absolute', 'surf', 'origifit', figure(1))


if ~exist('abs_rela', 'var')
    abs_rela = 'absolute';
end
if ~exist('smitermsurf', 'var')
    smitermsurf = 'smiles';
end
if ~exist('oripoint', 'var')
    oripoint = 'origi';
end
if ~exist('hFig', 'var')
    hFig = figure;
else
    if ishandle(hFig)
    else
        hFig = figure;
    end
end


assert(ismember(abs_rela    , {'absolute', 'relative'}))
assert(ismember(smitermsurf , {'smiles', 'terms', 'surf'}))
assert(ismember(oripoint    , {'origi' , 'fit'  , 'origifit'}))

delete(findobj(hFig, 'type', 'axes'))
ax = axes('Parent', hFig);


%% 1,smiles

if strcmp(smitermsurf, 'smiles')
    % 选择日期
    T = varargin{1};
    
    % 构建零点
    switch abs_rela
        case 'absolute'
            zero_point = 0;
        case 'relative'
            zero_point = obj.smiles_(T).calculate(0);
    end
    
    % 'origi' , 'fit'  , 'origifit'
    switch oripoint
        case 'origi'
            line_.x = obj.smiles_(T).x_value_;
            line_.y = obj.smiles_(T).fun_x_value_;
            lines_ = line_;
        case 'fit'
            x_max_ = max(obj.smiles_(T).x_value_);
            x_min_ = min(obj.smiles_(T).x_value_);
            x_ = x_min_:(x_max_ - x_min_)/60:x_max_;
            line_.x = insert_zero_2_array(x_);
            line_.y = obj.smiles_(T).calculate(line_.x);
            lines_ = line_;
        case 'origifit'
            line_.x = obj.smiles_(T).x_value_;
            line_.y = obj.smiles_(T).fun_x_value_;
            lines_ = line_;
            x_max_ = max(obj.smiles_(T).x_value_);
            x_min_ = min(obj.smiles_(T).x_value_);
            x_ = x_min_:(x_max_ - x_min_)/60:x_max_;
            line_.x = insert_zero_2_array(x_);
            line_.y = obj.smiles_(T).calculate(line_.x);
            lines_(end + 1) = line_;
    end
    
    for t = 1:length(lines_)
        lines_(t).y = lines_(t).y - zero_point;
    end
    
    hold on
    
    fit_str_ = '';
    if ismember(oripoint, {'fit', 'origifit'})
        fit_args_ = obj.smiles_(T).fit_args_;
        levels_ = length(fit_args_);
        for l = 1:levels_
            if l == 1
                fit_str_ = sprintf('%.3f*x^%d', fit_args_(l), levels_ - l);
            else
                fit_str_ = sprintf('%s + %.3f*x^%d', fit_str_, fit_args_(l), levels_ - l);
            end
        end
    end
    
    title_ = sprintf('%dT-%s-%s-%s', T, abs_rela, smitermsurf, oripoint);
    switch oripoint
        case 'origi'
            legend_ = {'original'};
            plot(lines_.x, lines_.y, 'r*-', 'LineWidth', 2, 'MarkerSize', 7)
        case 'fit'
            plot(lines_.x, lines_.y, 'r-' , 'LineWidth', 2)
            legend_ = {fit_str_};
        case 'origifit'
            legend_ = {'original', fit_str_};
            plot(lines_(1).x, lines_(1).y, 'r*-', 'LineWidth', 2, 'MarkerSize', 7)
            plot(lines_(2).x, lines_(2).y, 'm-', 'LineWidth', 2)
    end
   
    
    if strcmp(abs_rela, 'relative')
        xlim_ = get(ax, 'YLim');
        zero_line_ = min(xlim_):(max(xlim_) - min(xlim_))/50:max(xlim_);
        plot(zeros(1, length(zero_line_)), zero_line_, '--')
    end
    
end

%% 2,termstructure

if strcmp(smitermsurf, 'terms')
    
    % 构建零点
    switch abs_rela
        case 'absolute'
            zero_point = 0;
        case 'relative'
            zero_point = obj.termstructure_.fun_x_value_(1);
    end
    
    % 'origi' , 'fit'  , 'origifit'
    switch oripoint
        case 'origi'
            line_.x = obj.termstructure_.x_value_;
            line_.y = obj.termstructure_.fun_x_value_;
            lines_ = line_;
        case 'fit'
            x_max_ = max(obj.termstructure_.x_value_);
            x_min_ = min(obj.termstructure_.x_value_);
            x_ = x_min_:(x_max_ - x_min_)/60:x_max_;
            line_.x = x_;
            line_.y = obj.termstructure_.calculate(line_.x);
            lines_ = line_;
        case 'origifit'
            line_.x = obj.termstructure_.x_value_;
            line_.y = obj.termstructure_.fun_x_value_;
            lines_ = line_;
            x_max_ = max(obj.termstructure_.x_value_);
            x_min_ = min(obj.termstructure_.x_value_);
            x_ = x_min_:(x_max_ - x_min_)/60:x_max_;
            line_.x = x_;
            line_.y = obj.termstructure_.calculate(line_.x);
            lines_(end + 1) = line_;
    end
    
    for t = 1:length(lines_)
        lines_(t).y = lines_(t).y - zero_point;
    end
    
    hold on
    
    fit_str_ = '';
    if ismember(oripoint, {'fit', 'origifit'})
        fit_args_ = obj.termstructure_.fit_args_;
        levels_ = length(fit_args_);
        for l = 1:levels_
            if l == 1
                fit_str_ = sprintf('%.3f*x^%d', fit_args_(l), levels_ - l);
            else
                fit_str_ = sprintf('%s + %.3f*x^%d', fit_str_, fit_args_(l), levels_ - l);
            end
        end
    end
    
    title_ = sprintf('%s-%s-%s', abs_rela, smitermsurf, oripoint);
    switch oripoint
        case 'origi'
            legend_ = {'original'};
            plot(lines_.x, lines_.y, 'r*-', 'LineWidth', 2, 'MarkerSize', 7)
        case 'fit'
            plot(lines_.x, lines_.y, 'r-' , 'LineWidth', 2)
            legend_ = { fit_str_ };
        case 'origifit'
            legend_ = {'original', fit_str_};
            plot(lines_(1).x, lines_(1).y, 'r*-', 'LineWidth', 2, 'MarkerSize', 7)
            plot(lines_(2).x, lines_(2).y, 'm-', 'LineWidth', 2)
    end

    if strcmp(abs_rela, 'relative')
        xlim_ = get(ax, 'XLim');
        zero_line_ = min(xlim_):(max(xlim_) - min(xlim_))/50:max(xlim_);
        plot(zero_line_, zeros(1, length(zero_line_)), '--')
    end
    
end

%% 3, surf 

if strcmp(smitermsurf, 'surf')
    
    len_smiles_ = length(obj.smiles_);
    
    % 构建零点
    switch abs_rela
        case 'absolute'
            zero_point = zeros(len_smiles_, 1);
        case 'relative'
            zero_point = nan(len_smiles_, 1);
            for t = 1:len_smiles_
                zero_point(t) = obj.smiles_(t).calculate(0);
            end
    end
    
    % 'origi' , 'fit'  , 'origifit'
    switch oripoint
        case 'origi'
            for t = 1:len_smiles_
                line_.x = obj.smiles_(t).x_value_;
                line_.y = obj.smiles_(t).fun_x_value_;
                if t == 1
                    lines_ = line_;
                else
                    lines_(end + 1) = line_;
                end
            end
        case 'fit'
            for t = 1:len_smiles_
                x_max_ = max(obj.smiles_(t).x_value_);
                x_min_ = min(obj.smiles_(t).x_value_);
                x_ = x_min_:(x_max_ - x_min_)/50:x_max_;
                line_.x = x_;
                line_.y = obj.smiles_(t).calculate(line_.x);
                line_.y = line_.y - zero_point(t);
                if t == 1
                    lines_ = line_;
                else
                    lines_(end + 1) = line_;
                end
            end
        case 'origifit'
            for t = 1:len_smiles_
                line_.x = obj.smiles_(t).x_value_;
                line_.y = obj.smiles_(t).fun_x_value_;
                line_.y = line_.y - zero_point(t);
                if ~exist('lines_', 'var')
                    lines_ = line_;
                else
                    lines_(end + 1) = line_;
                end
                x_max_ = max(obj.smiles_(t).x_value_);
                x_min_ = min(obj.smiles_(t).x_value_);
                x_ = x_min_:(x_max_ - x_min_)/50:x_max_;
                line_.x = x_;
                line_.y = obj.smiles_(t).calculate(line_.x);
                line_.y = line_.y - zero_point(t);
                lines_(end + 1) = line_;
            end
    end
    
    % 颜色范围
    color_order_setting_ = [...
        1     0     0;...    % 红
        1     0.4   0.4;...  % 淡红
        0.6   0     1;...    % 紫
        0.76  0.47  0.96;... % 淡紫
        0     0.8  0.2;...   % 绿色
        0     1    0.4;...   % 淡绿色
        0     0.2   1;...    % 蓝色
        0.4   0.6   1;...    % 淡蓝色
        1     0.4   0;...    % 橙色
        1     0.66  0;...    % 淡橙
        ];
    hold on;
    title_ = sprintf('%s-%s-%s', abs_rela, smitermsurf, oripoint);
    switch oripoint
        case 'origi'
            legend_ = cell(len_smiles_, 1);
            for t = 1:len_smiles_
                plot(lines_(t).x, lines_(t).y, '*-', 'Color', color_order_setting_(2*t,:), 'LineWidth', 2);
                legend_{t} = sprintf('%dT-original', t);
            end
        case 'fit'
            legend_ = cell(len_smiles_, 1);
            for t = 1:len_smiles_
                plot(lines_(t).x, lines_(t).y, '-', 'Color', color_order_setting_(2*t,:), 'LineWidth', 2);
                legend_{t} = sprintf('%dT-fit', t);
            end
        case 'origifit'
            legend_ = cell(2*len_smiles_, 1);
            for t = 1:len_smiles_
                plot(lines_(2*t-1).x, lines_(2*t-1).y, '*', 'Color', color_order_setting_(2*t-1,:), 'MarkerSize', 8);
                plot(lines_(2*t).x, lines_(2*t).y, '-', 'Color', color_order_setting_(2*t,:), 'LineWidth', 2);
                legend_{2*t-1} = sprintf('%dT-original', t);
                legend_{2*t} = sprintf('%dT-fit', t);
            end
    end
    
    if strcmp(abs_rela, 'relative')
        xlim_ = get(ax, 'YLim');
        zero_line_ = min(xlim_):(max(xlim_) - min(xlim_))/50:max(xlim_);
        plot(zeros(1, length(zero_line_)), zero_line_, '--')
    end
    
end

legend(legend_, 'Location', 'best')
title(title_, 'FontWeight', 'bold')
xlabel('M-shift', 'FontWeight', 'bold')
ylabel('iv', 'FontWeight', 'bold')
set(ax, 'FontWeight', 'bold')
ytick_ = get(ax, 'YTick');
ytick_ = linspace(min(ytick_), max(ytick_), 12);
ytick_str_ = num2cell(ytick_);
ytick_str_ = cellfun(@(x)sprintf('%.4f', x), ytick_str_, 'UniformOutput', false);
set(ax, 'YTick', ytick_, 'YTickLabel', ytick_str_)
if strcmp(smitermsurf, 'terms')
    set(ax, 'XTick', obj.termstructure_.x_value_)
end
grid on;
hold off;


end

% 插入0值
function array_ = insert_zero_2_array(array_)

array_(abs(array_) < 1e-6) = [];
idx = find(array_ >= 0);
if isempty(idx)
    array_ = [0, array_];
else
    less_  = array_(1:idx - 1);
    more_  = array_(idx:end);
    array_ = [less_, 0, more_];
end



end