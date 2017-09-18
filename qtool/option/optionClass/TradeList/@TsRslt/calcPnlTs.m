function [  ] = calcPnlTs( obj, TL, price )
%CACLPNLTS �����ʽ���ص�ʱ������
% price ����ʱ�����Լ��Ӧ

% ���䳬��20140701��V1.0
% ���䳬��20140730��V2.0
%   1. �����˶Կ�TradeList�Ĵ���

%%
if TL.latest ==0
    return;
end
% ��Լ����
numInstr = length(obj.instrType);
numTime = length(obj.time);
numItem = length(TL.time);

% �ȼ���Ӷ��ͽ��׵Ĳ�־���
commission = zeros(numTime,numInstr);
tradePnl = zeros(numTime,numInstr);

% ������ѯ
for i = 1:numItem
    instrIdx = obj.instrType==TL.instrumentNo(i);
    timeIdx = TL.tick(i);
    % �п�����һ��ʱ��̶��£�������ʽ���
    if TL.tradeID(i)>0
        commission(timeIdx,instrIdx) = commission(timeIdx,instrIdx) +...
            TL.volume(i)*TL.price(i)*obj.multiplier(instrIdx)*obj.cmsnRate(instrIdx);
    end
    
    tradePnl(timeIdx,instrIdx) = tradePnl(timeIdx,instrIdx) + ...
        TL.volume(i)*(price(timeIdx,instrIdx)-TL.price(i))*TL.direction(i)*obj.multiplier(instrIdx);
end

% �ֲ�ӯ��
holdPnl = obj.posArr(1:end-1,:).*diff(price);
holdPnl = bsxfun(@times,holdPnl,obj.multiplier);
holdPnl = [zeros(size(obj.instrType));holdPnl];

obj.cumCmsnArr = cumsum(commission);
obj.cumPnlArr = cumsum(holdPnl+tradePnl)-obj.cumCmsnArr;

% �����ʽ��Ǹ�����ȷ��ֵ������ʱ����ڵ���߲�λ��ʱ��ε����̼ۼ���
obj.frozenMarginArr = abs(obj.maxPosArr).*price;
obj.frozenMarginArr = bsxfun(@times,obj.frozenMarginArr,obj.multiplier.*obj.marginRate);

% ����2����
obj.cumPnlVec = sum(obj.cumPnlArr,2);
obj.cumCmsnVec = sum(obj.cumCmsnArr,2);
obj.frozenMarginVec = sum(obj.frozenMarginArr,2);

% ���Ƴ�ʼ�ʽ�
if obj.initNav ==0
    obj.initNav = max(obj.frozenMarginVec)*2;
end

% �����������
obj.calcRNR();

end

