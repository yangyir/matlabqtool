function [ calmarR ] =CalmarRatio( nav, rf, period)
% 本函数用于计算calmarR
% [ calmarR ] =CalmarRatio( nav, rf)
% nav: 资产净值
% rf: 无风险年利率，默认5%
% period: 可取如下值： d365, d360, d245, w, m, q, y,默认为d365
% ------------------------------
% 唐一鑫，20150510，重写了main
% 唐一鑫，201505511，将函数调整为仅接受参数nav而不接受yield，故同时删去flag
% 程刚, 20150525, mdd用比例而不是value
% 程刚，20150530，输入加入period


%% 前处理
if ~exist('rf','var')
    rf=0.05;
end

if ~exist('period','var')
    period='d365';
end

%% main
yield   = evl.annualYield(nav, period);
mdd     = evl.maxDrawDown(nav);
calmarR = ( yield - rf ) / mdd;

end

