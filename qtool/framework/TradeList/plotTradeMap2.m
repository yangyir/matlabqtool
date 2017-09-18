function plotTradeMap2(PTL,TsRes,price)

if PTL.rcdNum ==0
    disp('No Trade!');
    return;
end


%% 提取信息
dateRangeStr = [datestr(floor(TsRes.time(1)),'yyyymmdd') '__' datestr(floor(TsRes.time(end)),'yyyymmdd')];

%% 设置图表格式
% 设置价格坐标区间
priceTickArr =[1,2,5,10,20,50,100,200,500];
navTickArr = [10000,20000,50000,100000,200000];


priceHighLim = max(price);
priceLowLim = min(price);
priceRange = priceHighLim-priceLowLim;
priceTick = priceTickArr(find(priceTickArr<priceRange/6,1,'last'));
if isempty(priceTick)
    priceTick = priceTickArr(1);
end
priceHighLim = ceil((priceHighLim+priceRange*0.1)/priceTick)*priceTick;
priceLowLim = floor((priceLowLim-priceRange*0.1)/priceTick)*priceTick;

% 设置净值坐标区间
navHighLim = max(TsRes.cumPnlVec);
navLowLim = min(TsRes.cumPnlVec);

navRange = navHighLim-navLowLim;
navTick = navTickArr(find(navTickArr<navRange/6,1,'last'));
if isempty(navTick)
    navTick = navTickArr(1);
end
navHighLim = ceil((navHighLim+navRange*0.1)/navTick)*navTick;
navLowLim = floor((navLowLim-navRange*0.1)/navTick)*navTick;

% 设置x轴坐标长度
xMaxLim = floor(length(TsRes.time)*1.1);



[AX,hP,hNav]= plotyy(1:length(TsRes.time),price,1:length(TsRes.time),TsRes.cumPnlVec);

set(AX(1),'YLim',[priceLowLim,priceHighLim],'XLim',[0,xMaxLim],'YTick',priceLowLim:priceTick:priceHighLim,'Box','off');
set(AX(2),'YLim',[navLowLim,navHighLim],'XLim',[0,xMaxLim],'YTick',navLowLim:navTick:navHighLim);

set(hP,'LineWidth',1);
set(hNav,'LineWidth',2,'LineStyle','--');

legend([hP,hNav],{'Price','Nav'});
title(['Trade Map, ' dateRangeStr sprintf(', PNL:%6.2f',TsRes.cumPnlVec(end))]);
hold on;

%% 添加交易
for i = 1:2:PTL.rcdNum
    % 进入时间序号，以及进入价格
    try
        enterIdx = find(TsRes.time>=PTL.data(i,PTL.timeI),1,'first');
        enterPrice = PTL.data(i,PTL.priceI);
        plot(enterIdx,enterPrice,'*m');
        
        % 退出时间序号，以及退出价格
        closeIdx =  find(TsRes.time>=PTL.data(i+1,PTL.timeI),1,'first');
        closePrice = PTL.data(i+1,PTL.priceI);
        plot(closeIdx,closePrice,'*m');
    catch e
        disp(e);
    end
    
    
    % 标识进入点
    
    
    if PTL.data(i,PTL.directionI)==1
        txtStr = ['\color{cyan}' sprintf('%dL%d',PTL.data(i,PTL.strategyNoI),PTL.data(i,PTL.volumeI))];
    else
        txtStr = ['\color{cyan}' sprintf('%dS%d',PTL.data(i,PTL.strategyNoI),PTL.data(i,PTL.volumeI))];
    end
    
    text(enterIdx,enterPrice+1,txtStr);
    
    % 表示交易跨度，绿色盈利，红色亏损
    if PTL.data(i,PTL.pnlI)>0
        plot([enterIdx,closeIdx],[enterPrice,closePrice],'--g');
    else
        plot([enterIdx,closeIdx],[enterPrice,closePrice],':r');
    end
end
hold off;


txtStr1 = sprintf('   PNL    Price\n');
txtStr2 = sprintf('O  %-6d %7.2f\n',floor(TsRes.cumPnlVec(1)),price(1));
txtStr3 = sprintf('H  %-6d %7.2f\n',floor(max(TsRes.cumPnlVec)),max(price));
txtStr4 = sprintf('L  %-6d %7.2f\n',floor(min(TsRes.cumPnlVec)),min(price));
txtStr5 = sprintf('C  %-6d %7.2f\n',floor(TsRes.cumPnlVec(end)),price(end));
txtStr6 = sprintf('R  %-6d %7.2f\n',floor(max(TsRes.cumPnlVec)-min(TsRes.cumPnlVec)),max(price)-min(price));
txtStr = [txtStr1,txtStr2,txtStr3,txtStr4,txtStr5,txtStr6];

text(length(TsRes.time)/15,priceHighLim-priceRange/4,txtStr,'FontName','FixedWidth');


axes(AX(2));
txtStr = sprintf('nav:%d',round(TsRes.cumPnlVec(end)));
text(length(TsRes.cumPnlVec)*0.9,round(TsRes.cumPnlVec(end))+navTick/3,txtStr,'color','r');

end
