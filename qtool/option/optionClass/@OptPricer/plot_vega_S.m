function [ hfig ] = plot_vega_S( pricer , S )
%PLOT_VEGA_S 画vega~S的图
% ---------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题

%% 预处理
% TODO: 相关预处理

% 将旧的变量进行保存
copy = pricer.getCopy();


% 横轴S默认值域
if ~exist( 'S' , 'var' )
    center = pricer.S;
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

%% 作图
% 计算
copy.S = S;
vega = copy.calcVega();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( S, vega );

legend('vega');
xlabel('S')
ylabel('vega')

grid on;
txt = 'vega';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt,...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, ...
%     datestr(copy.currentDate));

txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
title(txt)


% 加画当前点
hold on
pricer.calcVega();
plot( pricer.S, pricer.vega, 'or');



end
