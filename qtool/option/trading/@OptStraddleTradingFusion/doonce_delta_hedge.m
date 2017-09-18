function success = doonce_delta_hedge( obj, opt_delta, biaodi_delta, pct, competitor_rank)
% ���ڵ�ǰ�ֲֵ�Delta����Delta�Գ�
% һ���԰��ն��ּ۽��в����µ�,ֱ���ɽ�Ϊֹ
% �������:opt_delta��Ȩ�ֲֵ�Delta, biaodi_delta����ʲ���Delta, pct�ǲ�λ�ֲ�delta�İٷֱ�
% ע��:book�����ĵ�PNL�ȶ���������
% -------------------------------------------
% ���Ʒ� 20161116

if ~exist('pct' , 'var')
    pct = 99;
end
if ~exist('competitor_rank' , 'var')
    competitor_rank = 1;
end
assert(pct >= 0);
assert(ismember(competitor_rank , 1:5))
success = false;
fprintf('�µ�ǰ:��Ȩ�ֲ�Delta: %.2f, ���Delta: %.2f\r\n', opt_delta, biaodi_delta)

%% 1,Delta������׼��
counterS = obj.counterS;
bookS    = obj.bookS;
quoteS   = obj.quoteS;
strategy_delta = opt_delta + biaodi_delta;           % ��ǰ�����µ�Delta
makeup_delta   = -strategy_delta;                    % ��ǰ��Ҫ�ֲ���Delta
entrust_delta  = makeup_delta * pct/100;             % ί���µ���Delta
entrust_amount = round(abs(entrust_delta)/100)*100;  % ���ί���µ�������
if entrust_delta > 0 % ��Ҫ��Ŀ��ֵ�Delta
else                 % ��Ҫ���ƽ�ֵ�Delta[��Ҫ�鿴ƽ�ֵ����������Ƿ����]
    biaodi_amount = 0;
    biaodi_node   = bookS.positions.node;
    for node_t = 1:length(biaodi_node)
        biaodi_amount = biaodi_amount + biaodi_node(node_t).volume;
    end
    if biaodi_amount < entrust_amount
        fprintf('��Ҫ���ƽ�ֵ�Delta��������\r\n');
        return;
    end
end

%% 2,�����µ�����
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
    fprintf('��ļ۸�Ϊ0,�޷��µ�\r\n')
    return;
end

% ��Ľ���ί���µ�
one_e     = Entrust;
mktNo     = '1';
stockCode = quoteS.code;
stockName = quoteS.stockName;
one_e.fillEntrust(mktNo, stockCode, direc, entrust_px, entrust_amount, offset, stockName);
success = ems.place_entrust_and_fill_entrustNo(one_e, counterS);
if success
    bookS.pendingEntrusts.push(one_e);
else
    fprintf('Delta�Գ�:�µ�ʧ�� ���%s ��%d ��ƽ%s', stockCode, entrust_amount, direc)
    return;
end

% ��ѯ�ȴ��ٽ��г���
iter_wait = 0;
while iter_wait <= 11
    % ��ѯ
    ems.query_entrust_once_and_fill_dealInfo(one_e, counterS);
    % �ɽ�
    if one_e.is_entrust_closed
        break;
    end
    % ��ɨ
    bookS.sweep_pendingEntrusts;
    % ���г���
    if iter_wait >= 7
        ems.cancel_entrust_and_fill_cancelNo(one_e, counterS);
    end
    iter_wait = iter_wait + 1;
    pause(1)
end

%% 3,����������һ����Deltaֵ
biaodi_delta = 0;
success      = true;
biaodi_node  = bookS.positions.node;
for node_t = 1:length(biaodi_node)
    volume = biaodi_node(node_t).volume;
    longShortFlag = biaodi_node(node_t).longShortFlag;
    biaodi_delta  = biaodi_delta + longShortFlag * volume;
end
fprintf('�µ���:��Ȩ�ֲ�Delta��%.2f����ĳֲ�Delta��%.2f\r\n', opt_delta, biaodi_delta)











end
