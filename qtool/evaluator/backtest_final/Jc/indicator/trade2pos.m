function  [  sig_rs  ]  = trade2pos(sig_long, sig_short)
% 开平仓信号转化为仓位/强弱信号
% [  sig_rs  ]  = trade2pos(sig_long, sig_short)
% 输入：   为tai函数的默认前两项输出，多头开平（sig_long）和空头开平（sig_short）信号
% 输出：   为tai函数的默认第三个输出，持仓/强弱信号（sig_rs)
% 出发点： 大部分指标只给出开仓信号，而非持仓信号。
% 转换方法： sig_long    sig_short   sig_rs
%               1           0           1
%               0           0           1
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               1           0           1
%              -1           0           0
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               1           0           1
%               0          -1           -1
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               1           0           1
%               1          -1           1
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               0           0           0
%               1          -1           0
% ------------------------------------------
%            sig_long    sig_short   sig_rs
%               1           0           1
%               1           0           1
% 空头sig_short 的情况类似sig_long, 只是开仓信号为 -1
% 
% @author   daniel  20130507

[nPeriod, nAsset] = size(sig_long);
sig_rs = zeros(nPeriod, nAsset);

% 计算步
% rs_last   nowLong     nowShort
%   1           1           1
%   0           0           0
%  -1          -1          -1

for jAsset = 1: nAsset
    rs_last = 0; 
    for iPeriod = 1 : nPeriod
        nowLong = sig_long(iPeriod, jAsset);
        nowShort = sig_short(iPeriod, jAsset);
    
        % 持仓 = 1 的条件
        rsLong =    rs_last ==1     &   nowLong == 1 ||...
                    rs_last + nowLong == 1  & nowShort >=0 ||...
                    rs_last == -1   &   nowLong  ==1 & nowShort >= 0;

        % 持仓 = 0 的条件
        rsZero =    rs_last == 1    &   nowLong == -1 & nowShort >=0 ||...
                    rs_last == -1   &   nowLong ~= 1  & nowShort ==1 ||...
                    rs_last == 0    &   nowLong + nowShort == 0     ||...
                    rs_last == 0    &   nowLong == -1 & nowShort == 0 ||...
                    rs_last == 0    &   nowLong == 0  & nowShort == 1;

        % 持仓 = -1 的条件 
        rsShort =   rs_last == -1   &   nowShort == -1 ||...
                    rs_last + nowShort == -1  & nowLong  <= 0 ||...
                    rs_last == 1    &   nowShort == -1 & nowLong <= 0 ;
            
        if rsLong
            sig_rs(iPeriod, jAsset) = 1;
        end
        if rsZero
            sig_rs(iPeriod, jAsset) = 0;
        end
        if rsShort
            sig_rs(iPeriod, jAsset) = -1;
        end
        rs_last = sig_rs(iPeriod, jAsset);
    end
end

end %EOF
       
       
        
        
        
        
        
        
        