function [ sig_long, sig_short ] = pos2trade(   sig_rs  )
% 将持仓信号转为开平仓信号
% [ sig_long, sig_short ] = pos2trade(   sig_rs  )
% 输入： 为tai函数的默认第三项，持仓/强弱信号（sig_rs)
% 输出： 为tai函数的默认前两项，多头开平（sig_long）和空头开平（sig_short）信号
% 此函数的反向操作为 trade2pos
% 转换方法：
% sig_rs  sig_long    sig_short
%   1        
%   0        -1          0    
% -----------------------------
% sig_rs  sig_long    sig_short
%   1        
%   -1       -1          -1    
% -----------------------------
% sig_rs  sig_long    sig_short
%   0        
%   1        1          0    
% -----------------------------
% sig_rs  sig_long    sig_short
%   0        
%   -1        0          -1    
% -----------------------------
% 净空仓与此相反
% @author   daniel  20130507

[ nPeriod, nAsset ] = size(sig_rs);
sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);

%计算步

for jAsset = 1: nAsset
    rs_last = 0;
    for iPeriod = 1: nPeriod
        rs_now = sig_rs(iPeriod, jAsset);
        if rs_now == rs_last
            continue;
        elseif rs_last == 1
            sig_long(iPeriod, jAsset) = -1;
            if rs_now == -1
                sig_short(iPeriod, jAsset) = -1;
            end
        elseif rs_last ==0 
            if rs_now == 1
                sig_long(iPeriod, jAsset) = 1;
            else
                sig_short(iPeriod, jAsset) = -1;
            end
        elseif rs_last == -1
            sig_short(iPeriod, jAsset) = 1;
            if rs_now == 1
                sig_long(iPeriod, jAsset) = 1;
            end
        end
        rs_last = sig_rs(iPeriod, jAsset);
    end
end

        

