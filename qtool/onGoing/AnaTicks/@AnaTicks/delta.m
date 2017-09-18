
function deltavalue = delta(Ticks1,Ticks2,AdjustMethod)
% delta   计算两个资产的散点图，线性拟合
% inputs;
%   Ticks1: 资产1的Ticks数据
%   Ticks2：资产2的Ticks数据
%   AdjustMethod： 数据调整方式
%   -- 1    线性插值,等值外插
%   -- 11	线性插值，取unique
%   -- 2    上一个非零值作为当前值
%   -- 21	上一个非零值作为当前值，取unique
%   -- 3    求Stock序列与Call序列在一定窗口内的交集
%   -- 31   求Stock序列与Call序列在一定窗口内的交集,取unique
% 2014.06.03; hu,yi
% 2014.6.3, luhuaibao, 输出，检查，调整画图


%% 参数设置
A1MinP = 0.01;  %资产1的最低价
A2MinP = 0.01;  %资产2的最低价
if ~exist('AdjustMethod','var')
    AdjustMethod = 31;
end
%% 数据载入
nA1Time = Ticks1.latest;  
A1Time = Ticks1.time(1:nA1Time);    
A1Price = Ticks1.last(1:nA1Time);
A1Vol = Ticks1.volume(1:nA1Time);
A1Name = Ticks1.code;

nA2Time = Ticks2.latest;
A2Time = Ticks2.time(1:nA2Time);
A2Price = Ticks2.last(1:nA2Time);
A2Vol = Ticks2.volume(1:nA2Time);
A2Name = Ticks2.code;


if isempty(A1Name)
    A1Name = '序列1';
end ;

if isempty(A2Name)
    A2Name = '序列2';
end ;


%% 数据预处理，去掉没有实际成交的tick数据
idx = find(diff(A1Vol))+1;
A1Time = A1Time(idx);
A1Price = A1Price(idx);
idx = find(diff(A2Vol))+1;
A2Time = A2Time(idx);
A2Price = A2Price(idx);

%% 取9:30 - 11:30,13:00-15:00之间的数据
t = datestr(A1Time(1));
t1 = datenum([t(1:12),'09:30:00']);
t2 = datenum([t(1:12),'11:30:00']);
t3 = datenum([t(1:12),'13:00:00']);
t4 = datenum([t(1:12),'15:00:00']);
idxS = (A1Time>=t1&A1Time<=t2) + (A1Time>=t3&A1Time<=t4);
idxC = (A2Time>=t1&A2Time<=t2) + (A2Time>=t3&A2Time<=t4);
A1Time = A1Time(idxS>0);
A1Price = A1Price(idxS>0);
A2Time = A2Time(idxC>0);
A2Price = A2Price(idxC>0);
Time = sort(union(A1Time,A2Time));
nTime = length(Time);
AdA1Price = zeros(nTime,1);
AdA2Price = zeros(nTime,1);
[~,idxS] = ismember(A1Time,Time);
AdA1Price(idxS) = A1Price;
[~,idxC] = ismember(A2Time,Time);
AdA2Price(idxC) = A2Price;

%% 数据插值选取
%-- 线性插值
if AdjustMethod == 1
    % 股票价格序列
    iBegin = find(AdA1Price>A2MinP,1,'first');
    AdA1Price(1:iBegin-1) = AdA1Price(iBegin);
    iEnd = find(AdA1Price>A2MinP,1,'last');
    AdA1Price(iEnd+1:end) = AdA1Price(iEnd);
    idx = find(AdA1Price);
    AdA1Price = interp1(idx,AdA1Price(idx),1:nTime);
    % Call Option序列
    iBegin = find(AdA2Price>A1MinP,1,'first');
    AdA2Price(1:iBegin-1) = AdA2Price(iBegin);
    iEnd = find(AdA2Price>A1MinP,1,'last');
    AdA2Price(iEnd+1:end) = AdA2Price(iEnd);
    idx = find(AdA2Price);
    AdA2Price = interp1(idx,AdA2Price(idx),1:nTime);
end

if AdjustMethod == 11
    % 股票价格序列
    iBegin = find(AdA1Price>A2MinP,1,'first');
    AdA1Price(1:iBegin-1) = AdA1Price(iBegin);
    iEnd = find(AdA1Price>A2MinP,1,'last');
    AdA1Price(iEnd+1:end) = AdA1Price(iEnd);
    idx = find(AdA1Price);
    AdA1Price = interp1(idx,AdA1Price(idx),1:nTime);
    % Option序列
    iBegin = find(AdA2Price>A1MinP,1,'first');
    AdA2Price(1:iBegin-1) = AdA2Price(iBegin);
    iEnd = find(AdA2Price>A1MinP,1,'last');
    AdA2Price(iEnd+1:end) = AdA2Price(iEnd);
    idx = find(AdA2Price);
    AdA2Price = interp1(idx,AdA2Price(idx),1:nTime);
    % 取unique去掉重复点
    AdA1Price = reshape(AdA1Price,length(AdA1Price),1);
    AdA2Price = reshape(AdA2Price,length(AdA2Price),1);
    A = [AdA1Price,AdA2Price];
    B = unique(A,'rows');
    AdA1Price = B(:,1);
    AdA2Price = B(:,2);
