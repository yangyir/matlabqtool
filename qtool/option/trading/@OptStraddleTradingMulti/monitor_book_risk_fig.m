function monitor_book_risk_fig( obj, S_low, S_high)
% multi book的总体监控与fig输出
% monitor_book_risk_fig( obj, S_low, S_high, h_parent )


nCount = obj.optstraddletrading_multi.Count;
if nCount == 0
    return;
end
if ~exist('S_low', 'var')
    S_low = 2.15;
end
if ~exist('S_high', 'var')
    S_high = 2.5;
end


% 1,分别各自Book的作图
keys_value = obj.keys;
for straddle_t = 1:nCount
    stra_title = keys_value{straddle_t};
    optstratrade_object = get(obj, stra_title);
    h_fig = figure(533 + straddle_t - 1);
    set(h_fig, 'Menubar', 'none', 'ToolBar', 'figure', ...
        'NumberTitle', 'off', 'Name', stra_title)
    optstratrade_object.monitor_book_risk_fig(S_low, S_high, h_fig);
    uicontrol('Parent', h_fig, 'Style', 'text', ...
        'String', stra_title, 'FontSize', 9, ...
        'FontWeight', 'bold', 'Units', 'Normalized', ...
        'Position', [0.005 0.94 0.08 0.05], 'BackgroundColor', 'k', ...
        'ForegroundColor', 'r')
end



% 2,整体Book的作图
optstratrade_object            = get(obj, keys_value{1});
new_optStraddleTrading         = eval(class(optstratrade_object));
new_optStraddleTrading.book    = obj.merge_books;
new_optStraddleTrading.quote   = optstratrade_object.quote;
new_optStraddleTrading.volsurf = optstratrade_object.volsurf;
new_optStraddleTrading.quoteS  = optstratrade_object.quoteS;
h_fig = figure(533 + straddle_t);
set(h_fig, 'Menubar', 'none', 'ToolBar', 'figure', ...
    'NumberTitle', 'off', 'Name', '总计')
new_optStraddleTrading.monitor_book_risk_fig(S_low, S_high, h_fig);
uicontrol('Parent', h_fig, 'Style', 'text', ...
    'String', '总计', 'FontSize', 9, ...
    'FontWeight', 'bold', 'Units', 'Normalized', ...
    'Position', [0.005 0.94 0.08 0.05], 'BackgroundColor', 'k', ...
    'ForegroundColor', 'r')









end