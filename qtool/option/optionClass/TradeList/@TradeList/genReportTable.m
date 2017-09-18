function [reportTable] = genReportTable(obj,instrument)
% Ϊ��������б��ձ�

obj.prune();
obj.reAdjustOpenClose();

reportTable = cell(obj.latest,7);
tradeNo =  (1:obj.latest)';
reportTable(:,1) = num2cell(tradeNo);
reportTable(obj.direction==1,2) = {'��'};
reportTable(obj.direction==-1,2) = {'��'};
reportTable(obj.offSetFlag ==1,3) = {'��'};
reportTable(obj.offSetFlag ==-1,3) = {'ƽ'};
reportTable(:,4) = num2cell(obj.volume);
reportTable(:,5) = num2cell(obj.price);
reportTable(:,6) = instrument(obj.instrumentNo+1);
reportTable(:,7) = cellstr(datestr(obj.time,'HH:MM'));
reportTable = [{'���'},{'����'},{'��ƽ'},{'����'},{'�۸�'},{'��Լ'},{'ʱ��'}; reportTable];
end