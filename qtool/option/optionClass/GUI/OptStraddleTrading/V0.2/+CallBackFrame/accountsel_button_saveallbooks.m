function accountsel_button_saveallbooks(hObject, eventdata, handles)
% һ������Book
% ���Ʒ� 20170330

global MULTI_INSTANCE;
keys_ = keys(MULTI_INSTANCE);
h = warndlg('Book���ڱ�����,��ȴ�........');
h_ax = findobj(h, 'type', 'axes');
h_ax = findobj(h_ax(2), 'type', 'text');
set(h_ax, 'FontWeight', 'bold', 'FontSize', 9)
pause(2)
for t = 1:length(keys_)
    key_str_ = keys_{t};
    stra     = get(MULTI_INSTANCE, key_str_);
    stra.book.toExcel();
end

if ishandle(h)
    delete(h)
end






end