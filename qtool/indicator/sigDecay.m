function [ sig_out ] = sigDecay(sig_long, sig_short, param)
% sigDecay lowers signal strength after signal initiation
% 如果 param >1，则默认用比率衰减，衰减力度为 param% 
% 如果 param <1, 则按固定数值衰减，衰减力度为 param 数值
% method 1: decay by percentage (default: 50%)
% 转换方法： sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%               0           0           0.25
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%              -1           0           0
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%               0          -1           -0.75
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%               1          -1           0.25
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               0           0           0
%               1          -1           0
% ------------------------------------------
%            sig_long    sig_short   sig_out
%               1           0           1
%               0           0           0.5
%               1           0           1

% @daniel 2013/06/03 version 1

%% preparation
[ nPeriod , nAsset ] =size(sig_long);
sig_out = zeros(nPeriod, nAsset);

if ~exist('param', 'var'), param = 50; end
if param >= 1
    type = 'percent';
elseif param <1 && param>0
    type = 'fixleng';
end

switch type
    case 'percent'
        % 按比例衰减法
        for jAsset = 1: nAsset
            out_last = 0; % initial point of  sig_out
            for iPeriod = 1: nPeriod
                nowLong  = sig_long(iPeriod, jAsset);
                nowShort = sig_short(iPeriod, jAsset);
                
                if nowLong ==0 & nowShort ==0 || nowLong ==1 & nowShort == -1
                    % 如果多空没有信号或多空同时出现信号，则视为没有信号，原信号衰减
                    sig_out(iPeriod, jAsset) = out_last * param/100;
                elseif nowLong == -1 && nowShort == 1
                    % 如果多空均为平仓信号，则原信号归零
                    sig_out(iPeriod, jAsset) =0;
                elseif nowLong == 1 && nowShort == 1 
                    % 如果多空均为看多，则原信号归1
                    sig_out(iPeriod, jAsset) = 1;
                elseif nowLong == 1 && nowShort == 0
                    % 如果多头信号，则原信号衰减并加入新的多头1信号，数值上最大为1
                    sig_out(iPeriod, jAsset) = min(1, 1 + out_last*param/100);
                elseif nowLong == -1 && nowShort == -1
                    % 如果多空均为看空，则信号归为-1
                    sig_out(iPeriod, jAsset) = -1;
                elseif nowLong == 0 && nowShort == -1
                    % 如果空头出现信号，则原信号衰减并加入新空头-1信号，数值最小为-1
                    sig_out(iPeriod, jAsset) = max(-1, -1+out_last*param/100);
                elseif nowLong == -1 && nowShort == 0
                    % 如果多头平仓信号，则原多头归0，原空头则继续衰减
                    sig_out(iPeriod, jAsset) = min(0, out_last*param/100);
                elseif nowLong == 0 && nowShort == 1 
                    % 如果空头平仓信号，则原空头归0，原多头则继续衰减
                    sig_out(iPeriod, jAsset) = max(0, out_last*param/100);
                end
                out_last = sig_out(iPeriod, jAsset);
            end
        end
    case 'fixleng'
        % 按数值衰减法
        for jAsset = 1: nAsset
            out_last = 0;
            for iPeriod = 1: nPeriod
                nowLong  = sig_long(iPeriod, jAsset);
                nowShort = sig_short(iPeriod, jAsset);
                if nowLong ==0 & nowShort ==0 || nowLong ==1 & nowShort == -1
                    % 如果多空没有信号或多空同时出现信号，则视为没有信号，原信号衰减
                    sig_out(iPeriod, jAsset) = m2zero(out_last,  param);
                elseif nowLong == -1 && nowShort == 1
                    % 如果多空均为平仓信号，则原信号归零
                    sig_out(iPeriod, jAsset) =0;
                elseif nowLong == 1 && nowShort == 1 
                    % 如果多空均为看多，则原信号归1
                    sig_out(iPeriod, jAsset) = 1;
                elseif nowLong == 1 && nowShort == 0
                    % 如果多头信号，则原信号衰减并加入新的多头1信号，数值上最大为1
                    sig_out(iPeriod, jAsset) = min(1, m2zero(out_last+1, param));
                elseif nowLong == -1 && nowShort == -1
                    % 如果多空均为看空，则信号归为-1
                    sig_out(iPeriod, jAsset) = -1;
                elseif nowLong == 0 && nowShort == -1
                    % 如果空头出现信号，则原信号衰减并加入新空头-1信号，数值最小为-1
                    sig_out(iPeriod, jAsset) = max(-1, m2zero(-1+out_last,param));
                elseif nowLong == -1 && nowShort == 0
                    % 如果多头平仓信号，则原多头归0，原空头则继续衰减
                    sig_out(iPeriod, jAsset) = min(0, m2zero(out_last,param));
                elseif nowLong == 0 && nowShort == 1 
                    % 如果空头平仓信号，则原空头归0，原多头则继续衰减
                    sig_out(iPeriod, jAsset) = max(0, m2zero(out_last,param));
                end
                out_last = sig_out(iPeriod, jAsset);
            end
        end
end
end

function [out] = m2zero(a, fixleng)
flag = a>=0;
if flag
    out = max(a-fixleng,0);
else
    out = min(a+fixleng,0);
end
end 
    

