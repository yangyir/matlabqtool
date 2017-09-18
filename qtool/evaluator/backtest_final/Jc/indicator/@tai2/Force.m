function [sig_rs] = Force(bar, nday,thresh, type)
%计算forceindex
%输入 Close,volume,表示周期的n
%输出为force的计算值 以及交易信号 signal
%   Yan Zhang   version 1.0 2013/3/12
% 默认的周期为13

%force>thresh, 购买力强，信号为-1
%force<-thresh, 购买力若，信号为1
%   Yan Zhang   version 1.1 2013/3/21

if ~exist('type', 'var') || isempty(type), type = 1; end
if ~exist('nday', 'var') || isempty(nday), nday = 13; end
if ~exist('thresh', 'var') || isempty(thresh), thresh = 50; end
close = bar.close;
volume = bar.volume;

sig_rs = tai.Force(close, volume, nday, thresh, type);

 
if nargout == 0
    force.force = ind.force(close, volume, nday);
    bar.plotind2(sig_rs, force, true);
    title('force rs');
end
end


 