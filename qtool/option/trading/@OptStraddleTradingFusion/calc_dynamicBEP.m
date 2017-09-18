function [left_, right_] = calc_dynamicBEP(self, tau_)
% 计算动态的BEP函数
%输出
% 左BEP和右BEP

left_  = nan;
right_ = nan;
call = self.call;
put  = self.put;
if isempty(call) || isempty(put)
else
    if ~exist('tau_', 'var')
        tau_ = call.tau;
    end
    [left_init_, right_init_] = self.calc_payoffBEP;
    
    % 计算的函数句柄
    cost = call.last + put.last;
    fcn_ = @(x)OptStraddleTradingFusion.break_event_point_fcn(x, tau_, call, put, cost);
    
    option_config_ = optimset;
    option_config_.TolCon = 1e-6;
    option_config_.TolFun = 1e-6;
    option_config_.TolX   = 1e-6;
    option_config_.MaxIter = 200;
    option_config_.Display = 'off';
    left_  = fsolve(fcn_, left_init_, option_config_);
    right_ = fsolve(fcn_, right_init_, option_config_); 
    
end




end