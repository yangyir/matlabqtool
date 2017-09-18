function plotTradeMap2(dayTick,dayEL,dayT)

if dayEL.latest ==0
    disp('No Trade!');
    return;
end

dayTick.time2 = str2num(datestr(dayTick.time,'HHMMSSFFF'));

coreM = zeros(dayEL.latest,14);
numRound = max(dayEL.roundNo);
for i = 1:numRound
    idxTrade = find(dayEL.roundNo==i);
    idxOpen = idxTrade(1);
    idxClose = idxTrade(2);
    if length(idxTrade)>2
        disp('Well, well');
    end
    coreM(2*i-1,2) = dayEL.direction(idxOpen);
    coreM(2*i,2) = dayEL.direction(idxClose);
    coreM(2*i-1,3) = 1;
    coreM(2*i,3) = 2;
    coreM(2*i-1,4) = dayEL.volume(idxOpen);
    coreM(2*i,4) = dayEL.volume(idxClose);
    coreM(2*i-1,5) = dayEL.price(idxOpen);
    coreM(2*i,5) = dayEL.price(idxClose);
    coreM(2*i-1,7) = dayEL.time(idxOpen);
    coreM(2*i,7) = dayEL.time(idxClose);
    coreM(2*i-1,8) = dayT;
    coreM(2*i,8) = dayT;
    coreM(2*i-1,9) = dayEL.orderType(idxOpen);
    coreM(2*i,9) = dayEL.orderType(idxClose);
    coreM(2*i-1,11) =(dayEL.price(idxClose)-dayEL.price(idxOpen))*dayEL.direction(idxOpen)*dayEL.volume(idxOpen)*300;
    coreM(2*i-1,13) =  dayEL.time(idxClose)-dayEL.time(idxOpen);
    coreM(2*i-1,14) = dayEL.tick(idxOpen);
    coreM(2*i,14) = dayEL.tick(idxClose);
end

% dayNav = zeros(dayTick.latest,1);
[~,dayNav]= calcPosNav(dayTick,dayEL);

%% 提取信息
dateRangeStr = datestr(dayT,'yyyymmdd');

%% 设置图表格式
% 设置价格坐标区间
% priceTickArr =[1,2,5,10,20,50,100,200,500];
% navTickArr = [10000,20000,50000,100000,200000];
priceTickArr =[10,200];
navTickArr = [10000,100000];

priceHighLim = max(dayTick.last);
priceLowLim = min(dayTick.last);
priceRange = priceHighLim-priceLowLim;
priceTick = priceTickArr(find(priceTickArr<priceRange/6,1,'last'));
if isempty(priceTick)
    priceTick = priceTickArr(1);
end
priceHighLim = ceil((priceHighLim+priceRange*0.1)/priceTick)*priceTick;
priceLowLim = floor((priceLowLim-priceRange*0.1)/priceTick)*priceTick;

% 设置净值坐标区间
% navHighLim = max(dayNav);
% navLowLim = min(dayNav);
navHighLim = 1000;
navLowLim = 0;
navRange = navHighLim-navLowLim;
navTick = navTickArr(find(navTickArr<navRange/6,1,'last'));
if isempty(navTick)
    navTick = navTickArr(1);
end
navHighLim = ceil((navHighLim+navRange*0.1)/navTick)*navTick;
navLowLim = floor((navLowLim-navRange*0.1)/navTick)*navTick;

% 设置x轴坐标长度
xMaxLim = floor(length(dayTick.time)*1.1);



[AX,hP,hNav]= plotyy(1:length(dayTick.time),dayTick.last,1:length(dayTick.time),dayNav);

set(AX(1),'YLim',[priceLowLim,priceHighLim],'XLim',[0,xMaxLim],'YTick',priceLowLim:priceTick:priceHighLim,'Box','off');
set(AX(2),'YLim',[navLowLim,navHighLim],'XLim',[0,xMaxLim],'YTick',navLowLim:navTick:navHighLim);

set(hP,'LineWidth',1);
set(hNav,'LineWidth',2,'LineStyle','--');

legend([hP,hNav],{'Price','Nav'});
title(['Trade Map, ' dateRangeStr sprintf(', PNL:%6.2f',dayNav(end)-dayNav(1))]);
hold on;

%% 添加交易
for i = 1:2:size(coreM,1)
    % 进入时间序号，以及进入价格
    try
        enterIdx = coreM(i,14);
        enterPrice = coreM(i,5);
        plot(enterIdx,enterPrice,'*m');
        
        % 退出时间序号，以及退出价格
        closeIdx = coreM(i+1,14);
        closePrice = coreM(i+1,5);
        plot(closeIdx,closePrice,'*m');
    catch e
        disp(e);
    end
    
    
    % 标识进入点
    
    
    if coreM(i,2)==1
        txtStr = ['\color{cyan}' sprintf('%dL%d',coreM(i,1),coreM(i,4))];
    else
        txtStr = ['\color{cyan}' sprintf('%dS%d',coreM(i,1),coreM(i,4))];
    end
    
    text(enterIdx,enterPrice+1,txtStr);
    
    % 表示交易跨度，绿色盈利，红色亏损
    if coreM(i,11)>0
        plot([enterIdx,closeIdx],[enterPrice,closePrice],'--g');
    else
        plot([enterIdx,closeIdx],[enterPrice,closePrice],':r');
    end
end
hold off;


txtStr1 = sprintf('   PNL    Price\n');
txtStr2 = sprintf('O  %-6d %7.2f\n',floor(dayNav(1)),dayTick.last(1));
txtStr3 = sprintf('H  %-6d %7.2f\n',floor(max(dayNav)),max(dayTick.last));
txtStr4 = sprintf('L  %-6d %7.2f\n',floor(min(dayNav)),min(dayTick.last));
txtStr5 = sprintf('C  %-6d %7.2f\n',floor(dayNav(end)),dayTick.last(end));
txtStr6 = sprintf('R  %-6d %7.2f\n',floor(max(dayNav)-min(dayNav)),max(dayTick.last)-min(dayTick.last));
txtStr = [txtStr1,txtStr2,txtStr3,txtStr4,txtStr5,txtStr6];

text(length(dayTick.time)/15,priceHighLim-priceRange/4,txtStr,'FontName','FixedWidth');


axes(AX(2));
txtStr = sprintf('nav:%d',round(dayNav(end)));
text(length(dayNav)*0.9,floor(dayNav(end))+navTick/3,txtStr,'color','r');

end
