classdef TradeList<TEBase
%TRADELIST 记录成交信息
% 向量记录应按照时间顺序，从小到大排序

% ------------------------------
% 潘其超，20140618，V.10
% 潘其超，20140701，V2.0
%   1.加入基本操作函数。
% 潘其超，20140710，V3.0
%   1.加入insertItem方法。
%   2.加入copyItem方法。
% 潘其超，20140725，V4.0
%   1. 加入headers，作为TradeList的所有向量域的头。
%   2. 加入了toTable, toExcel 方法。
%   3. 将eval函数修改为简洁形式。
%   4. 加入交易专用属性 updCPPItem
% 潘其超，20140806，V5.0
%   1. 删除headers，其已经在TEBase中存在。
%   2. 删除TLVecNames。
%   3. 修改构造函数TradeList
%   4. delete extend();
%   5. delete prune();
%   6. delete add();
% 程刚，140806，V5.1
%   1. 把toTable，toExcel函数移到父类TEBase中
% 潘其超，20140807，V5.2
%   1. 将slctByStrategy，slctByItem，slctByInstr，sortByTime，
%      item2vec，vec2item，insertItem，copyItem迁移到TEBase。
% 潘其超，20140812，V5.2
%   1. 加入addNewItem 方法。
%   1. 加入filterLocalTrade方法。
% 潘其超，20140814，V5.3
%   1. 加入了genReportTable，reAdjustOpenClose方法，输出日报时使用。
% 潘其超，20140918，V6.0
%   1. 删除了updCPPItem方法。
% 程刚，20150527，把函数移到外面
    
    %%
    properties
        % 以下均为N×1向量
        % 成交编号
        tradeID;
    end
    
    %%
    methods
        function obj = TradeList(capacity)
            % 潘其超，20140806，V2.0
            %   1. 修改初始化方式,向量的初始化，不通过基类完成。
            
            if nargin == 0
                capacity = 1000;
            end
            
            obj.capacity = capacity;
            obj.headers = [obj.headers, {'tradeID'}];
            
            for i = 1:length(obj.headers)
                obj.(obj.headers{i}) = zeros(capacity,1);
            end
        end
        
    end
    
    %% 交易专用
    methods
        
        % 新加一行
        addNewItem(obj,newTrade);
        
        filterLocalTrade(obj);
        
        [reportTable] = genReportTable(obj,instrument)
        % 为输出交易列表日报
        [] = reAdjustOpenClose(obj)
        % 重新调整开平
        
        
        
    end
    
end