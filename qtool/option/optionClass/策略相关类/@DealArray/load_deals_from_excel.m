function [dealarray] = load_deals_from_excel(deals_excel_file)
%function [dealarray] = load_deals_from_excel(deals_excel_file)
% 从原始excel文件中载入deals，构造dealarray

dealarray = DealArray;
if ~exist('deals_excel_file', 'var')
    warning('文件不存在');
    return;
end

% 读取Excel文件
% 读取Sheet1 : 客户成交明细
% '交易日期''营业部代码''营业部''客户号''客户名称''交易所''品种''交割期'    '成交手数''每手数量''成交价格''成交数量''成交金额''买卖标志''投保标志''开平标志''手续费''上交手续费''留存手续费''附加费1''附加费2''成交时间''强平标志'
[~, ~, dealinfo] = xlsread( deals_excel_file ,'客户成交明细');
dealinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , dealinfo ) ) = {''};
deals = strcmp( dealinfo(:, 12), '平仓') | strcmp(dealinfo(:, 12), '开仓');
dealinfo = dealinfo(deals, :);
colnum = size(dealinfo, 2);

dealarray = DealArray;
%L = size(dealinfo, 1);
L = 10500;
PatchL = 1000;
LL = mod(L, PatchL);
RL = fix(L/PatchL);

for kline = 1:RL
    fprintf('kline = %d', kline);
    tic
    for line = (kline-1)* PatchL + 1: kline * PatchL
        % for line = 1 : 100
        [date, exchange_name, instrument, settle_time, dealed_hands, multiplier, deal_price, deal_volume, deal_amount, direction, speculateflag, offset, commission, offer_commission, payback_commission, addtion_fee1, addition_fee2, deal_day_time, closeoutflag] = dealinfo{line, :};
        dealtimestr = strcat(date, deal_day_time);
        dealtimenum = datenum(dealtimestr, 'yyyymmddHH:MM:SS');
        deal = Deal;
        deal.instrument_ = instrument;
        deal.settle_time_ = settle_time;
        deal.name_ = strcat(instrument, settle_time);
        deal.direction_ = direction;
        deal.offset_ = offset;
        deal.price_ = deal_price;
        deal.volume_ = deal_volume;
        deal.amount_ = deal_amount;
        deal.time_ = dealtimenum;
        deal.fee_ = commission;
        
        dealarray.push(deal);
    end
    toc
end

tic
for line = RL * PatchL + 1: L
    % for line = 1 : 100
    [date, exchange_name, instrument, settle_time, dealed_hands, multiplier, deal_price, deal_volume, deal_amount, direction, speculateflag, offset, commission, offer_commission, payback_commission, addtion_fee1, addition_fee2, deal_day_time, closeoutflag] = dealinfo{line, :};
    dealtimestr = strcat(date, deal_day_time);
    dealtimenum = datenum(dealtimestr, 'yyyymmddHH:MM:SS');
    deal = Deal;
    deal.instrument_ = instrument;
    deal.settle_time_ = settle_time;
    deal.name_ = strcat(instrument, settle_time);
    deal.direction_ = direction;
    deal.offset_ = offset;
    deal.price_ = deal_price;
    deal.volume_ = deal_volume;
    deal.amount_ = deal_amount;
    deal.time_ = dealtimenum;
    deal.fee_ = commission;
    
    dealarray.push(deal);
end
toc
% 读取Sheet2

end