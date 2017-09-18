function addNewItem(obj,newTrade)
% �¼�һ�У�
% addNewItem(obj,newTrade)
% newTrade�ǽṹ�壬
%�����䳬, 20140812, V1.0

global instrumentCode;

obj.latest  = obj.latest+1;
idx         = obj.latest;
obj.direction(idx)    = str2double(newTrade.direction);
obj.offSetFlag(idx)   = str2double(newTrade.offSetFlag);
obj.price(idx)        = newTrade.price;
obj.volume(idx)       = newTrade.volume;
obj.time(idx)         = newTrade.tradeTime;
obj.tradeID(idx)      = newTrade.tradeID;
obj.entrustNo(idx)    = newTrade.entrustNo;
obj.strategyNo(idx)   = newTrade.strategyNo;
obj.orderRef(idx)     = newTrade.orderRef;
obj.instrumentNo(idx) = instrumentCode(newTrade.instrumentID);
obj.roundNo(idx)      = newTrade.roundNo;
obj.combNo(idx)       = newTrade.combNo;

end