function [] = reAdjustOpenClose(obj)
% ���µ�����ƽ

% ���䳬��20131121��V1.0
% ���䳬��20140814��V2.0
%����1. �����޶�����Ӧ�½ṹ��

currPos = zeros(obj.latest+1,1);

for i = 2:obj.latest+1
    if obj.direction(i-1)==1
        currPos(i) = currPos(i-1)+ obj.volume(i-1);
    else
        currPos(i) = currPos(i-1)- obj.volume(i-1);
    end
end

obj.offSetFlag(1:obj.latest) = -1*ones(obj.latest,1);

for i = 2:length(currPos)
    if currPos(i-1)>0
        if currPos(i)>currPos(i-1)
            obj.offSetFlag(i-1) = 1;
        end
    elseif currPos(i-1)<0
        
        if currPos(i)<=currPos(i-1)
            obj.offSetFlag(i-1) = 1;
        end
    else
        if currPos(i)~=0
            obj.offSetFlag(i-1)= 1;
        end
    end
end
end