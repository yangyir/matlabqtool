function [dealarray] = load_deals_from_excel(deals_excel_file)
%function [dealarray] = load_deals_from_excel(deals_excel_file)
% ��ԭʼexcel�ļ�������deals������dealarray

dealarray = DealArray;
if ~exist('deals_excel_file', 'var')
    warning('�ļ�������');
    return;
end

% ��ȡExcel�ļ�
% ��ȡSheet1 : �ͻ��ɽ���ϸ
% '��������''Ӫҵ������''Ӫҵ��''�ͻ���''�ͻ�����''������''Ʒ��''������'    '�ɽ�����''ÿ������''�ɽ��۸�''�ɽ�����''�ɽ����''������־''Ͷ����־''��ƽ��־''������''�Ͻ�������''����������''���ӷ�1''���ӷ�2''�ɽ�ʱ��''ǿƽ��־'
[~, ~, dealinfo] = xlsread( deals_excel_file ,'�ͻ��ɽ���ϸ');
dealinfo( cellfun(  @(x)(~isempty(x) && isnumeric(x) && isnan(x)) , dealinfo ) ) = {''};
deals = strcmp( dealinfo(:, 12), 'ƽ��') | strcmp(dealinfo(:, 12), '����');
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
% ��ȡSheet2

end