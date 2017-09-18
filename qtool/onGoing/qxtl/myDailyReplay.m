%% 双合约都用对价
% 应该是最劣势的策略了



%%
% DH;
% arrDt = DH_D_TR_MarketTradingday(3,'2014-07-18','2014-07-24');

savepath= 'D:\work\1.chenggang\跨期套利\IFticks\';
resultpath = 'D:\work\1.chenggang\跨期套利\result\';

% savepath= 'V:\1.chenggang\跨期套利\IFticks\';
% resultpath = 'V:\1.chenggang\跨期套利\result\';
%% 向硬盘上存ticks （ dh拿数据） 只用一次，以后隐去

DH

% sdt  = '2014-08-22';
% edt  = '2014-08-22';
% 
% % char matrix
% arrDt  = DH_D_TR_MarketTradingday(3,sdt,edt);


dt = '2014-08-21';

% 当日成分股
arrCode  = DH_E_S_IndexComps('000300.SH',dt,0);

% 当日权重根据前收盘价计算
arrWt   = DH_I_WT_ComponentWeight('000300.SH',arrCode,dt,1);

% 当日是否tradable
stkTradable = DH_D_TR_IsTradingDay(arrCode,dt);

% 从最当初就把不可交易的东西去掉
arrCode = arrCode(stkTradable==1);
arrWt   = arrWt(stkTradable == 1);
arrWt   = arrWt/ sum(arrWt);  % 重新归一化

% 当日成分股Ticks
for icd = 1:length(arrCode)
    code = arrCode{icd};
    a(icd) = Fetch.dhStockTicks(code, dt, 5);
end        

% 当日IF Ticks
IF0Ticks = Fetch.dhFutureTicks('IF1409', dt,1);

% 当日CSI300 Ticks
csi300Ticks = Fetch.dhStockTicks('000300.SH', dt);

% 储存
filename = ['mktdata_' dt];
save(filename, '*');






%%
tic
    

%% 行情数据load
% filename = ['mktdata_' dt];
% load(filename);

%% 记录和分析用


tl      = TradeList; % 全部对价单
tl.latest = 0;
tl2     = TradeList; % 更真实，记录IF0和IF1的成交情况
tl2.latest = 0;

    
%% 策略初始化，指针指向行情数据

StrategyNo      = 1;
StrategyName    = 'foo';
InstrumentNum   = length(a) + 1;
for i = 1:length(a)
    InstrumentName{i} = a(i).code;
end
InstrumentName{end+1} = IF0Ticks.code;


strat =QStrategy_IFqxtl(StrategyNo,StrategyName,InstrumentNum,InstrumentName, ...
    dt, IF0Ticks, a, csi300Ticks, arrCode, arrWt);


%% 开始循环
eod_tk = find( IF0Ticks.time-floor(IF0Ticks.time) > 15.2/24, 1, 'first');
for tk = 1:length(IF0Ticks.time)  %eod_tk
    %     tk
    
    %% 更新公共数据的latest，模拟真实交易
    IF0Ticks.latest = tk;
    tm = IF0Ticks.time(tk);
    
    for i = 1:length(a)
        tks = a(i);
        
        ftk = find(tks.time > tm, 1, 'first') - 1;
        if isempty(ftk)
            ftks.latest = 0;
        else
            ftks.latest = ftk;
        end
        
    end
    
    
    
    
    %%
    strat.runStrategy;
    
    
    %% 分析用： 如有交易，写入tradelist
    if ~isempty(strat.order{1}) || ~isempty(strat.order{2})
        
        fprintf('tk=%d',tk);
        % spread交易方向
        d = -strat.order{2}.buySell*2+3;
        
        % 远期合约 —— 买， 用ask
        tl2.latest  = tl2.latest+1;
        cur         = tl2.latest;
        tl2.instrumentCode(cur,:) = code2;
        tl2.instrumentNo(cur)   = 2;
        tl2.direction(cur)      = d;
        tl2.time(cur)           = tm;
        tl2.tick(cur)           = ftk;
        tl2.volume(cur)         = strat.order{2}.volume;
        tl2.price(cur)          = strat.order{2}.price;
        %          tl2.roundNo(cur)        = tl.roundNo(tl.latest);
        
        % 近期合约 —— 卖， 用bid
        tl2.latest  = tl2.latest+1;
        cur         = tl2.latest;
        tl2.instrumentCode(cur,:) = code1;
        tl2.instrumentNo(cur)   = 1;
        tl2.direction(cur)      = -d;
        tl2.time(cur)           = tm;
        tl2.tick(cur)           = ntk;
        tl2.volume(cur)         = strat.order{1}.volume;
        tl2.price(cur)          = strat.order{1}.price;
        %          tl2.roundNo(cur)        = tl.roundNo(tl.latest);
        
        
        % 写入基于spread的tradelist
        tl.latest = tl.latest + 1;
        cur = tl.latest;
        tl.direction(cur)   = d;
        tl.time(cur)        = tm;
        tl.tick(cur)        = tk;
        tl.volume(cur)      = 1;
        p_fns = strat.order{2}.price - strat.order{1}.price ;
        tl.price(cur)       = p_fns;
        
        fprintf(', dir=%2d, px_fns=%4.1f, netPos=%d\n', d, p_fns, strat.virtual_netPos);
    end
    
    %% 关闭策略（日末）
    if strat.runFlag	== 0
        break;
    end
end

tl.prune;
tl2.prune;

%% 输出
gross_pnl   = -sum(tl.price .* tl.volume .* tl.direction );
gross_pnl   = gross_pnl*300;
fee         = sum(tl2.volume) * 19;
net_pnl     = gross_pnl-fee;
fprintf('%s: %6.0f =%6.0f -%6.0f', thisDay,  net_pnl, gross_pnl, fee);
fprintf('( %4.1f * %d)\n', 19*4, sum(tl2.volume)/4);

%% 一日结束，分析tl2是否与原策略相同

datasave(isv).tl2  = tl2;
datasave(isv).tl   = tl;
datasave(isv).netPNL = net_pnl;
isv = isv +1;

% 删去数据，以免memory out
eval( ['clear ' varname1 ' ' varname2 ';'] );
toc





filename = ['qstrat_' code1 '_' code2 '_' sdt '_' edt ];
% save( [resultpath filename '.mat'], 'datasave');
pause;