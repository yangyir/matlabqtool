%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������չ��buysellpoint�����������嵥��f��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  h = set_table_buysellpiont(f,buysellpoint)

% ���������ý�calc_buysellpoint���������չʾ��BuySellPoint

colnames = buysellpoint.data{2};


% ��ȡroot����Ļ����
ss2 = get(0, 'screensize');

h = uitable(f, 'Data', buysellpoint.data{1}, 'ColumnName', colnames, ...
    'position',[0.03*ss2(3),0.10*ss2(4),0.78*ss2(3),0.70*ss2(4)] );

end