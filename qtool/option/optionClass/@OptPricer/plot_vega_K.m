function [ hfig ] = plot_vega_K( pricer , K )
%PLOT_VEGA_K 画vega~K的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();

%% 作图

if ~exist( 'K' , 'var' )
    center = copy.K;
    leftK  = center - 0.3;
    rightK = center + 0.3;
    K = leftK:0.02:rightK;
end;

copy.K = K;

copy.calcVega();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot( copy.K, copy.vega);
legend('vega');

xlabel('K')
ylabel('vega')

grid on;
txt = '期权vega对K的函数图';
txt = sprintf('%s\n%s(T=%s), sigma=%0.0f%%,t=%s', txt,...
    copy.CP,datestr( copy.T ), copy.sigma*100,...
    datestr(copy.currentDate));

title(txt)

hold on

% 做出中心的点
copy.K = center;
copy.calcVega();
plot( copy.K, copy.vega , 'r*' ,...
    'MarkerSize' , 10 );


end

