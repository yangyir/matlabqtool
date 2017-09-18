function [acVal] = aco(HighPrice,LowPrice,nDay,mDay)
% accelerator oscillator 
% 输入 【数据】HighPrice, LowPrice （时间 X 股票矩阵）
%      【参数】nDay, mDay 快速和慢速移动平均回溯天数 （默认 5， 34）
% daniel 2013/4/16

% 预处理
if nargin <2, error('not enough input');end
if ~exist('nDay','var'), nDay = 5;  end
if ~exist('mDay','var'), mDay = 34; end

if nDay > mDay %避免快慢速日期输入错误
    temp = nDay; nDay = mDay; mDay = temp;
end

%  计算ac值
% AO = SMA(子午价, 5)-SMA(子午价, 34)
% AC = AO-SMA(AO, 5)

MedPrice = (HighPrice+LowPrice)/2;
ao = ind.ma(MedPrice,nDay,0) - ind.ma(MedPrice,mDay, 0);
acVal = ao - ind.ma(ao, nDay, 0);

end %EOF
 
