%% s的入口
% 注1：设置为nan，强制空仓（设置0未必空仓，因为还要中性化）
% 注2：code是保留字，是000001.SZ
% 注3：时间通过下标实现，如果要看日期，
%     dateArr(i)形同'2014-09-14'
%     dateNumArr(i)形同 735839
% 注4, col 是保留字
% 注5，其他保留字对照Main15_basicData看： 
%     open, close, high, low, avg (向前复权）
%     openRT, closeRT, highRT, lowRT, avgRT（不复权）
%     volume, amount, change, retrn（不是return）
%     retrn2, tradable
% 注6，经常用到的函数在mv类中，如 mv.avg
% --------------------------------------
% 程刚，140915
% 程刚，141001，加入后处理
    
%% 用于写各种ｓ

% a = mv.stddev( log(1+retrn2),5);
% b = mv.stddev(log(1+retrn2),50);
% s = a-b;


%% alpha = ma(close, 20) - ma(close, 5) 

s = mv.avg(close,20) - mv.avg(close,5);


%% 评级策略

% s = (descendRatingNum - ascendRatingNum)./( rating.^4 );

% tmp = 0.1+ descendRatingNum - ascendRatingNum;
% s = sign(tmp).* power(abs(tmp),1/2)./( rating.^1);
% 
% s = 1./rating.^10;
% s = 1./rating.^10 .* power( ratingNum, 1/2);

%% ROE, EPS 策略
% s = roeDeducted .* epsDiluted;
% s = roeDeducted .* revenueYoy ;
% s2 = mv.avg(close,20) - mv.avg(close,5);
% s = s .* s2;


%% sum_i(close,20)
% for i = 1:20
%     sum = sum + close(t -i );
% end 



%% INF是不应该出现的
s(s==Inf) = nan;
s(s==-Inf) = nan;