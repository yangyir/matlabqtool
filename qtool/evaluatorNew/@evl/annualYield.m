function [ aYield ]  = annualYield( nav, period)
% 根据一段时期Period的nav，计算年化yield
% [ aYield ]  = AnnualYield( nav, period)
% nav:  净值序列，第一个元素为1
% period可取如下值： d365, d360, d245, w, m, q, y,默认为d365
% 注意，这里在通过nav计算yield的时候，统一采用了离散复利的计算方法
% 也就是说，r=x(end)/x(1)-1
% ------------------
% 唐一鑫，20150510
% 程刚，20150529，加入 period值 'w'

%% 预处理
if ~exist('period','var')
    period='d365';
end
%% Main
N = length(nav);

% 全时段收益
yield = nav(end)/nav(1)-1;

% 年化
if strcmp(period,'d365')
    aYield = yield*365/N;
elseif strcmp(period,'d360')
    aYield = yield*360/N;
elseif strcmp(period,'d245')
    aYield = yield*245/N;
elseif strcmp(period,'w')
    aYield = yield * 50/N;
elseif strcmp(period,'m')
    aYield = yield*12/N;
elseif strcmp(period,'q')
    aYield = yield*4/N;
elseif strcmp(period,'y')
    aYield = yield*1/N;
end

end

