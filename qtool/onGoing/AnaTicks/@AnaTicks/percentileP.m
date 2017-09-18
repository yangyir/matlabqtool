function [ percentile ] = percentileP(ticks, currentTk, valuePrice, win, price_type)
%PERCENTILEP 基于过去价格计算给定价格所处的百分位
% [ percentile ] = percentileP(ticks, currentTk, valuePrice, win, price_type)
% 低价格 -- 低百分位
% 输入：
%     ticks           数据
%     currentTk 
%     valuePrice      价格    
%     win             窗口大小
%     price_type      'bid','ask','last'(default)
% 输出：
%     percentile      价格对应的百分位  
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



%% main

if exist('win', 'var')
    if currentTk >= win
        ts = data(currentTk - win + 1 :currentTk);               
        % 直接反解经常出错
%         percentile = fzero(@(x) prctile(ts, x)-valuePrice, 50);
        
        % 自己写了一个private函数做：
        percentile = prctileP(ts, valuePrice);      
    else
        disp('错误：currentTk之前没有足够win');
        percentile = nan;
    end
else
    disp('提示：无win，统计范围1：currentTk');
     ts = data(1:currentTk);
     percentile = prctileP(ts, valuePrice);   

end


end

