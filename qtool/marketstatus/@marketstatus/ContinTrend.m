function [upcount,downcount] = ContinTrend(bars, tol, uppercent, downpercent)
% v0.0 by Zehui Wu
% v1.0 by Yang Xi
% 通过连涨连跌来表现出市场的趋势状态
% tol表示可以容忍的反趋势个数
% uppercent表示连涨所要求的最低上涨率
% downpercent表示连跌所要求的最低下跌率
% 返回值 upcount downcount的第一列记录实际上涨或下跌天数（去除回撤）第二列记录趋势的起点 第三列记录趋势终点

open = bars.open;
close = bars.close;
ntotal = length(open);
% 计算每天的涨跌，涨用1表示，跌用-1表示。
updown = ones(ntotal,1);
updown(open>close) = -1;
i = 1;

% 第一列记录实际上涨/下跌天数（去除回撤）第二列记录趋势的起点 第三列记录趋势终点
upcount = zeros(ntotal, 3);
downcount = zeros(ntotal, 3);
iupcount = 1;
idowncount = 1;
while i <= ntotal
    tmpupnum = 0;%记录每个趋势的连涨的个数
    tmpdownnum = 0;%记录每个趋势的连跌的个数
    lastupnum = 0;
    lastdownnum = 0;
    if updown(i) == 1 % 若以上涨开始
        lastindex = i;
        j = i;
        while j<= ntotal
            nday = max(tol, round(tmpupnum+tmpdownnum)*0.4); % 让nday自适应变化
            if updown(j) == 1
                tmpupnum = tmpupnum+1;
            else
                tmpdownnum = tmpdownnum+1;
            end
            if updown(j) == 1 && tmpupnum > tmpdownnum && tmpdownnum <= nday && (close(j)-open(i))/open(i) > uppercent
                lastindex = j;
                lastupnum = tmpupnum;
            end
            if tmpdownnum > nday || j == ntotal
                if lastindex > i
                    upcount(iupcount, :) = [lastupnum i lastindex];
                    i = lastindex+1;
                    iupcount = iupcount+1;
                else 
                    i = i+1;
                end
                break;
            end
            j = j+1;
        end
    else
        nday = max(tol, round(tmpupnum+tmpdownnum)*0.4);
        lastindex = i;
        j = i;
        while j<= ntotal
            if updown(j) == 1
                tmpupnum = tmpupnum+1;
            else
                tmpdownnum = tmpdownnum+1;
            end
            if updown(j) == -1 && tmpupnum < tmpdownnum && tmpupnum <= nday && (open(i)-close(j))/open(i) > downpercent
                lastindex = j;
                lastdownnum = tmpdownnum;
            end
            if tmpupnum > nday || j == ntotal
                if lastindex > i
                    downcount(idowncount, :) = [lastdownnum i lastindex];
                    idowncount = idowncount+1;
                    i = lastindex+1;
                else
                    i = i+1;
                end
                break;
            end
            j = j+1;
        end
    end 
end
upcount = upcount(1:iupcount-1, :);
downcount = downcount(1:idowncount-1, :);
end
