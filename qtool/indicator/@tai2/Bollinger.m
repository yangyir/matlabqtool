function [ sig_long, sig_short, sig_rs] = Bollinger( bars, wsize, wts, nstd, wlow, type)
%BOLLINGER ���㲼�ִ����źš�
%
%   [sigLong, sigShort, sig_rs, boll] = calBollinger(price, wsize, wts, nstd, wnar, pwidth)
%
%   ��ѡ����: wsize, wts, nstd, wnar, pwidth
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
%    Whigh - �����ֵ��Ĭ�� = 12
%    
%    wlow - խ����ֵ�� Ĭ�� = 5
%   Outputs:
%    sigLong - ��ƽ���ź�.
%    sigShort - ��ƽ���źš�
%    BOLL - A struct representing the Bollinger bands.
if ~exist('wsize','var') || isempty(wsize), wsize = 20; end
if ~exist('wts', 'var') || isempty(wts), wts = 0; end
if ~exist('nstd', 'var') || isempty(nstd), nstd = 2.5; end
if ~exist('wlow', 'var') || isempty(wlow), wlow = 5; end
if ~exist('type', 'var') || isempty(type), type = 1; end

price = bars.close;

[sig_long, sig_short, sig_rs] = tai.Bollinger(price, wsize, wts, nstd, wlow, type);

if nargout == 0
    [boll.mid, boll.uppr, boll.lowr] = bollinger(price, wsize, wts, nstd);
    bars.plotind2(sig_long + sig_short, boll);
    title('bollinger long and short');
    bars.plotind2(sig_rs, boll);
    title('bollinger rs');
end
end

