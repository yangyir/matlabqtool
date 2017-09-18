function [ ] = add(obj,obj2)

% 潘其超，20140812，V1.0
% 潘其超，20140812，V2.0
%    1. 处理了两个instrType长度不一致的情况。

% 先假设两个对象的时间戳长度也是相同的。
% 如果不同，需要有特殊处理

% 因为已经计算过了，所以marginRate, multiplier, 等就不重要了。

obj.initNav = obj.initNav + obj2.initNav;
obj.cumPnlVec       = obj.cumPnlVec+obj2.cumPnlVec;
obj.cumCmsnVec      = obj.cumCmsnVec+obj2.cumCmsnVec;
obj.frozenMarginVec = obj.frozenMarginVec+obj2.frozenMarginVec;

unionInstrType = union(obj.instrType,obj2.instrType);
idx1 = ismember(unionInstrType,obj.instrType);
idx2 = ismember(unionInstrType,obj2.instrType);
obj.instrType = unionInstrType;

if isempty(idx1)
    % 1空，直接复制obj2
    obj = obj2;
elseif  ~isempty(idx2)
    % 2不空，加之,现在1，2都不空
    numTime = length(obj.time);
    numInstr = length(obj.instrType); 
    
    cmsnRate        = zeros(1,numInstr);
    marginRate      = zeros(1,numInstr);
    multiplier      = zeros(1,numInstr);
    cumPnlArr       = zeros(numTime,numInstr);
    posArr          = zeros(numTime,numInstr);
    cumCmsnArr      = zeros(numTime,numInstr);
    maxPosArr       = zeros(numTime,numInstr);
    frozenMarginArr = zeros(numTime,numInstr);

    cmsnRate(:,idx1)        = obj.cmsnRate;
    marginRate(:,idx1)      = obj.marginRate;
    multiplier(:,idx1)      = obj.multiplier;
    cumPnlArr(:,idx1)       = obj.cumPnlArr;
    posArr(:,idx1)          = obj.posArr;
    cumCmsnArr(:,idx1)      = obj.cumCmsnArr;
    maxPosArr(:,idx1)       = obj.maxPosArr;
    frozenMarginArr(:,idx1) = obj.frozenMarginArr;
    
    cmsnRate(:,idx2)        = obj2.cmsnRate;
    marginRate(:,idx2)      = obj2.marginRate;
    multiplier(:,idx2)      = obj2.multiplier;
    cumPnlArr(:,idx2)       = obj2.cumPnlArr      +cumPnlArr(:,idx2);
    posArr(:,idx2)          = obj2.posArr         +posArr(:,idx2);
    cumCmsnArr(:,idx2)      = obj2.cumCmsnArr     +cumCmsnArr(:,idx2);
    maxPosArr(:,idx2)       = obj2.maxPosArr      +maxPosArr(:,idx2);
    frozenMarginArr(:,idx2) = obj2.frozenMarginArr+frozenMarginArr(:,idx2);
    
    obj.cmsnRate        = cmsnRate;
    obj.marginRate      = marginRate;
    obj.multiplier      = multiplier;
    obj.cumPnlArr       = cumPnlArr;
    obj.posArr          = posArr;
    obj.cumCmsnArr      = cumCmsnArr;
    obj.maxPosArr       = maxPosArr;
    obj.frozenMarginArr = frozenMarginArr;
    
end

if ~isempty(obj.instrType)
    obj.calcRNR();
end

end

