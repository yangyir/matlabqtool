function [ hfig ] = plot_delta_K( self , K )
%PLOT_DELTA_K 画delta~K的图
% ---------------------
% 吴云峰，20160129
% 吴云峰，20160229，构建一个比较新的复原方法
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理

% 获取复制的数据
copy  = self.getCopy();

%% 画图

if ~exist( 'K' , 'var' )
    K = 1.7:0.02:2.7;
end;

[ L1 , L2 ] = size( copy.optPricers );

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).K = K;
    end
end

copy.calcDelta();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( K , copy.delta );

legend('delta');
xlabel('K')
ylabel('delta')
grid on;
txt = 'Structure期权组合delta对K的函数图';
title( txt )

hold off

end

