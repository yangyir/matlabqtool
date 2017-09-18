function [UpInd,DownInd,FluxInd] = ContinTrendIdentify(bars, tol1, uppercent, downpercent, tol2)
% by Yang Xi v1.0
% 利用连涨连跌和连续信号过滤器来进行趋势的划分
% bars 为趋势划分的对象
% tol1, uppercent, downpercent为调用ContinTrend所需要
% uppercent和downpercent参考0.02
% tol1 的参考值为一个交易日的单位时间数，如bars为分钟数据，tol1参考241
% tol2 为信号过滤函数ContinFilter有效信号要求的最短长度，如bars为分钟数据，tol2参考60
[upcount,downcount]=marketstatus.ContinTrend(bars, tol1, uppercent, downpercent);
UpInd = [];
for i = 1: length(upcount(:,1))
    UpInd = [UpInd upcount(i,2):upcount(i,3)];
end
DownInd = [];
for i = 1:length(downcount(:,1))
    DownInd = [DownInd downcount(i,2):downcount(i,3)];
end
FullInd = 1:length(bars.close);
FluxInd = setdiff(setdiff(FullInd, UpInd),DownInd); % 连涨连跌之外的序号为盘整序号
Fluxsignal = zeros(1, length(bars.close));
Fluxsignal(FluxInd) = 1;
FluxFiltLoc = marketstatus.ContinFilter(Fluxsignal,tol2); % 过滤掉盘整信号中的无效较短值
FluxInd = setdiff(FluxInd, FluxFiltLoc);
for i = 1:length(FluxFiltLoc)
    if ismember(FluxFiltLoc(i)-1,UpInd)
        UpInd = sort([UpInd FluxFiltLoc(i)]);
    end
    if ismember(FluxFiltLoc(i)-1,DownInd)
        DownInd = sort([DownInd FluxFiltLoc(i)]);
    end
end

end