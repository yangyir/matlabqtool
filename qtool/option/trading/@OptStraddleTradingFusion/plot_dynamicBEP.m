function [hfig, txt] = plot_dynamicBEP(self)

call = self.call;
put  = self.put;
if isempty(call) || isempty(put)
else
    tau_   = call.tau;
    value_ = tau_:-tau_/20:0;
    len_value_ = length(value_);
    left_   = nan(1, len_value_);
    right_  = nan(1, len_value_);
    for t = 1:len_value_
        [ left_(t), right_(t) ] = self.calc_dynamicBEP(value_(t));
    end
    
    t_ = tau_ - value_;
    hfig = figure;
    plot(t_, left_, 'r-')
    hold on
    plot(t_, right_, 'b-')
    plot(t_, left_(end) * ones(1, len_value_), 'g--', 'LineWidth', 2)
    plot(t_, right_(end) * ones(1, len_value_), 'c--', 'LineWidth', 2)
    text(tau_/2, left_(end), sprintf('%.4f', left_(end)), 'FontWeight', 'bold')
    text(tau_/2, right_(end), sprintf('%.4f', right_(end)), 'FontWeight', 'bold')
    hold off
    str_ = sprintf('%s %.3f-call %.3f-put', datestr(call.T,'yyyymm'), call.K, put.K);
    title(str_, 'FontWeight', 'bold')
    xlabel('T', 'FontWeight', 'bold')
    
    % export txt
    txt = sprintf('t\tleft\tright\r');
    for i = 1:len_value_
        txt = sprintf('%s%.3f\t%.4f\t%.4f\r', txt, t_(i), left_(i), right_(i));
    end
    set(gca, 'FontWeight', 'bold')
    grid on;
    
    % …Ë÷√Label
    t_min_ = min(t_);
    t_max_ = max(t_);
    t_tick_ = linspace(t_min_, t_max_, 12);
    year_ = sprintf('%d', year(today));
    trading_days_ = Calendar_Test.GetInstance.trading_days(sprintf('%s-01-01', year_), sprintf('%s-12-30', year_));
    t_tick_str_ = num2cell(t_tick_ * trading_days_);
    t_tick_str_ = cellfun(@(x)sprintf('%.2f',x), t_tick_str_, 'UniformOutput', false);
    set(gca, 'XTick', t_tick_, 'XTickLabel', t_tick_str_)
end







end