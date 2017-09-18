%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于展现buysellpoint所代表买卖清单到f中
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  h = set_table_buysellpiont(f,buysellpoint)

% 本函数设置将calc_buysellpoint函数输出，展示到BuySellPoint

colnames = buysellpoint.data{2};


% 获取root即屏幕坐标
ss2 = get(0, 'screensize');

h = uitable(f, 'Data', buysellpoint.data{1}, 'ColumnName', colnames, ...
    'position',[0.03*ss2(3),0.10*ss2(4),0.78*ss2(3),0.70*ss2(4)] );

end