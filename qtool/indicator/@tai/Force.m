function [sig_rs] = Force(ClosePrice,TradeVol,nday,thresh, type)
%计算forceindex
%输入

%【数据】ClosePrice,TradeVol
%【参数】 nday移动平均回溯天数（自然数）,thresh 反映购买力的阈值
% 输出为force的交易信号 signal
%   Yan Zhang   version 1.0 2013/3/12
% 默认的周期为13

%force>thresh, 购买力强，信号为-1
%force<-thresh, 购买力弱，信号为1
%   Yan Zhang   version 1.1 2013/3/21

%%  预处理
if nargin <2
    error('not enough input');
end

if ~exist('type', 'var') || isempty(type), type = 1; end
if ~exist('nday', 'var') || isempty(nday), nday = 13; end
if ~exist('thresh', 'var') || isempty(thresh), thresh = 50; end

%% 计算force值
 forcevalue=ind.force(ClosePrice,TradeVol,nday);
%% 计算信号
if type==1
sig_rs=(forcevalue>thresh)*(-1)+((forcevalue<-thresh)*(1));
else
;
end
