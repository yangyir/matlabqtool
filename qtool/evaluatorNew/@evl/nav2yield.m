function [ yield ] = nav2yield(nav,  flag)
% 把一个收净值序列nav转换成收益率序列yield
%  [ yield ] = nav2yield(nav,  flag)
% yield: 收益率序列
% nav:  净值序列，第一个元素为1
% flag: 单利'simple', 或复利'compand'，默认'compound'
% 注意：nav 和 yield 都是列向量，长度会差一个
% ------------------
% 唐一鑫，20150510

%% 预处理
if ~exist('flag', 'var') 
    flag = 'compound';
end

% 检查维度

%% Main
N       = length(nav);
yield   = ones(N-1,1);

if strcmp( flag, 'simple')
    yield = nav(2:end)-nav(1:end-1);
elseif strcmp( flag, 'compound')
    yield = nav(2:end)./nav(1:end-1)-1;
else
    error('flag输入有错');
end
    




end

