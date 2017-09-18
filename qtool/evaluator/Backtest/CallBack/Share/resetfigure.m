%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于重新设定特定的图形窗口 f ，根据f_position调整图形窗口在屏幕中位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function resetfigure(f,f_position)

% 无菜单栏
set(f,'menubar','none');
% 图形窗口中坐标单位化
set(f,'unit','normalized');
% 图形窗口中控件默认设置为默认
set(f,'defaultuicontrolunits','normalized');
% 调整图形窗口在屏幕中位置
set(f,'position',f_position);

end