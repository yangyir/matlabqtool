function [] = pairSI(obj,SIInfo)
% ���䳬��20140703��V1.0

% ���䳬��20140811��V2.0
%   1. ���ڲ���roundNo�ģ�ֱ�������ִ���

posQueue = java.util.ArrayDeque;

% ��һ�ʽ������ײ�
posQueue.add(SIInfo(1,:));
currDrctn = SIInfo(1,obj.directionI);
for i = 2:size(SIInfo,1)
    newTrade = SIInfo(i,:);
    if newTrade(obj.directionI)== currDrctn
        % ����
        posQueue.add(newTrade);
    else
        % ƽ��
        while(newTrade(obj.volumeI)>0)
            firstPos  = posQueue.peek();
            if isempty(firstPos)
                posQueue.add(newTrade);
                currDrctn = -currDrctn;
                break;
                % error('Pair Trade Error!');
            end
            
            obj.rcdNum = obj.rcdNum+2;
            if firstPos(obj.volumeI)<=newTrade(obj.volumeI)
                % ƽ���������ڵ��ڵ�һ����ƽ��λ
                % ���ֽ���
                obj.data(obj.rcdNum-1,1:obj.TLIdx) = firstPos;
                % ƽ�ֽ���
                obj.data(obj.rcdNum,1:obj.TLIdx) = newTrade;
                % ����ƽ������
                obj.data(obj.rcdNum,obj.volumeI) = firstPos(obj.volumeI);
                % ����ƽ������
                newTrade(obj.volumeI) = newTrade(obj.volumeI) - firstPos(obj.volumeI);
                % ȥ����ƽ��λ
                posQueue.poll();
                if posQueue.isEmpty()&&newTrade(obj.volumeI)>0
                    % ���ֵ�
                    newTrade(obj.offSetFlagI) =1;
                    % added QP,20150108
                    posQueue.add(newTrade);
                    currDrctn = -currDrctn;
                    break;
                end
            else
                % ƽ������С�ڵ��ڵ�һ����ƽ��λ
                % ���ֽ���
                obj.data(obj.rcdNum-1,1:obj.TLIdx) = firstPos;
                % ƽ�ֽ���
                obj.data(obj.rcdNum,1:obj.TLIdx) = newTrade;
                % ����ƽ������
                obj.data(obj.rcdNum-1,obj.volumeI) = newTrade(obj.volumeI);
                % ����ƽ������
                firstPos(obj.volumeI) = firstPos(obj.volumeI) - newTrade(obj.volumeI);
                % �޸ĳֲֶ�����ʣ������
                posQueue.poll();
                posQueue.addFirst(firstPos);
                
                newTrade(obj.volumeI)=0;
            end
            
        end
    end
end % for items

while ~posQueue.isEmpty()
    holdPos = posQueue.poll();
    stlmtPos = nan(size(holdPos));
    stlmtPos(obj.directionI) =  -holdPos(obj.directionI);
    stlmtPos(obj.volumeI) = holdPos(obj.volumeI);
    stlmtPos(obj.strategyNoI) = holdPos(obj.strategyNoI);
    stlmtPos(obj.instrumentNoI) = holdPos(obj.instrumentNoI);
    stlmtPos(obj.roundNoI) = holdPos(obj.roundNoI);

    obj.rcdNum = obj.rcdNum+2;
    % ���ֽ���
    obj.data(obj.rcdNum-1,1:obj.TLIdx) = holdPos;
    % ����ƽ�ֽ���
    obj.data(obj.rcdNum,1:obj.TLIdx) = stlmtPos;  
end

end % pairSI

