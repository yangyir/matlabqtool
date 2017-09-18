function [EY_x, xnodes, xcount] = EYx( x, y, plotflag, xnodes  )
% EYx 条件期望 E(Y|X = x)
% 尊重数学习惯，函数名首字母大写，随机变量Y大写，函数变量x小写
% inputs:
%   x         :X，vector, x,y 须同长度
%   y         :Y，vector
%   xnodes    :x的划分点，默认均分20类，左开右闭
%   plotflag  : ==1则画图, ==0则不画（默认）
% output：
%   EY_x      :给定x，Y的期望 （是x的函数）  
%   xnodes    :同input
%   xcount    :每个划分中的点的数量（用于检验显著性）
% -------------------------------------------------------
% ver1.0; Cheng,Gang; 20130416

%% pre-process

% plotflag 默认1，画图
if ~exist('plotflag','var') plotflag = 0; end

% xnodes 默认值，分离散、连续两种情况
if ~exist('xnodes', 'var')
    
    mn      = nanmin(x);
    mx      = nanmax(x);
    xnodes  = unique(x);
    
    % 若x离散，直接取值，左开右闭
    if length(xnodes) < 20
        xnodes = [mn - (mx-mn)/20; xnodes];
    
    % 若x连续，20等分（min，max]，左开右闭
    else    
        xnodes      = linspace( mn, mx, 20);
%         xnodes(1)   = mn - (mx-mn)/20;
    end
    
end
%% main

lenx    = length(xnodes);
EY_x     = nan(lenx,1);
xcount  = nan(lenx,1);

for ix = 1:lenx - 1
    EY_x(ix+1)   = nanmean( y ( x > xnodes(ix) & x <= xnodes(ix+1)) );  
    xcount(ix+1)= nansum(  x > xnodes(ix) & x <= xnodes(ix+1) );
end

%% plot to check right

if plotflag == 1
    figure
    subplot
    
    subplot(2,1,1)
    plot( xnodes, EY_x, '-*');
    
    subplot(2,1,2)
    bar(xnodes, xcount)
end

end

