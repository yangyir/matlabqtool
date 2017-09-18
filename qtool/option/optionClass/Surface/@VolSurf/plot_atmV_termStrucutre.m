function [ hFig ] = plot_atmV_termStrucutre(obj)
% termstrucutre作图

des = obj.des;
termstructure_ = obj.termstructure_;
% x_value_: [0.033022 0.11533 0.30051 0.54743]
% fun_x_value_: [0.099137 0.10777 0.1122 0.11459]
x_value_     = termstructure_.x_value_;


% 进行插值
min_x_ = min(x_value_);
max_x_ = max(x_value_);
gap_ = (max_x_ - min_x_)/50;
x_ = min_x_:gap_:max_x_;
value_ = termstructure_.calculate(x_);


hFig = figure;
ax = axes;
plot(x_, value_, 'r*-')
title(ax, [des, ' Term Structure'], 'FontWeight', 'bold')
set(ax, 'FontWeight', 'bold')
xlabel(ax, 'tau', 'FontWeight', 'bold')
ylabel(ax, 'atmImpvol', 'FontWeight', 'bold')
grid on




end