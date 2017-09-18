function alpha = alpha( nav, benchmark, rfr,period)
% 本函数用于计算alpha系数
% alpha = Alpha( nav, benchmark, rf)
%   nav 资产净值
%   benchmark 市场收益值
%   rfr 无风险年利率
%   period 数据周期， 'w','m','q','y','d360','d365','d245'
% --------------------------------------
% panqichao，不详
% 程刚，20150510，略改
% 唐一鑫，20150511，将参数改为仅适用nav而不用rate的情形，故同时删去参数flag
% 唐一鑫，20150729，更正了计算中的年化问题

%% 预处理
% 无风险利率默认 5%
if ~exist('rfr','var'), rfr = 0.05; end

if ~exist('period','var')
    period='d365';
end
%% main
% 对净值序列取log

beta = evl.beta(nav,benchmark);

yieldBmark = evl.annualYield(benchmark,period);

yieldNav = evl.annualYield(nav,period);

alpha = yieldNav - rfr - beta * (yieldBmark - rfr); 

end
