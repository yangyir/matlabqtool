function calc_biaodi_axis_px(self, minpx, maxpx, interval)
% ���ڵ�ǰ��ļ۸������ͼprice_level
%curr_biaodi_px->curr_biaodi_axis_px
% ���Ʒ� 20170330
% ���Ʒ� 20170416

assert(minpx < maxpx);
curr_biaodi_axis_px = minpx:interval:maxpx;
self.curr_biaodi_axis_px = curr_biaodi_axis_px;





end