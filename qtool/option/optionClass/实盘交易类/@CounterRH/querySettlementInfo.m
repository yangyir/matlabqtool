function [] = querySettlementInfo(self, date_num, file_path)
%function [] = querySettlementInfo(self, date_num, file_path)
% 此函数请求该账户某日的结算单，并指定存储目录路径
% 朱江， 2017.2.28
% date_num matlab 的日期数字，类型为double
% file_path 保存结算单的目录路径
if ~exist('date_num', 'var')
    date_num = today-1;
end

if ~exist('file_path', 'var')
    file_path = './';
end

trade_day_str = datestr(date_num, 'yyyymmdd');
rh_counter_querysettleinfo(self.counterId, trade_day_str, file_path);

end