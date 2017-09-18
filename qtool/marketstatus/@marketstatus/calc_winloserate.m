function [winrate,loserate] = calc_winloserate(tradeList)
% By Zehui Wu 2013/7/3 version 1.0
% ���� ӯ������ռ�ܽ��׵ı���winrate��������ռ�ܽ��׵ı���loserate
tradeReturns = tradeList(:,1);
winnum = length(find(tradeReturns>0));
losenum = length(find(tradeReturns<0));
winrate = winnum/length(tradeReturns);
loserate = losenum/length(tradeReturns);
end