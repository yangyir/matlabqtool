function [ ticks, Sflag ] = dhFutureTicks(code, tday, levels)
%DHFUTURETICKS 从DataHouse取Future Ticks数据，只能取一天
% [ tks, Sflag ] = dhFutureTicks(code, tday, levels)
%     code:       形同 'IF0Y00', 'IFhot' , 只能取一个，不支持向量
%     tday:       日期，接受文本或数字两种形式 
%     levels:     1或5，默认1
% ====================================================================
% 程刚；140611
% 程刚；140725；tday接受文本和数字两种形式
% 程刚；volume是股数，amount是元，之前反了



%% default values
if ~exist('code','var')
    disp('取Ticks数据失败：没有code');
    Sflag = 0;
    return;
end

% 把cell格式的code改成char
if isa(code, 'cell') 
    if length(code) > 1
        disp('警告：code不支持向量输入，只取第一个');
    end
    code = code{1};
end



if ~exist('levels', 'var') , levels = 1; end


%
if ~exist('tday', 'var')
    tday = datestr(today-7, 'yyyy-mm-dd');
    disp(['请输入日期,否则默认为' tday]);
end

% 把各种格式的tday都转成 yyyy-mm-dd (聚源接受的格式）
% if isa(tday, 'double') 
%     tday = datestr(tday, 'yyyy-mm-dd');
% elseif isa(tday, 'char')
%     tday = datestr( datenum(tday), 'yyyy-mm-dd');
% end

%% main
ticks = Ticks;

% 描述量
ticks.code = code;
ticks.levels = 0; %后面再改

% datenum( 数字日期 ） 仍然是数字日期自身
% datestr( 文本日期 ） 仍然是文本日期自身
ticks.date = datenum(tday);
ticks.date2 = datestr(tday);

% 这个需要大改
ticks.type = 'future'; 

% 从聚源取数据
ticks.time = DH_Q_HF_Future(code,tday,'BargainTime');
if isempty(ticks.time) || sum(isnan(ticks.time)) == length(ticks.time) %防止正常中含一个nan
    Sflag = 0;
    disp('取Tick数据失败');
    return;
end
% tks.time = tks.time + tks.date;

ticks.latest = length(ticks.time);

% 行情数据    
ticks.last    = DH_Q_HF_Future(code,tday,'ClosePrice');
ticks.amount  = DH_Q_HF_Future(code,tday,'AccuBargainSum');  % 元
ticks.volume  = DH_Q_HF_Future(code,tday,'AccuBargainAmount'); % 股、手
% DH_Q_HF_Future(code,tday,'AccuBargainSum');
ticks.openInt = DH_Q_HF_Future(code,tday,'OpenInterest');


% 标量
tmp = DH_Q_HF_Future(code,tday,'SettlementPrice');
ticks.settlement      = unique(  tmp(  ~isnan(tmp)  )  );
ticks.preSettlement   = unique( DH_Q_HF_Future(code,tday,'PreSettlementPrice'));
ticks.dayVolume   = ticks.volume(ticks.latest);
ticks.dayAmount   = ticks.amount(ticks.latest);
ticks.open        = ticks.last(   find(~isnan(ticks.last),1,'first')  );
ticks.close       = ticks.last(   find(~isnan(ticks.last),1,'last')  );
ticks.high        = nanmax(ticks.last);
ticks.low         = nanmin(ticks.last);


% bid，ask报价单
switch levels
    case{ 1 }         
        ticks.bidP = DH_Q_HF_Future(code,tday,'Buy1Price');
        
        if isempty(ticks.bidP) || sum(isnan(ticks.bidP)) == length(ticks.bidP) 
            ticks.levels  = 0;
        else 
            ticks.bidV = DH_Q_HF_Future(code,tday,'Buy1Amount');
            ticks.askP = DH_Q_HF_Future(code,tday,'Sell1Price');
            ticks.askV = DH_Q_HF_Future(code,tday,'Sell1Amount');
            
            ticks.levels = 1;
        end
        
    case{ 5 }
        ticks.bidP = DH_Q_HF_Future(code,tday,{'Buy1Price','Buy2Price','Buy3Price','Buy4Price','Buy5Price'});
        ticks.askP = DH_Q_HF_Future(code,tday,{'Sell1Price','Sell2Price','Sell3Price','Sell4Price','Sell5Price'});
        ticks.bidV = DH_Q_HF_Future(code,tday,{'Buy1Amount','Buy2Amount','Buy3Amount','Buy4Amount','Buy5Amount'});
        ticks.askV = DH_Q_HF_Future(code,tday,{'Sell1Amount','Sell2Amount','Sell3Amount','Sell4Amount','Sell5Amount'});
        
        if isempty(ticks.bidP)
            ticks.levels = 0;
        end
end



%% 显示成功
str = sprintf('已取得%s在%s的level%d数据.',ticks.code, ticks.date2, ticks.levels );
disp(str);



end

