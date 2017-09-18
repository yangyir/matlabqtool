function [ ticks, Sflag ] = dhOptionTicks(code, tday, levels)
%DHSTOCKTICKS 从DataHouse取Option Ticks数据，只能取一天
% [ ticks, Sflag ] = dhOptionTicks(code, tday, levels)
%     code:     需要是 8.2 形式，如10000602.SH
%     tday:     日期，聚源现可接受数字或文本，默认today-7
%     levels:   1或5，默认1
%
% eg. c = Fetch.dhOptionTicks('10000602.SH','2016-05-13')
% ======================================================================
% 程刚；161227；DH有问题，只有20160728之前的数据


%% default values
if ~exist('code','var')
    disp('取Ticks数据失败：没有code');
    Sflag = 0;
    return;
end

if ~exist('levels', 'var') , levels = 1; end

if ~exist('tday', 'var')
    tday = datestr(today-7, 'yyyy-mm-dd');
    disp(['请输入日期,否则默认为' tday]);
end


%% main
ticks = Ticks;

% 描述量
ticks.code = code;
ticks.levels = 0; %后面再改

% 自动识别文本格式和数字格式的日期
% datenum( 数字日期 ） 仍然是数字日期自身
% datestr( 文本日期 ） 仍然是文本日期自身
ticks.date = datenum(tday);
ticks.date2 = datestr(tday);

% 这个需要大改
ticks.type = 'option'; 


% 从聚源取数据，聚源可以接受数字和文本的时间
ticks.time = DH_Q_HF_Option('10000602.SH',tday,'BargainTime');
if isempty(ticks.time) || sum(isnan(ticks.time)) == length(ticks.time) %防止正常中含一个nan
    Sflag = 0;
    disp('取Tick数据失败');
    return;
end

ticks.latest = length(ticks.time);


% 数据    
ticks.last = DH_Q_HF_Option(code,tday,'ClosePrice');
ticks.amount = DH_Q_HF_Option(code,tday,'AccuBargainAmount');
ticks.volume = DH_Q_HF_Option(code,tday,'AccuBargainSum');

% 对于000300.SH 和 600000.SH，都是nan
% turnover = DH_Q_HF_Option(code,tday,'AccuTurnoverDeals');


% 标量
ticks.preSettlement = unique( DH_Q_HF_Option(code,tday,'PreSettlementPrice'));
ticks.dayVolume   = ticks.volume(ticks.latest);
ticks.dayAmount   = ticks.amount(ticks.latest);
ticks.open    = ticks.last(   find(~isnan(ticks.last),1,'first')  );
ticks.close   = ticks.last(   find(~isnan(ticks.last),1,'last')  );
ticks.high    = nanmax(ticks.last);
ticks.low     = nanmin(ticks.last);


switch levels
    case{ 1 }         
        ticks.bidP = DH_Q_HF_Option(code,tday,'Buy1Price');
        
        if isempty(ticks.bidP) || sum(isnan(ticks.bidP)) == length(ticks.bidP) 
            ticks.levels  = 0;
        else 
            ticks.bidV = DH_Q_HF_Option(code,tday,'Buy1Amount');
            ticks.askP = DH_Q_HF_Option(code,tday,'Sell1Price');
            ticks.askV = DH_Q_HF_Option(code,tday,'Sell1Amount');
            
            ticks.levels = 1;
        end
        
    case{ 5 }
        ticks.bidP = DH_Q_HF_Option(code,tday,{'Buy1Price','Buy2Price','Buy3Price','Buy4Price','Buy5Price'});
        ticks.askP = DH_Q_HF_Option(code,tday,{'Sell1Price','Sell2Price','Sell3Price','Sell4Price','Sell5Price'});
        ticks.bidV = DH_Q_HF_Option(code,tday,{'Buy1Amount','Buy2Amount','Buy3Amount','Buy4Amount','Buy5Amount'});
        ticks.askV = DH_Q_HF_Option(code,tday,{'Sell1Amount','Sell2Amount','Sell3Amount','Sell4Amount','Sell5Amount'});
        
        if isempty(ticks.bidP)
            ticks.levels = 0;
        end
end



%% 显示成功
str = sprintf('已取得%s在%s的level%d数据.',ticks.code, ticks.date2, ticks.levels );
disp(str);


end

