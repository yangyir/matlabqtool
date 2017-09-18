function calc_biaodi_axis_px(self)
% ���ڵ�ǰ��ļ۸������ͼprice_level
%curr_biaodi_px->curr_biaodi_axis_px
% ���Ʒ� 20170330


% ���㵱ǰ��ļ۸�
curr_biaodi_px = self.curr_biaodi_px;
if isnan(curr_biaodi_px)
    return;
end
base_px = 1:0.05:4;

more_idx  = find(curr_biaodi_px >= base_px);
small_idx = find(curr_biaodi_px < base_px);
more_nearest_idx  = more_idx(end);
small_nearest_idx = small_idx(1);


% �������е���
curr_biaodi_axis_px = [base_px(more_nearest_idx-5:more_nearest_idx), ...
    base_px(small_nearest_idx:small_nearest_idx+4)];
self.curr_biaodi_axis_px = curr_biaodi_axis_px;






end