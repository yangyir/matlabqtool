function success = doonce_delta_hedge( obj, opt_delta, biaodi_delta, pct, competitor_rank)
% 基于当前持仓的Delta进行Delta对冲
% 一次性按照对手价进行操作下单,直到成交为止
% 输入参数:opt_delta期权持仓的Delta, biaodi_delta标的资产的Delta, pct是仓位弥补delta的百分比
% 注意:book计算标的的PNL等都存在问题
% -------------------------------------------
% 吴云峰 20161116

if ~exist('pct' , 'var')
    pct = 99;
end
if ~exist('competitor_rank' , 'var')
    competitor_rank = 1;
end
assert(pct >= 0);
assert(ismember(competitor_rank , 1:5))
success = false;
fprintf('下单前:期权持仓Delta: %.2f, 标的Delta: %.2f\r\n', opt_delta, biaodi_delta)

%% 1,Delta计算与准备
counterS = obj.counterS;
bookS    = obj.bookS;
quoteS   = obj.quoteS;
strategy_delta = opt_delta + biaodi_delta;           % 当前策略下的Delta
makeup_delta   = -strategy_delta;                    % 当前需要弥补的Delta
entrust_delta  = makeup_delta * pct/100;             % 委托下单的Delta
entrust_amount = round(abs(entrust_delta)/100)*100;  % 标的委托下单的数量
if entrust_delta > 0 % 需要标的开仓的Delta
else                 % 需要标的平仓的Delta[需要查看平仓的数量究竟是否足额]
    biaodi_amount = 0;
    biaodi_node   = bookS.positions.node;
    for node_t = 1:length(biaodi_node)
        biaodi_amount = biaodi_amount + biaodi_node(node_t).volume;
    end
    if biaodi_amount < entrust_amount
        fprintf('需要标的平仓的Delta数量不足\r\n');
        return;
    end
end

%% 2,进行下单操作
quoteS.fillQuote;
if entrust_delta > 0
    direc  = '1';
    offset = '1';
    switch competitor_rank
        case 1
            entrust_px = quoteS.askP1;
        case 2
            entrust_px = quoteS.askP2;
        case 3
            entrust_px = quoteS.askP3;
        case 4
            entrust_px = quoteS.askP4;
        case 5
            entrust_px = quoteS.askP5;
    end
else
    direc  = '2';
    offset = '2';
    switch competitor_rank
        case 1
            entrust_px = quoteS.bidP1;
        case 2
            entrust_px = quoteS.bidP2;
        case 3
            entrust_px = quoteS.bidP3;
        case 4
            entrust_px = quoteS.bidP4;
        case 5
            entrust_px = quoteS.bidP5;
    end
end
if abs(entrust_px) < 1e-6
    fprintf('标的价格为0,无法下单\r\n')
    return;
end

% 标的进行委托下单
one_e     = Entrust;
mktNo     = '1';
stockCode = quoteS.code;
stockName = quoteS.stockName;
one_e.fillEntrust(mktNo, stockCode, direc, entrust_px, entrust_amount, offset, stockName);
success = ems.place_entrust_and_fill_entrustNo(one_e, counterS);
if success
    bookS.pendingEntrusts.push(one_e);
else
    fprintf('Delta对冲:下单失败 标的%s 量%d 开平%s', stockCode, entrust_amount, direc)
    return;
end

% 查询等待再进行撤单
iter_wait = 0;
while iter_wait <= 11
    % 查询
    ems.query_entrust_once_and_fill_dealInfo(one_e, counterS);
    % 成交
    if one_e.is_entrust_closed
        break;
    end
    % 清扫
    bookS.sweep_pendingEntrusts;
    % 进行撤单
    if iter_wait >= 7
        ems.cancel_entrust_and_fill_cancelNo(one_e, counterS);
    end
    iter_wait = iter_wait + 1;
    pause(1)
end

%% 3,最终重新算一遍标的Delta值
biaodi_delta = 0;
success      = true;
biaodi_node  = bookS.positions.node;
for node_t = 1:length(biaodi_node)
    volume = biaodi_node(node_t).volume;
    longShortFlag = biaodi_node(node_t).longShortFlag;
    biaodi_delta  = biaodi_delta + longShortFlag * volume;
end
fprintf('下单后:期权持仓Delta：%.2f，标的持仓Delta：%.2f\r\n', opt_delta, biaodi_delta)











end
