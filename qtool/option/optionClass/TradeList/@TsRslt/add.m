function [ ] = add(obj,obj2)

% ���䳬��20140812��V1.0
% ���䳬��20140812��V2.0
%    1. ����������instrType���Ȳ�һ�µ������

% �ȼ������������ʱ�������Ҳ����ͬ�ġ�
% �����ͬ����Ҫ�����⴦��

% ��Ϊ�Ѿ�������ˣ�����marginRate, multiplier, �ȾͲ���Ҫ�ˡ�

obj.initNav = obj.initNav + obj2.initNav;
obj.cumPnlVec       = obj.cumPnlVec+obj2.cumPnlVec;
obj.cumCmsnVec      = obj.cumCmsnVec+obj2.cumCmsnVec;
obj.frozenMarginVec = obj.frozenMarginVec+obj2.frozenMarginVec;

unionInstrType = union(obj.instrType,obj2.instrType);
idx1 = ismember(unionInstrType,obj.instrType);
idx2 = ismember(unionInstrType,obj2.instrType);
obj.instrType = unionInstrType;

if isempty(idx1)
    % 1�գ�ֱ�Ӹ���obj2
    obj = obj2;
elseif  ~isempty(idx2)
    % 2���գ���֮,����1��2������
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

