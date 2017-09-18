function [ aVol ]    = annualVol( nav, period)
% 根据nav，给定周期period，和给定的纪念方式calendar计算出年化波动率vol
% [ aVol ]    = AnnualVol( nav, period)
%   nav:  净值序列，第一个元素为1
%   period可取如下值： d365, d360, d245, w, m, q, y,默认为d365
%   aVol： 年波动率
% 注意，这里在通过nav计算yield的时候，统一采用了离散复利的计算方法
% 也就是说，r=x(t+1)/x(t) - 1
% ------------------
% 唐一鑫，20150510
% 程刚，20150529，加入 period值 'w'


%% 预处理
if ~exist('period','var')
    period='d365';
end


%% Main
% N = length(nav);
yield   = evl.nav2yield(nav,'compound');
sigma   = std(yield);

% 年化时，只跟数据间隔有关，跟数据长度无关
if strcmp(period,'d365')
    aVol = sigma*sqrt(365);
elseif strcmp(period,'d360')
    aVol = sigma*sqrt(360);
elseif strcmp(period,'d245')
    aVol = sigma*sqrt(245);
elseif strcmp(period,'w')
    aVol = sigma * sqrt( 50 );
elseif strcmp(period,'m')
    aVol = sigma*sqrt(12);
elseif strcmp(period,'q')
    aVol = sigma*sqrt(4);
elseif strcmp(period,'y')
    aVol = sigma*sqrt(1);
end

end

