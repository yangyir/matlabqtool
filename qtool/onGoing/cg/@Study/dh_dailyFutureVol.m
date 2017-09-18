function [ vol, rangePct ] = dh_dailyFutureVol( code, date)
%DH_DAILYFUTUREVOL 看一下期货的日度vol
% 基于分钟close数据



%% 为了方便parfor
try 
    checklogin;  
catch e
    DH;
end

%% 取日内价格
% tic
if isa(date, 'double'),  date = datestr(date); end
s = DH_Q_HF_FutureSlice(code, date, 'ClosePrice',1);

% toc
%% 算波动率
% 日内波动率
vol      = std(log(s));


% 验证 vol == stdPricePct （vol比较小时成立）
% stdPrice    = std(s)
% stdPricePct = std(s)/mean(s)
% error = vol - stdPricePct


rangePct = ( max(s)-min(s) ) / mean(s);

%% 作图
% figure(651); hold off; plot(s); title(sprintf('%s : %s, vol = %0.3f%%',code, date, vol*100) )

end

