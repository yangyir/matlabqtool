function sub_single = subframe_entrust(parent, output)
% ���˻�����-ί���µ�
%sub_single_sub_entrust = subframe_single_subframe_entrust(parent)
% ���Ʒ� 230170318

backgroundcolor = get(parent, 'Backgroundcolor');

sub_single.parent = parent;
sub_single.table_optcode = uitable('Parent', parent, 'Units', 'Normalized', 'Position', [0.001 0.35 0.998 0.649], ...
    'FontSize' , 9 , 'FontWeight' ,'bold');
sub_single.table_quote   = uitable('Parent', parent, 'Units', 'Normalized', 'Position', [0.001 0.001 0.299 0.344], ...
    'FontSize' , 9 , 'FontWeight' ,'bold');

% �м�
sub_single.checkbox_mktprice = uicontrol('Parent', parent, 'style', 'checkbox', 'Units', 'Normalized', ...
    'Position', [0.305 0.305 0.04 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '�м�', 'Backgroundcolor', backgroundcolor);
px_str = {'����5';'����4';'����3';'����2';'����1';'����';'����1';'����2';'����3';'����4';'����5'};
sub_single.popup_mktprice    = uicontrol('Parent', parent, 'style', 'popupmenu', 'Backgroundcolor', 'k', ...
    'Foregroundcolor', 'y', 'String', px_str , 'Units', 'Normalized', ...
    'Position', [0.35 0.305 0.055 0.04], 'FontSize', 9, 'FontWeight', 'bold');
set(sub_single.popup_mktprice, 'Value', 5)
% �޼�
sub_single.checkbox_limitprice = uicontrol('Parent', parent, 'style', 'checkbox', 'Units', 'Normalized', ...
    'Position', [0.43 0.305 0.03 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '�޼�', 'Backgroundcolor', backgroundcolor);
% �޼���д�б�
sub_single.table_limitprice    = uitable('Parent', parent, 'Units', 'Normalized', 'Position', [0.305 0.003 0.345 0.3], ...
    'FontSize' , 9 , 'FontWeight' ,'bold');

% �µ�����
% �����µ�
sub_single.button_openfire = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.305 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '�����µ�', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
% һ������
sub_single.button_canceltotally = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.26 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', 'һ������', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
sub_single.button_querytotally  = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.215 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', 'һ����ѯ', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
sub_single.button_payoffplot    = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.17 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', 'PayOff��ͼ', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
sub_single.button_clearoptcode  = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.125 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '�������', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');
sub_single.button_savebooks     = uicontrol('Parent', parent, 'style', 'pushbutton', 'Units', 'Normalized', ...
    'Position', [0.655 0.08 0.075 0.04], 'FontSize' , 9 , 'FontWeight' ,'bold', ...
    'String', '����Book', 'Backgroundcolor', 'k', 'Foregroundcolor', 'r');



% �����Ҽ�
sub_single.contextmenu_opt = uicontextmenu('Parent', output);
set(sub_single.table_optcode, 'UiContextMenu', sub_single.contextmenu_opt)
sub_single.menu_optquote   = uimenu('Parent' , sub_single.contextmenu_opt, 'Label', '����');
sub_single.menu_optcancel  = uimenu('Parent' , sub_single.contextmenu_opt, 'Label', '��ȯ����');


% ����table�ĳ�ʼ��
% table_optcode
optcode = cell(1, 6);
optcode{1} = [ '<html><font color=#9400D3>', '10000888', '</font></html>'];
optcode{2} = [ '<html><font color=#DC143C>', '10000666', '</font></html>'];
optcode{3} = '8';
optcode{4} = '8';
optcode{5} = '��';
optcode{6} = 'ƽ';
set(sub_single.table_optcode, 'Data', optcode, ...
    'ColumnFormat', {'char','char','char','char',{'��','ƽ'},{'��','ƽ'}}, ...
    'ColumnEditable', [false, false, true, true, true, true], 'ColumnWidth', {66,66,44,44,47,47}, 'ColumnName', {'Call','Put','��','��','��/ƽ','��/ƽ'})
% table_quote
optquote = cell(11, 4);
optquote(:, 1)   = {'��5��';'��4��';'��3��';'��2��';'��1��';'���¼�';'��1��';'��2��';'��3��';'��4��';'��5��'};
optquote(:, end) = {'��5��';'��4��';'��3��';'��2��';'��1��';'������';'��1��';'��2��';'��3��';'��4��';'��5��'};
for t = 1:11
   optquote{t, 1} = ['<html><font color=#483D8B>', optquote{t, 1}, '</font></html>'];
   optquote{t, 4} = ['<html><font color=#CD5555>', optquote{t, 4}, '</font></html>'];
   optquote{t, 2} = ''; 
   optquote{t, 3} = ''; 
end
set(sub_single.table_quote, 'Data', optquote, 'ColumnWidth', {66,77,108,66}, 'ColumnName', {'��','�ɽ��۸�','�ɽ���','��'})
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
    'ColumnName', {'����','CP','T','K','��/��','��/ƽ','����','�۸�'}) 
% ��ȡ���� regexp([ '<html><font color=#8B4513>', '10000888', '</font></html>'], '(?<=>)[\d]+(?=<)', 'match')








end