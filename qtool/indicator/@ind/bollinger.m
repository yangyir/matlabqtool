function [mid, uppr, lowr ] = bollinger( closePrice, wsize, wts, nstd)
%BOLLINGER 计算布林带和信号。
%
%   [sigLong, sigShort, sig_rs, boll] = calBollinger(price, wsize, wts, nstd, wnar, pwidth)
%
%   可选输入: wsize, wts, nstd, wnar, pwidth
%
%   Inputs:
%    PRICE - A matix representing price series of  assets.
%
%   Optional inputs:
%   WSIZE - A scalar representing the window size. Default is 20.
%
%     WTS - A scalar representing the weight factor. This determinest he type of
%           moving average used.
%
%           Type   -   Value
%           ----------------
%           Box    -   0 (Default)
%           Linear -   1
%.

if ~exist('wsize','var'), wsize = 20; end
if ~exist('wts', 'var'),  wts = 0; end
if ~exist('nstd', 'var'), nstd = 2; end

%初始化
[nPeriod,nAsset]=size(closePrice);
mid=nan(nPeriod,nAsset);
uppr=mid;
lowr=mid;

for jAsset=1:nAsset
    
    [mid(:,jAsset),uppr(:,jAsset),lowr(:,jAsset)]=bollinger(closePrice(:,jAsset), wsize, wts, nstd);
    
end

end

