function payoff_pointer_callback(hObject, eventdata, optstruct)
% 期权payoff的作图回调函数
% 吴云峰 20170331


axes_handle = optstruct.axes_handle;
delete(findobj(axes_handle,'Tag','text_payoff_info'))
if isempty(optstruct.s)
    return;
end

%  获取当前的Axes的坐标
pos  = get( axes_handle , 'CurrentPoint');
xPos = pos( 1 );
yPos = pos( 3 );
xLim = xlim( axes_handle );
yLim = ylim( axes_handle );
max_Xlim = max( xLim );
min_Xlim = min( xLim );
max_YLim = max( yLim );
min_YLim = min( yLim );
if xPos >= max_Xlim || xPos <= min_Xlim,return;end;
if yPos >= max_YLim || yPos <= min_YLim,return;end;

% 计算payoff和年化收益率
payoff                 = optstruct.calc_structure_payoff(xPos);
recently_residual_days = optstruct.recently_residual_days;
curr_portfolio_cost    = optstruct.curr_portfolio_cost;
payoff_return_ = payoff/curr_portfolio_cost;
payoff_return_ = payoff_return_/(recently_residual_days/365);
str_ = cell( 8 , 1 );
str_{ 1 } = sprintf( '  S=%.3f' , xPos );
str_{ 2 } = sprintf( '  Payoff=%.3f' , payoff );
str_{ 3 } = sprintf( '  Year Yield=%.2f%%' , payoff_return_*100 );

text(xPos * 0.985,yPos,str_,...
    'Parent' , axes_handle,...
    'VerticalAlignment','baseline',...
    'FontSize',9,...
    'FontWeight' , 'bold',...
    'Color','b',...
    'Tag','text_payoff_info');






end