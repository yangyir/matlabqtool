function [ pxy, ttl_cnt ] = PXY( x,y,plotflag,xnodes,ynodes )
%PXY 计算联合概率P(XY)，可接受x,y取值离散、连续
% 尊重数学习惯，函数名首字母大写，随机变量X、Y大写
% inputs::
%   x         :vector，列向量，x、y必须同维数
%   y         :vector，列向量
%   xnodes    :x划分节点，左开右闭，默认20等分
%   ynodes    :y划分节点，左开右闭，默认20等分
%   plotflag  :1作图， 0不作图（默认）
% outputs::
%   pxy       :联合概率分布（实际频数分布）
%   ttl_cnt   :总计数，用于估算概率有效性
% ----------------------------------------------------
% ver1.0; Cheng,Gang; 20130417; 

%% pre-process

if ~exist('plotflag','var') plotflag = 0 ; end

% xnodes 默认值，分离散、连续两种情况
if ~exist('xnodes', 'var')
    
    mn      = nanmin(x);
    mx      = nanmax(x);
    xnodes  = unique(x);
    
    % 若x离散，直接取值，左开右闭
    if length(xnodes) < 20
        xnodes      = [mn - (mx-mn)/20; xnodes];
    
    % 若x连续，20等分（min，max]，左开右闭
    else    
        xnodes      = linspace( mn, mx, 20);
%         xnodes(1)   = mn - (mx-mn)/20;
    end
    
end

% ynodes 默认值，分离散、连续两种情况
if ~exist('ynodes', 'var')
    
    mn      = nanmin(y);
    mx      = nanmax(y);
    ynodes  = unique(y);
    
    % 若x离散，直接取值，左开右闭
    if length(ynodes) < 20
        ynodes      = [mn - (mx-mn)/20; ynodes];
    
    % 若x连续，20等分（min，max]，左开右闭
    else
        ynodes      = linspace( mn, mx, 20);
%         ynodes(1)   = mn - (mx-mn)/20;
    end
    
end




%% main

ttl_cnt = length(x);
lenx    = length(xnodes);
leny    = length(ynodes);
pxy     = nan(lenx, leny);

%频次统计
for ix = 1:lenx - 1
    for iy = 1: leny -1
        count = nansum(   x >   xnodes(ix) ... 
                        & x <=  xnodes(ix+1) ...
                        & y >   ynodes(iy) ...
                        & y <=  ynodes(iy+1));
        pxy(ix+1,iy+1) = count/ttl_cnt; 
    end
end

%% plot 
if plotflag == 1 
    figure
    surf(xnodes', ynodes', pxy');
end
end

