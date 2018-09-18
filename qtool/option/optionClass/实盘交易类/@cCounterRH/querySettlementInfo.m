function [] = querySettlementInfo(obj, date_num, file_path)
%cCounterRH
if ~exist('date_num', 'var')
    date_num = today-1;
end

if ~exist('file_path', 'var')
    file_path = './';
end

trade_day_str = datestr(date_num, 'yyyymmdd');

rh_counter_querysettleinfo(obj.counterId,trade_day_str,file_path);

end