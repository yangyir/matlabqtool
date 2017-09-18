function calc_plot_payoff(self, minpx, maxpx, interval, port_balance)
% ¼ÆËã»­Í¼µÄº¯Êý
% ÎâÔÆ·å 20170331

axes_handle = self.axes_handle;
if ishandle(axes_handle)
else
    axes_handle = axes;
    self.axes_handle;
end
cla(axes_handle, 'reset')

% ¼ÆËã
self.calc_selection_to_structure;
if isempty(self.s)
    return;
end
self.calc_recently_residual_days;
self.calc_structure_base_info;
self.calc_biaodi_axis_px(minpx, maxpx, interval);

if exist('port_balance', 'var')
    self.curr_portfolio_balance = port_balance;
end

payoff = self.calc_structure_payoff;
px     = self.calc_structure_px;
curr_payoff         = self.calc_structure_payoff(self.curr_biaodi_px);
curr_biaodi_axis_px = self.curr_biaodi_axis_px ;

% ×÷Í¼
axes(axes_handle)
plot( curr_biaodi_axis_px , payoff , 'r-*' , 'LineWidth' , 2 )
set( axes_handle , 'XTick' , curr_biaodi_axis_px )
hold on
plot( curr_biaodi_axis_px , zeros( 1 , length( curr_biaodi_axis_px ) ) , 'b--' , 'LineWidth' , 1 )
plot( self.curr_biaodi_px , curr_payoff , 'go' , 'MarkerFaceColor' , 'g' , 'MarkerSize' , 8 )
xlabel('ST','FontSize',9,'FontWeight','bold')
set( axes_handle , 'FontWeight' , 'bold' , 'FontSize' , 9 )
plot( curr_biaodi_axis_px , px , 'm-*' , 'LineWidth' , 2 )
disp_y_val = payoff;
disp_y_val = unique( disp_y_val );
disp_y_val = sort( disp_y_val );
set( axes_handle , 'YTick' , disp_y_val )
legend( 'payoff' ,'0--', 'curr','px' , 'Location' , 'best' )
grid on;
hold off









end