function [ value ] = percentileV(ticks, currentTk, percentile, win, price_type)
%PERCENTILEV 基于过去价格计算给定百分位的价格值
% [ value ] = percentileV(ticks, currentTk, percentile, win, price_type)
% 输入：
%     ticks           数据
%     currentTk       当期tick（向前回溯win格）  
%     percentile      百分位, 如95.8, 25      
%     win             窗口大小
%     price_type      'bid','ask','last'(default)
% 输出：
%     value           百分位对应的价格
%     
%程刚；140608


%% 预处理
if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end
 
if isempty(ticks.latest)
    n = length(ticks.last);
else
    n = ticks.latest ; 
end ; 


if ~exist('price_type', 'var'), price_type = 'last'; end

switch price_type
    case 'last'
        data = ticks.last(1:n);
    case 'bid'
        data = ticks.bidP(1:n,1);
    case 'ask'
        data = ticks.askP(1:n,1);    
    otherwise 
        disp('错误：price_type必须为''last''(缺省）, ''bid'',''ask''');
end ;  



% currentPrice = data(currentTk); 

%% main

if exist('win', 'var')
    if currentTk >= win
        ts = data(currentTk - win + 1 :currentTk);
        value = prctile(ts, percentile);
    else
        disp('错误：currentTk之前没有足够win');
        value = nan;
    end
else
    disp('提示：无win，统计范围1：currentTk');
     ts = data(1 :currentTk);
    value = prctile(ts, percentile); 
end



end

