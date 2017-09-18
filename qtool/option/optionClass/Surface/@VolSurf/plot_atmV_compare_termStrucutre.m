function [ hFig ] = plot_atmV_compare_termStrucutre(obj, type, varargin)
% 基于比较的termStructure对比作图
%Import
% type 比较类型 pre mean own
% varargin 其他输入变量


assert(ismember(type, {'pre', 'mean', 'own'}))

% 使用昨值
if strcmp(type, 'pre')
    hFig = figure;
    ax = axes;
    % 获取昨值surf
    pre_surf = varargin{1};
    
    % 当前的Term Structure
    des = obj.des;
    termstructure_ = obj.termstructure_;
    x_value_ = termstructure_.x_value_;
    min_x_ = min(x_value_);
    max_x_ = max(x_value_);
    gap_   = (max_x_ - min_x_)/50;
    x_ = min_x_:gap_:max_x_;
    value_ = termstructure_.calculate(x_);

    plot(x_, value_, 'b*-')
    
    % 昨日的Term Structure
    termstructure_ = pre_surf.termstructure_;
    x_value_ = termstructure_.x_value_;
    min_x_ = min(x_value_);
    max_x_ = max(x_value_);
    gap_   = (max_x_ - min_x_)/50;
    x_ = min_x_:gap_:max_x_;
    value_ = termstructure_.calculate(x_);
    
    hold on
    plot(x_, value_, 'r*-')
    
    title(ax, [des, ' Term Structure Compare'], 'FontWeight', 'bold')
    legend({'now';'pre'}, 'Location', 'best')
    set(ax, 'FontWeight', 'bold')
    xlabel(ax, 'tau', 'FontWeight', 'bold')
    ylabel(ax, 'atmImpvol', 'FontWeight', 'bold')
    grid on;
elseif strcmp(type, 'mean')
    
else
    
end


end