classdef TEBase<handle
% TEBase 做为TradeList, EntrustList 的基类，实质上是一维的
% 属于稀疏矩阵一维化后的list
% 都是T*p矩阵，纵向时间，横向属性

% ----------------------------------
% 潘其超，20140618，V1.0
% 潘其超，20140725，V2.0：将eval表达式简化
% 潘其超，20140806，V3.0
%   1. 将vecNames修改为 headers。
%   2. 将extendTEB, addTEB, pruneTEB修改为 extend, add, prune. 相应的
%       TradeList和EntrustList中的这些函数可以删除。
% 程刚，20140806，V3.1
%   1. 加入toTable, toExcel 方法， 测试通过
% 潘其超，20140807，V3.2
%   1. 加入slctByStrategy，slctByItem，slctByInstr，sortByTime，
%       item2vec，vec2item，insertItem，copyItem方法。
% 潘其超，20140812，V3.2，加入rmvItem方法。
% 程刚，21050527，改写：把函数拿出去，逐一加注释；加getCopy()


    %%
    properties
        
        capacity;   % 最大记录条目
        latest;     % 最后一条
        headers;    % 向量名称，用于生成data
        data;       % 矩阵形式的数据
        instrumentCode;   % 合约代码,map格式，提供instrumentNo与实际代码之间的对应关系。
        isSorted;   % 升序1， 降序 -1， 无序 0.
        
        %以下为N×1向量，每个向量代表记录的一条属性
        date;       % 日期， matlab 格式， 如735773
        date2;      % 日期，整形，如20140623
        time;       % 时间，matlab格式，如735773.324
        time2;      % 整型时间 HHMMSSFFF
        tick;       % 时间对应的tick号
        strategyNo; % 策略编号，整数
        direction;  % 买卖方向，buy = 1; sell = -1;
        offSetFlag; % 开平性质, open = 1; close = -1;
        volume;     % 数量
        price;      % 价格
        instrumentNo;   % 合约编号
        orderRef;   % 订单编号
        combNo;     % 组合编号
        roundNo;    % 回合编号
        entrustNo;  % 委托编号
        
        
        % 冗余，备用，万一有事记一下
        specialMark;
    end
    
    
    %% 原来写在里面的函数，现在写在外面
    methods(Access = 'public', Static = false, Hidden = false)
        [newObj] = slctByInstr(obj,instrNo);
        
        [] = extend(obj,addCapacity);
        
        [] = add(obj,obj2);
        
        % 剪去多余空间
        [] = prune(obj);
        
        %
        [newObj ] = slctByStrategy(obj,sNo)
        
        
        [newObj] = slctByItem(obj,seqNo)
        
        
        [] = sortByTime(obj,mode)
        
        
        [itemVec] = item2vec(obj,seqNo)
        
        
        [] = vec2item(obj,vec,seqNo)
        % seqNo 是插入位置，只能整段插入。
        % 父类属性在先
        
        [] = insertItem(obj,obj2,seqNo,seqNo2)
        % 将obj2从seqNo2提取的记录，作为一个整体，插入到obj的seqNo处
        
        
        [] = copyItem(obj,obj2,seqNo,seqNo2)
        % 将obj2选定的记录copy到obj1相应位置，覆盖式的
        
        
        [] = rmvItem(obj, seqNo)
    end
    
    
    %%
    methods(Access = 'public', Static = false, Hidden = false)
        %% 构造函数，必须写在里面
        function obj = TEBase(capacity)
            % 初始化
            if nargin == 0
                capacity = 1000;
            end
            obj.capacity = capacity;
            obj.latest   = 0;
            obj.isSorted = 0;
            obj.headers  = {'date','date2','time','time2',...
                'tick','strategyNo','direction','offSetFlag',...
                'volume','price','instrumentNo','orderRef',...
                'combNo','roundNo','entrustNo','specialMark'};
            
            % data 在有必要的时候再使用，此处不做初始化
            
            
            for i = 1:length(obj.headers)
                obj.(obj.headers{i}) = zeros(capacity,1);
            end
        end
        
        
        
        % 因为是handle类，需要copy constructor，以免指针赋值
        [ newobj ]          = getCopy(obj);
        
        % 析构函数
        
        
        
        
        % 输出用
        [data, headers] = toTable(obj, headers);
        [ obj ]         = toExcel(obj, filename, sheetname);
    end
    
end

