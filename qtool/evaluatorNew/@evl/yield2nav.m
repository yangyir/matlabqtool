function  [ nav ]  = yield2nav(yield, flag )
% 把一个收益率序列yield转换成净值序列nav
% [ nav ] = Yield2Nav(yield, flag )
% yield: 收益率序列
% flag: 单利'simple', 或复利'compand'，默认'simple'
% nav:  净值序列，第一个元素为1
% 注意：nav 和 yield 都是列向量，长度会差一个
% ------------------
% 唐一鑫，20150510


%% 预处理
if ~exist('flag', 'var') 
    flag = 'simple';
end

% 检查维度


%% Main
N   = length(yield);
nav = ones(N+1,1);

if strcmp( flag, 'simple')
    nav(2:end) = cumsum(yield) + 1;
elseif strcmp( flag, 'compound')
    nav(2:end) = cumprod(1+yield);
else
    error('flag输入有错');
end
    


end

