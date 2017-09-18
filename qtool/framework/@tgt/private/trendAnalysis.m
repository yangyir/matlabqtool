function [stat, lastSure, fivePoints] = trendAnalysis( bar, mu_up, mu_down, wsize, now)
%TRENDANALYSIS 计算价格序列中的局部高低点
%   input：
%    price 单一资产价格序列
%    mu_up 上升阈值
%    mu_down 下降阈值
%    wsize：五点窗口时间
%    now 现在时间（用于画图，默认nPeriod）
%   output：
%    stat: 每个点是否是局部高低点（0,-1,1）
%    lastSure：当前信息条件下能确定的最后的局部高低点
%    fivePoints：五点矩阵

price = bar.close;
nPeriod = length(price);
leftStat = zeros(nPeriod, 1);
stat = leftStat;
lastSure = leftStat;

if ~exist('wsize', 'var')
    wsize = inf;
end

if ~exist('now', 'var')
    now = nPeriod;
end
for i = 2:nPeriod
    lastSure(i) = lastSure(i-1);
    
    for j = lastSure(i)+1:i-1
        %local high
        if leftStat(j)==1 && price(j)/price(i)>=1+mu_down
            flag = 1;
            for m=j:i-1
                for n=m+1:i
                    if price(n)/price(m)>=1+mu_up
                        flag = 0;
                        break;
                    end
                end
                if flag==0
                    break;
                end
            end
            
            if flag==1
                if lastSure(i)==0 
                    stat(j) = 1;
                    lastSure(i) = j;
                elseif stat(lastSure(i))==-1
                    stat(j) = 1;
                    lastSure(i) = j;
                elseif stat(lastSure(i))==1 && price(j)>price(lastSure(i))
                    stat(j) = 1;
                    lastSure(i) = j;
                end
            end
        end
        
        %local low
        if leftStat(j)==-1 && price(i)/price(j)>=1+mu_up
            flag = 1;
            for m=j:i-1
                for n=m+1:i
                    if price(m)/price(n)>=1+mu_down
                        flag = 0;
                        break;
                    end
                end
                if flag==0
                    break;
                end
            end
            if flag == 1
                if lastSure(i)==0 
                    stat(j) = -1;
                    lastSure(i) = j;
                elseif stat(lastSure(i))==1
                    stat(j) = -1;
                    lastSure(i) = j;
                elseif stat(lastSure(i))==-1 && price(j)<price(lastSure(i))
                    stat(j) = -1;
                    lastSure(i) = j;
                end
            end
        end
    end
    %更新左边状态
    lhigh = find(price(1:i-1)/price(i)<= 1/(1+mu_up), 1, 'last');
    if ~isempty(lhigh)
        flag = 1;
        for m=lhigh:i-1
            for n=m+1:i
                if price(m)/price(n)>=1+mu_down
                    flag = 0;
                    break;
                end
            end
            if flag == 0
                break;
            end
        end
        if flag== 1;
            leftStat(i) = 1;
        end
    end

    llow = find(price(1:i-1)/price(i)>= 1+mu_down, 1, 'last');
    if ~isempty(llow)
        flag = 1;
        for m=llow:i-1
            for n=m+1:i
                if price(n)/price(m)>=1+mu_up
                    flag = 0;
                    break;
                end
            end
            if flag == 0
                break;
            end
        end
        if flag== 1;
            leftStat(i) = -1;
        end
    end  
    
end

fivePoints = [];
points = zeros(1, 5);
iPeriod = find(lastSure ~= 0, 1, 'first');
if ~isempty(iPeriod)
    pcount = 1;
    points(1) = lastSure(iPeriod);
    while 1
        if pcount == 5
            fivePoints = [fivePoints; iPeriod, points];
        end
        iPeriod = iPeriod+find( lastSure(iPeriod+1:end)~=lastSure(iPeriod), 1,'first');
        if isempty(iPeriod)
            break;
        end

        if pcount == 5
            points(1:4) = points(2:5);
            pcount = 4;
        end
        if stat(points(pcount)) == stat(lastSure(iPeriod))
            points(pcount) = lastSure(iPeriod);
        else
            pcount = pcount + 1;
            points(pcount) = lastSure(iPeriod);
        end
        if points(pcount) - points(1) > wsize
            points(1:pcount-1) = points(2:pcount);
            pcount = pcount - 1;
        end
    end
    
end

%不输出则画图
if nargout == 0
    plotTrend(price, stat, lastSure, now);
end
end

function plotTrend(price, finalStat, lastSure, nPeriod)

last = 0;
maxmin = 0;
extrema = [];
for iPeriod = 1:lastSure(nPeriod)
    if last == 0 && finalStat(iPeriod)~= 0
        date = iPeriod;
        maxmin = price(date);
        last = finalStat(iPeriod);
        continue;
    end
    if finalStat(iPeriod) ~= last && finalStat(iPeriod) ~= 0
        extrema = [extrema; date];
        last = finalStat(iPeriod);
        date = iPeriod;
        maxmin = price(iPeriod);
    end
    
    if finalStat(iPeriod) == last && last == 1
        if price(iPeriod) > maxmin
            maxmin = price(iPeriod);
            date = iPeriod;
        end
    end
    if finalStat(iPeriod) == last && last == -1
        if price(iPeriod) < maxmin
            maxmin = price(iPeriod);
            date = iPeriod;
        end
    end
end
if date>max(extrema)
    extrema = [extrema; date];
end
plot(1:nPeriod, price(1:nPeriod), extrema, price(extrema), 'o-');
end

