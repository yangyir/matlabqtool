function [] = querySettlementInfo(self, date_num, file_path)
%function [] = querySettlementInfo(self, date_num, file_path)
% �˺���������˻�ĳ�յĽ��㵥����ָ���洢Ŀ¼·��
% �콭�� 2017.2.28
% date_num matlab ���������֣�����Ϊdouble
% file_path ������㵥��Ŀ¼·��
if ~exist('date_num', 'var')
    date_num = today-1;
end

if ~exist('file_path', 'var')
    file_path = './';
end

trade_day_str = datestr(date_num, 'yyyymmdd');
rh_counter_querysettleinfo(self.counterId, trade_day_str, file_path);

end