function [ sig_long, sig_short, sig_rs] = Bollinger( price, wsize, wts, nstd, wlow, type)
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
%
%    NSTD - A scalar representing the number of standard deviations for the
%           upper and lower bands. Default = 2.
%    WNAR - 判断是否是窄口的阈值，默认 = 0.1
%    
%    PWIDTH - 判断是否长期横盘的阈值， 默认 = 5
%   Outputs:
%    sigLong - 开平多信号.
%    sigShort - 开平空信号。
%    BOLL - A struct representing the Bollinger bands.

if ~exist('wsize','var') || isempty(wsize), wsize = 20; end
if ~exist('wts', 'var') || isempty(wts), wts = 0; end
if ~exist('nstd', 'var') || isempty(nstd), nstd = 2; end
if ~exist('wlow','var') || isempty(wlow), wlow = 5; end
if ~exist('type','var') || isempty(type), type = 1; end


%初始化
[nPeriod,nAsset]=size(price);
mid=nan(nPeriod,nAsset);
uppr=mid;
lowr=mid;
sig_long=zeros(size(price));
sig_short = sig_long;
sig_rs = sig_long;
width=mid;
bpercent = mid;

if type==1
    for jAsset=1:nAsset
        [mid(:,jAsset),uppr(:,jAsset),lowr(:,jAsset)]=bollinger(price(:,jAsset), wsize, wts, nstd);
        bpercent(:, jAsset) = (price(:,jAsset) - lowr(:,jAsset))./(uppr(:,jAsset) - lowr(:,jAsset));
        sig_rs(bpercent(:, jAsset) < 0, jAsset) = 1;
        sig_rs(bpercent(:, jAsset) > 1, jAsset) = -1;

        sig_long(logical(crossOver(price(:, jAsset), uppr(:, jAsset), 1))) = 1;
        sig_short(logical(crossOver(lowr(:, jAsset), price(:, jAsset), 1))) = -1;
    end
    
elseif type==2
    for jAsset = 1: nAsset
        
        [mid(:,jAsset),uppr(:,jAsset),lowr(:,jAsset)]=bollinger(price(:,jAsset), wsize, wts, nstd);
        width(:,jAsset) = uppr(:,jAsset) - lowr(:,jAsset);

        for iPeriod=1:nPeriod-1  
            %上下带窄
            if width(iPeriod) <= wlow    
                %上穿上支撑线
                if price(iPeriod,jAsset) > uppr(iPeriod,jAsset)
                    sig_long(iPeriod,jAsset) = 1;
%                     sig_short(iPeriod, jAsset) = 1;
                    continue;
                end
                %下穿下支撑线
                if price(iPeriod,jAsset) < lowr(iPeriod,jAsset)
%                     sig_long(iPeriod, jAsset) = -1;
                    sig_short(iPeriod,jAsset)=-1;
                    continue;
                end
            end
        end
        
        % %B<0超卖，%B>1超买
        bpercent(:, jAsset) = (price(:,jAsset) - lowr(:,jAsset))./(uppr(:,jAsset) - lowr(:,jAsset));
        sig_rs(bpercent(:, jAsset) < 0.01, jAsset) = 1;
        sig_rs(bpercent(:, jAsset) > 0.99, jAsset) = -1;
    end
    
end

end

