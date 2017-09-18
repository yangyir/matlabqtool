function [reportTable] = genReportTable(obj,instrument)
% 为输出交易列表日报

obj.prune();
obj.reAdjustOpenClose();

reportTable = cell(obj.latest,7);
tradeNo =  (1:obj.latest)';
reportTable(:,1) = num2cell(tradeNo);
reportTable(obj.direction==1,2) = {'买'};
reportTable(obj.direction==-1,2) = {'卖'};
reportTable(obj.offSetFlag ==1,3) = {'开'};
reportTable(obj.offSetFlag ==-1,3) = {'平'};
reportTable(:,4) = num2cell(obj.volume);
reportTable(:,5) = num2cell(obj.price);
reportTable(:,6) = instrument(obj.instrumentNo+1);
reportTable(:,7) = cellstr(datestr(obj.time,'HH:MM'));
reportTable = [{'编号'},{'买卖'},{'开平'},{'数量'},{'价格'},{'合约'},{'时间'}; reportTable];
end