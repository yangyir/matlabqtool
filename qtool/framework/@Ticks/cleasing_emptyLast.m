function [  ] = cleasing_emptyLast( obj )
%CLEASING_EMPTYLAST 数据清洗：last为空或0时，填充
% 典型情况：集合竞价时段，没有last
% --------------------------
% 程刚，201609




%% 粗暴版本
obj.last( obj.last == 0 ) = obj.preSettlement;

%% 集合竞价时，要有last
% J = find(obj.last>0, 1, 'first');
% obj.last(1:J) = obj.preSettlement;


%% plot 看一下，debug用
plot_flag = 0;
if plot_flag == 1
    plot(obj.last);
end

end

