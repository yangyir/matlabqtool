%% ˫��Լ���öԼ�
% Ӧ���������ƵĲ�����



%%
% DH;
% arrDt = DH_D_TR_MarketTradingday(3,'2014-07-18','2014-07-24');

savepath= 'D:\work\1.chenggang\��������\IFticks\';
resultpath = 'D:\work\1.chenggang\��������\result\';

% savepath= 'V:\1.chenggang\��������\IFticks\';
% resultpath = 'V:\1.chenggang\��������\result\';
%% ��Ӳ���ϴ�ticks �� dh�����ݣ� ֻ��һ�Σ��Ժ���ȥ

DH

% sdt  = '2014-08-22';
% edt  = '2014-08-22';
% 
% % char matrix
% arrDt  = DH_D_TR_MarketTradingday(3,sdt,edt);


dt = '2014-08-21';

% ���ճɷֹ�
arrCode  = DH_E_S_IndexComps('000300.SH',dt,0);

% ����Ȩ�ظ���ǰ���̼ۼ���
arrWt   = DH_I_WT_ComponentWeight('000300.SH',arrCode,dt,1);

% �����Ƿ�tradable
stkTradable = DH_D_TR_IsTradingDay(arrCode,dt);

% ������ͰѲ��ɽ��׵Ķ���ȥ��
arrCode = arrCode(stkTradable==1);
arrWt   = arrWt(stkTradable == 1);
arrWt   = arrWt/ sum(arrWt);  % ���¹�һ��

% ���ճɷֹ�Ticks
for icd = 1:length(arrCode)
    code = arrCode{icd};
    a(icd) = Fetch.dhStockTicks(code, dt, 5);
end        

% ����IF Ticks
IF0Ticks = Fetch.dhFutureTicks('IF1409', dt,1);

% ����CSI300 Ticks
csi300Ticks = Fetch.dhStockTicks('000300.SH', dt);

% ����
filename = ['mktdata_' dt];
save(filename, '*');






%%
tic
    

%% ��������load
% filename = ['mktdata_' dt];
% load(filename);

%% ��¼�ͷ�����


tl      = TradeList; % ȫ���Լ۵�
tl.latest = 0;
tl2     = TradeList; % ����ʵ����¼IF0��IF1�ĳɽ����
tl2.latest = 0;

    
%% ���Գ�ʼ����ָ��ָ����������

StrategyNo      = 1;
StrategyName    = 'foo';
InstrumentNum   = length(a) + 1;
for i = 1:length(a)
    InstrumentName{i} = a(i).code;
end
InstrumentName{end+1} = IF0Ticks.code;


strat =QStrategy_IFqxtl(StrategyNo,StrategyName,InstrumentNum,InstrumentName, ...
    dt, IF0Ticks, a, csi300Ticks, arrCode, arrWt);


%% ��ʼѭ��
eod_tk = find( IF0Ticks.time-floor(IF0Ticks.time) > 15.2/24, 1, 'first');
for tk = 1:length(IF0Ticks.time)  %eod_tk
    %     tk
    
    %% ���¹������ݵ�latest��ģ����ʵ����
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
    
    
    %% �����ã� ���н��ף�д��tradelist
    if ~isempty(strat.order{1}) || ~isempty(strat.order{2})
        
        fprintf('tk=%d',tk);
        % spread���׷���
        d = -strat.order{2}.buySell*2+3;
        
        % Զ�ں�Լ ���� �� ��ask
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
        
        % ���ں�Լ ���� ���� ��bid
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
        
        
        % д�����spread��tradelist
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
    
    %% �رղ��ԣ���ĩ��
    if strat.runFlag	== 0
        break;
    end
end

tl.prune;
tl2.prune;

%% ���
gross_pnl   = -sum(tl.price .* tl.volume .* tl.direction );
gross_pnl   = gross_pnl*300;
fee         = sum(tl2.volume) * 19;
net_pnl     = gross_pnl-fee;
fprintf('%s: %6.0f =%6.0f -%6.0f', thisDay,  net_pnl, gross_pnl, fee);
fprintf('( %4.1f * %d)\n', 19*4, sum(tl2.volume)/4);

%% һ�ս���������tl2�Ƿ���ԭ������ͬ

datasave(isv).tl2  = tl2;
datasave(isv).tl   = tl;
datasave(isv).netPNL = net_pnl;
isv = isv +1;

% ɾȥ���ݣ�����memory out
eval( ['clear ' varname1 ' ' varname2 ';'] );
toc





filename = ['qstrat_' code1 '_' code2 '_' sdt '_' edt ];
% save( [resultpath filename '.mat'], 'datasave');
pause;