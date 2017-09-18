function [ ] = calcPosTs( obj, TL )
%calcPosTs ��TradeListת��Ϊ��һ��ʱ�����Ӧ�Ĳ�λʱ�����о���
% ����Ĺ����У������롣����9��20�Ľ��ף�9��00û�в�λ��10��00�в�λ��
% �������ֶ��뷽ʽ�������ʱ���������ģ�����Ҫ��ǰ���룬��Ϊ��ʱ��ʱ���ǲ������ġ�
% ����Ĭ��һ�����������Ŀ�ʼ�ͽ�����������һ��ʱ��Σ���һ���ʱ���Ĭ�ϵ��Ǵ���
% һ��ʱ��㡣

% ���䳬��20140701��V1.0
% ���䳬��20140730��V2.0
%   1. �����˶Կ�TradeList�Ĵ���

%%
if TL.latest == 0
    return;
end

% ��tradeList�еĿհײ��ּ����������������д
TL.prune();

% ʱ����ĳ���Ӧ�ð���TradeList�����ʱ����
if TL.time(1)<obj.time(1)
    disp('ʱ������ڵ�һ�ʽ��ף�');
    return;
end

if TL.time(end)>obj.time(end)
    disp('ʱ����������һ�ʽ��ף�');
    return;
end

%%
% ��Լ����
numInstr = length(obj.instrType);
numTime = length(obj.time);
numItem = length(TL.time);

% �ȼ����־���
deltaPos = zeros(numTime,numInstr);


% findTimeIdx �����ʱ��һ��������ʹ�������Σ�����
% �������Ż��㷨������TL������sorted
instrIdxVec = zeros(numItem,1);
for i = 1:numItem
    instrIdxVec(i) = find(obj.instrType==TL.instrumentNo(i));
    TL.tick(i) = find(obj.time>=TL.time(i),1,'first');
end

% ������ѯ
for i = 1:numItem
    timeIdxCurr = TL.tick(i);
    instrIdxCurr = instrIdxVec(i);
    % �п�����һ��ʱ��̶��£�������ʽ���
    deltaPos(timeIdxCurr,instrIdxCurr) = deltaPos(timeIdxCurr,instrIdxCurr)+TL.volume(i)*TL.direction(i);
end

% �ۼƳ���λ
obj.posArr = cumsum(deltaPos);

% �����ֵ��λ
currPos = [zeros(size(obj.instrType));obj.posArr(1:end-1,:)];
obj.maxPosArr = currPos;
for i = 1:numItem
    timeIdxCurr = TL.tick(i);
    instrIdxCurr = instrIdxVec(i);
    currPos(timeIdxCurr,instrIdxCurr) = currPos(timeIdxCurr,instrIdxCurr)+TL.volume(i)*TL.direction(i);
    
    if abs(currPos(timeIdxCurr,instrIdxCurr))>abs(obj.maxPosArr(timeIdxCurr,instrIdxCurr))
        obj.maxPosArr(timeIdxCurr,instrIdxCurr) = currPos(timeIdxCurr,instrIdxCurr);
    end
end





end

