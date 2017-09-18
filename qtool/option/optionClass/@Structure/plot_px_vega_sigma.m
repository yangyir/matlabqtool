function [ hfig ] = plot_px_vega_sigma( self )
%PLOT_PX_VEGA_SIGMA 画px_vega~sigma的图
% ---------------------
% 吴云峰，20160130
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% 画图

volsurf = 0.10:0.05:1;

for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).sigma = volsurf;
    end
end

copy.calcPx();
copy.calcVega();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% px~sigma
subplot(211)
plot( volsurf , copy.px );
grid on
txt = '期权组合Structure价格对sigma的函数图';
title(txt)
xlabel('sigma')
ylabel('px')

% vega~sigma
subplot(212)
plot( volsurf , copy.vega );
grid on
txt = '期权组合Structure的vega对sigma的函数图';
title(txt)
xlabel('sigma')
ylabel('vega')

hold off

end

