function [ hfig ] = plot_optprice_tau( self, tau  )
%PLOT_OPTPRICE_tau 画期权价格对tau的图
% ----------------------------------
% 吴云峰，20160130
% 吴云峰，20160215，由于tau是由T和currentDate来计算的，因此针对这个情况进行修改
% 吴云峰，20160316，基于copy的数据做研究

%% 预处理
% TODO：检查各个变量是否都有值 

% 将旧的变量进行保存
copy   = self.getCopy();
[ L1, L2 ] = size( copy.optPricers );

%% 画图，画px~tau的图
if ~exist('tau', 'var')
tau = 0.01:0.02:0.5;
end


for j = 1:L1
    for i = 1:L2
        copy.optPricers( j , i ).tau = tau;
    end
end

px   = copy.calcPx();
tau  = copy.optPricers( 1,1 ).tau;

% 如有handlefig输出，就新开figure，否则，画在函数外的figure里
if nargout > 0
    hfig = figure;
end

plot(  tau , px );

xlabel('\tau')
ylabel('px')

grid on
txt = '期权组合Structure价格对 \tau 的函数图';

title(txt);

hold off

end

