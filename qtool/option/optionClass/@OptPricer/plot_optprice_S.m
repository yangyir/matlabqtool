function [ hfig ] = plot_optprice_S( pricer , S  )
%PLOT_OPTPRICE_S 画期权价格对S的图
% ----------------------------------
% 程刚，20160124
% 吴云峰，20160129，增加了obj.sigma长度大于1的情况
% 吴云峰，20160129，增加了不改变原有值的方法
% cg，20160302，修改了默认横轴的值， 加画当前点，略改标题


%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
copy = pricer.getCopy();


% 横轴S默认值域
if ~exist( 'S' , 'var' )
    center = pricer.S;
    if center == 0 || isempty(center) || isnan(center)
        center = pricer.K;
    end
    mn = center * 0.7;
    mx = center * 1.3;
    S  = [0:19] * (mx-mn)/20 + mn;
end;

%% 画图，画px~S的图，带payoff
copy.S = S;
copy.calcPx();

copy.ST = S;
copy.calcPayoff();

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

% 用copy进行作图
plot( copy.S, copy.px );
hold on
plot( copy.ST, copy.payoff, 'k');
legend('期权定价', '到期payoff');
grid on
txt = '期权价格对S的函数图';

% sigma数据的长度
sigmaL = length( copy.sigma );

if sigmaL == 1
%     txt = sprintf('%s\n%s(T=%s,K=%0.2f), sigma=%0.0f%%,t=%s', txt, ...
%         copy.CP,datestr( copy.T ), copy.K, copy.sigma*100, datestr(copy.currentDate));   
    txt = sprintf('%s\n[%s] sigma=%0.0f%%, t=%s, S=%0.3f', txt,...
        pricer.optName, pricer.sigma*100, datestr(pricer.currentDate), pricer.S);
elseif sigmaL > 1
    txt = sprintf('%s\n%s(T=%s,K=%0.2f),t=%s', txt, ...
        copy.CP,datestr( copy.T ), copy.K, datestr(copy.currentDate));
end 

title(txt)



% 加画当前点
hold on
pricer.calcPx();
plot( pricer.S, pricer.px, 'or');
end

