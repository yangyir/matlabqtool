function [ hfig ] = plot_delta_S( self , S )
%PLOT_DELTA_S 画delta~S的图
% ---------------------
% 吴云峰，20160129
% 吴云峰，20160229，构建一个比较新的复原方法
% 吴云峰，20160316，模仿刚哥修改了默认横轴的值， 加画当前点，略改标题

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% 画图

% 横轴S默认值域
if ~exist( 'S' , 'var' )
    center = copy.optPricers(1,1).S;
    try
        wrong =  center == 0 || isempty(center) || isnan(center);
        if wrong,  center = pricer.K; end    
    catch e
        center = pricer.K;
    end
    mn = center * 0.7;
    mx = center * 1.3;
    S  = [0:19] * (mx-mn)/20 + mn;
end;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).S = S;
    end
end

copy.calcDelta();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( S , copy.delta );
legend('delta');

xlabel('S')
ylabel('delta')

grid on;
txt = 'Structure期权组合delta对S的函数图';
title(txt)

hold off

end

