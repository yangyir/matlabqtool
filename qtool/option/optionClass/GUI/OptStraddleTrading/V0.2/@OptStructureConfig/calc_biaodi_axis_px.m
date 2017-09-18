function calc_biaodi_axis_px(self, minpx, maxpx, interval)
% 基于当前标的价格计算作图price_level
%curr_biaodi_px->curr_biaodi_axis_px
% 吴云峰 20170330
% 吴云峰 20170416

assert(minpx < maxpx);
curr_biaodi_axis_px = minpx:interval:maxpx;
self.curr_biaodi_axis_px = curr_biaodi_axis_px;





end