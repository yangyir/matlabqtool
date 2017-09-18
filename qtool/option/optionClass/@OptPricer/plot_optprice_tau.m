function [ hfig ] = plot_optprice_tau( pricer )
%PLOT_OPTPRICE_tau 画期权价格对tau的图
% ----------------------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题


%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
copy = pricer.getCopy();

% 横轴tau默认值
if ~exist( 'tau' , 'var' )
    longend = ceil( pricer.tau * 10 ) / 10;
    tau =   0.05 * [1:20] * longend ;
end

%% 画图，画px~tau的图
% 计算
copy.tau = tau;
px = copy.calcPx();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( tau, px );
xlabel('\tau')
ylabel('px')

grid on
txt = '期权价格对 \tau 的函数图';
% txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%% ', txt, ...
%     copy.CP,datestr( copy.T ), copy.K, copy.sigma*100 );

txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
    pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);

title(txt)


% 加画当前点
hold on 
pricer.calcPx();
plot( pricer.tau, pricer.px, 'or');


end