end
%-- 上一个非零值作为当前值
if AdjustMethod == 2
    % 股票价格序列
    iBegin = find(AdA1Price>A2MinP,1,'first');
    AdA1Price(1:iBegin-1) = AdA1Price(iBegin);
    for t = 1:nTime
        if AdA1Price(t) <= A2MinP
            AdA1Price(t) = AdA1Price(t-1);
        end
    end
    % Option序列
    iBegin = find(AdA2Price>A1MinP,1,'first');
    AdA2Price(1:iBegin-1) = AdA2Price(iBegin);
    for t = 1:nTime
        if AdA2Price(t) <= A1MinP
            AdA2Price(t) = AdA2Price(t-1);
        end
    end
end

if AdjustMethod == 21
    % 股票价格序列
    iBegin = find(AdA1Price>A2MinP,1,'first');
    AdA1Price(1:iBegin-1) = AdA1Price(iBegin);
    for t = 1:nTime
        if AdA1Price(t) <= A2MinP
            AdA1Price(t) = AdA1Price(t-1);
        end
    end
    % Option序列
    iBegin = find(AdA2Price>A1MinP,1,'first');
    AdA2Price(1:iBegin-1) = AdA2Price(iBegin);
    for t = 1:nTime
        if AdA2Price(t) <= A1MinP
            AdA2Price(t) = AdA2Price(t-1);
        end
    end
    % 取unique去掉重复点
    AdA1Price = reshape(AdA1Price,length(AdA1Price),1);
    AdA2Price = reshape(AdA2Price,length(AdA2Price),1);
    A = [AdA1Price,AdA2Price];
    B = unique(A,'rows');
    AdA1Price = B(:,1);
    AdA2Price = B(:,2);
end
%-- 求Call序列与Stock序列的在一定窗口值内的交集
if AdjustMethod == 3
    win = 5;
    nPoint = 0;
    for t = win+1:nTime-win
        if any(AdA1Price(t-5:t+5)>A2MinP) && any(AdA2Price(t-5:t+5)>A1MinP)
            nPoint = nPoint + 1;
            newTime(nPoint) = Time(t);
            idx = find(AdA1Price(t-5:t+5));
            [~,imin] = min(abs(idx-win-1));
            newP1(nPoint) = AdA1Price(t-6+idx(imin));
            idx = find(AdA2Price(t-5:t+5));
            [~,imin] = min(abs(idx-win-1));
            newP2(nPoint) = AdA2Price(t-6+idx(imin));
        end
    end
    Time = newTime;
    AdA1Price = newP1;
    AdA2Price = newP2;
end

if AdjustMethod == 31
    win = 10;
    nPoint = 0;
    for t = win+1:nTime-win
        if any(AdA1Price(t-5:t+5)>A2MinP) && any(AdA2Price(t-5:t+5)>A1MinP)
            nPoint = nPoint + 1;
            newTime(nPoint) = Time(t);
            idx = find(AdA1Price(t-5:t+5));
            [~,imin] = min(abs(idx-win-1));
            newP1(nPoint) = AdA1Price(t-6+idx(imin));
            idx = find(AdA2Price(t-5:t+5));
            [~,imin] = min(abs(idx-win-1));
            newP2(nPoint) = AdA2Price(t-6+idx(imin));
        end
    end
    Time = newTime;
    AdA1Price = newP1;
    AdA2Price = newP2;
    % 取unique去掉重复点
    AdA1Price = reshape(AdA1Price,length(AdA1Price),1);
    AdA2Price = reshape(AdA2Price,length(AdA2Price),1);
    A = [AdA1Price,AdA2Price];
    B = unique(A,'rows');
    AdA1Price = B(:,1);
    AdA2Price = B(:,2);
end

%% 计算作图
nPoint = length(AdA1Price);
figure;
%-- 一次拟合
% subplot(1,2,1);
scatter(AdA1Price,AdA2Price);
hold on
P1 = polyfit(AdA1Price,AdA2Price,1);
xl = xlim;
x = linspace(xl(1),xl(2));
y = polyval(P1,x);
plot(x,y,'r');
hold off
yl = get(gca,'ylim');
axis([xl(1) xl(2) yl]);
yfit = polyval(P1,AdA1Price);
R2 = norm(yfit-mean(AdA2Price))^2/norm(AdA2Price-mean(AdA2Price))^2;
% title([num2str(P1),'; R^2 = ',num2str(R2),';共',num2str(nPoint),'个点']);
title(['\Delta = ',num2str(P1(1)),'; R^2 = ',num2str(R2),'; 共',num2str(nPoint),'个点']);
xlabel(A1Name);
ylabel(A2Name);

deltavalue = P1(1) ; 

%-- 二次拟合
% subplot(1,2,2);
% scatter(AdA1Price,AdA2Price);
% hold on
% P2 = polyfit(AdA1Price,AdA2Price,2);
% x = xlim;
% x = x(1):0.01:x(2);
% y = polyval(P2,x);
% plot(x,y,'r');
% hold off
% yfit = polyval(P2,AdA1Price);
% R2 = norm(yfit-mean(AdA2Price))^2/norm(AdA2Price-mean(AdA2Price))^2;
% title([num2str(P2),'; R^2 = ',num2str(R2),';共',num2str(nPoint),'个点']);
% set(gcf,'unit','centimeters','position',[6 10 25 10]);

end