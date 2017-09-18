function [ hfig ] = plot_optprice_sigma( pricer , sigma  )
%PLOT_OPTPRICE_SIGMA 画期权价格对sigma的图
% ----------------------------------
% 沈杰，20160124
% 吴云峰，20160129，增加了不改变原有值的方法
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题


%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
copy = pricer.getCopy();

% 横轴sigma默认值域
if ~exist( 'sigma' , 'var' )
    center = pricer.sigma;
    if isnan(center), center = 0.3; end
    if isempty(center), center = 0.3; end
    if center <= 0,  center = 0.3; end
    mn = min( [ center * 0.5, 0.1]);
    mx = max( [ center * 1.5, 0.6] ); 
    sigma =[0:19] * (mx-mn)/20 + mn;
end

%% 画图，画px~sgima的图 obj.sigma*100
copy.sigma = sigma;
copy.calcPx();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( copy.sigma, copy.px );

xlabel('sigma')
ylabel('px') 
grid on
txt = '期权价格对sigma的函数图';
txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
    copy.CP,datestr( copy.T ), copy.K ,...
    datestr(copy.currentDate) );

title(txt)

% 加画当前点
hold on
pricer.calcPx();
plot( pricer.sigma, pricer.px, 'or');


end

