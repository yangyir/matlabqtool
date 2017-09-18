function sub_single = subframe_entrust(parent, output)
% 单账户管理-委托下单
%sub_single_sub_entrust = subframe_single_subframe_entrust(parent)
% 吴云峰 230170318

backgroundcolor = get(parent, 'Backgroundcolor');

sub_single.parent = parent;
sub_single.table_optcode = uitable('Parent', parent, 'Units', 'Normalized', 'Position', [0.001 0.35 0.998 0.649], ...
    'FontSize' , 9 , 'FontWeight' ,'bold');
sub_single.table_quote   = uitable('Parent', parent, 'Units', 'Normalized', 'Position', [0.001 0.001 0.299 0.344], ...
    'FontSize' , 9 , 'FontWeight' ,'bold');

% 市价
sub_single.checkbox_mktprice = uicontrol('Parent', parent, 'style', 'checkbox', 'Units', 'Normalized', ...
    'Position', [0.305 0.305 0.04 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '市价', 'Backgroundcolor', backgroundcolor);
px_str = {'对手5';'对手4';'对手3';'对手2';'对手1';'最新';'本方1';'本方2';'本方3';'本方4';'本方5'};
sub_single.popup_mktprice    = uicontrol('Parent', parent, 'style', 'popupmenu', 'Backgroundcolor', 'k', ...
    'Foregroundcolor', 'y', 'String', px_str , 'Units', 'Normalized', ...
    'Position', [0.35 0.305 0.055 0.04], 'FontSize', 9, 'FontWeight', 'bold');
set(sub_single.popup_mktprice, 'Value', 5)
% 限价
sub_single.checkbox_limitprice = uicontrol('Parent', parent, 'style', 'checkbox', 'Units', 'Normalized', ...
    'Position', [0.43 0.305 0.03 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '限价', 'Backgroundcolor', backgroundcolor);
% 限价填写列表
sub_single.table_limitprice    = uitable('Parent', parent, 'Units', 'Normalized', 'Position', [0.305 0.003 0.345 0.3], ...
    'FontSize' , 9 , 'FontWeight' ,'bold');

% 下单操作
% 开火下单
sub_single.button_openfire = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.305 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '开火下单', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
% 一键撤单
sub_single.button_canceltotally = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.26 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '一键撤单', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
sub_single.button_querytotally  = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.215 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '一键查询', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
sub_single.button_payoffplot    = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.17 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', 'PayOff作图', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
sub_single.button_clearoptcode  = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.125 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '输入清除', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
sub_single.button_savebooks     = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.08 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '保存Book', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');



% 设置右键
sub_single.contextmenu_opt = uicontextmenu('Parent', output);
set(sub_single.table_optcode, 'UiContextMenu', sub_single.contextmenu_opt)
sub_single.menu_optquote   = uimenu('Parent' , sub_single.contextmenu_opt, 'Label', '行情');
sub_single.menu_optcancel  = uimenu('Parent' , sub_single.contextmenu_opt, 'Label', '个券撤单');


% 基于table的初始化
% table_optcode
optcode = cell(1, 6);
optcode{1} = [ '<html><font color=#9400D3>', '10000888', '</font></html>'];
optcode{2} = [ '<html><font color=#DC143C>', '10000666', '</font></html>'];
optcode{3} = '8';
optcode{4} = '8';
optcode{5} = '开';
optcode{6} = '平';
set(sub_single.table_optcode, 'Data', optcode, ...
    'ColumnFormat', {'char','char','char','char',{'开','平'},{'开','平'}}, ...
    'ColumnEditable', [false, false, true, true, true, true], 'ColumnWidth', {66,66,44,44,47,47}, 'ColumnName', {'Call','Put','量','量','开/平','开/平'})
% table_quote
optquote = cell(11, 4);
optquote(:, 1)   = {'卖5价';'卖4价';'卖3价';'卖2价';'卖1价';'最新价';'买1价';'买2价';'买3价';'买4价';'买5价'};
optquote(:, end) = {'卖5量';'卖4量';'卖3量';'卖2量';'卖1量';'最新量';'买1量';'买2量';'买3量';'买4量';'买5量'};
for t = 1:11
   optquote{t, 1} = ['<html><font color=#483D8B>', optquote{t, 1}, '</font></html>'];
   optquote{t, 4} = ['<html><font color=#CD5555>', optquote{t, 4}, '</font></html>'];
   optquote{t, 2} = ''; 
   optquote{t, 3} = ''; 
end
set(sub_single.table_quote, 'Data', optquote, 'ColumnWidth', {66,77,108,66}, 'ColumnName', {'价','成交价格','成交量','量'})
% table_limitprice
optlimit = cell(1, 8);
optlimit{1} = [ '<html><font color=#8B4513>', '10000888', '</font></html>'];
optlimit{2} = 'call';
optlimit{3} = 1;
optlimit{4} = 2.35;
optlimit{5} = '1';
optlimit{6} = '2';
optlimit{7} = '5';
optlimit{8} = '';
set(sub_single.table_limitprice, 'Data', optlimit, 'ColumnEditable', [false(1, 7), true], 'ColumnWidth', {66, 50, 50, 55, 50, 50,50, 66}, ...
    'ColumnName', {'代码','CP','T','K','买/卖','开/平','数量','价格'}) 
% 获取代码 regexp([ '<html><font color=#8B4513>', '10000888', '</font></html>'], '(?<=>)[\d]+(?=<)', 'match')








end