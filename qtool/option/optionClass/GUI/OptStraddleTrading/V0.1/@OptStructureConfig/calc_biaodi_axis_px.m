function calc_biaodi_axis_px(self)
% 基于当前标的价格计算作图price_level
%curr_biaodi_px->curr_biaodi_axis_px
% 吴云峰 20170330


% 计算当前标的价格
curr_biaodi_px = self.curr_biaodi_px;
if isnan(curr_biaodi_px)
    return;
end
base_px = 1:0.05:4;

more_idx  = find(curr_biaodi_px >= base_px);
small_idx = find(curr_biaodi_px < base_px);
more_nearest_idx  = more_idx(end);
small_nearest_idx = small_idx(1);


% 可以自行调整
curr_biaodi_axis_px = [base_px(more_nearest_idx-5:more_nearest_idx), ...
    base_px(small_nearest_idx:small_nearest_idx+4)];
self.curr_biaodi_axis_px = curr_biaodi_axis_px;






end