function [ h1, h2 ] = value_hist( vector, times, tickvalue )
%VALUE_HIST 左图value，右图竖版hist，两图纵坐标统一
% vector          数值序列（Y轴）
% times           时间值序列（X轴）,默认是1:length(vector)
% tickvalue       画hist时的间隔，如不给则计算
% h1, h2          subplot handles
% 程刚，140611


%% 预处理
if ~exist('times', 'var'), times = 1:length(vector); end

if size(vector,2) > 2, 
    disp('警告：vector大于2个，仅取第一列第二列');
    vector = vector(:,1:2); 
end

mx = max(max(vector));
mn = min( min(vector) );


%% 算tickvalue
if ~exist('tickvalue', 'var') 
    diffs = unique(abs( diff(vector) ) );
    mndiff = min( diffs(diffs> 0.001*(mx-mn)) );
    
    % 人为定一个离散和连续的界限：100倍mndiff
    if (mx-mn)/mndiff < 100
        tickvalue = mndiff;
    else
        tickvalue = (mx-mn)/20;
    end
end


%% main
h1 = subplot(1,2,1); hold off
plot( times, vector);
set(h1,'ylim',[mn, mx] );
title('value: time series')


%% main2
intervals = mn:tickvalue:mx;

h2 = subplot(1,2,2); hold off;
[N, X] = hist(vector, intervals);
barh(X, N );
set(h2,'ylim',[mn, mx] );
title('histogram along Y axis');

end

