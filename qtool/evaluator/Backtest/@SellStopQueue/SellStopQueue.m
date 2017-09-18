classdef SellStopQueue<handle
    %% 卖出止损单队列
    % 存放卖出止损单。交易信号发出的时候，必须指明限定价格，然后入队。
    % 单子按限定价格从高到低排列。
    % 单子出队以后，应加上时间戳后进入指令缓存序列（OrderQueue）。
    % newOrder,executeOrder
    % order.time;
    % order.volume;
    % order.price;
    % order.liquidate
    %%
    properties
        orders;           % 指令单队列
        head;             % 第一个指令在队列中的位置
        rear;             % 最后一个指令之后一个位置
        totVolume;        % 队列中的净下单量
        liquidateLot;     % 队列中开仓单总量
        addLot;           % 队列中平仓单总量
    end
    
    methods
        % 初始化一个长度为20的空队列，队列的长度可实时调整。
        function obj = SellStopQueue()
            obj.orders = cell(1,20);
            obj.head = 1;
            obj.rear = 1;
            obj.totVolume = 0;
            obj.liquidateLot = 0;
            obj.addLot = 0;
        end
        % 新指令单进队
        function add(obj,newOrder)
            lenQ = length(obj.orders);
            % 如果排到队尾，扩展队列
            if obj.rear==lenQ
                obj.orders = [obj.orders,cell(1,lenQ)];
            end
            % 如果是空队列，直接插入；否则，将新单子插入到限定价格大于其
            % 限定价格的最后一个单子之后。如果限定价格大于第一个单子，插入
            % 到队首。
            if obj.head == obj.rear
                obj.orders{obj.rear} = newOrder;
            else
                for i = 1:obj.rear-obj.head
                    currLoc = obj.rear-i;
                    if(newOrder.price>obj.orders{currLoc}.price)
                        obj.orders{currLoc+1}=obj.orders{currLoc};
                        if currLoc ==obj.head
                            obj.orders{currLoc}=newOrder;
                        end
                    else
                        obj.orders{currLoc+1}=newOrder;
                        break;
                    end
                end
            end 
            % 更新队列状态
            obj.rear = obj.rear+1;
            obj.totVolume = obj.totVolume+newOrder.volume;
            if newOrder.liquidate == 1
                obj.liquidateLot = obj.liquidateLot+abs(newOrder.volume);
            else
                obj.addLot = obj.addLot+abs(newOrder.volume);
            end
        end
        
        % 将队首指令出队
        function executeOrder = pop(obj)
            if obj.rear==obj.head
                error('Order queue is empty!');
            end
            % 更新队列状态
            executeOrder = obj.orders{obj.head};
            obj.totVolume = obj.totVolume-executeOrder.volume;
            if executeOrder.liquidate == 1
                obj.liquidateLot = obj.liquidateLot-abs(executeOrder.volume);
            else
                obj.addLot = obj.addLot-abs(executeOrder.volume);
            end
            obj.head = obj.head+1;
            % 如果队首元素排到了队列中点之后，将队列的前半部分截去
            lenQHalf = length(obj.orders)/2;
            if obj.head>lenQHalf
                numCut = floor(lenQHalf);
                obj.orders = obj.orders(numCut+1:end);
                obj.head = obj.head-numCut;
                obj.rear = obj.rear-numCut;
            end
        end
        % 判断是否空队
        function flag = orderEmpty(obj)
            flag = 0;
            if obj.head==obj.rear
                flag = 1;
            end
        end
        % 队列中第一个单子的限定价格
        function orderPrice = firstOrderPrice(obj)
            if obj.head==obj.rear
                orderPrice = 0;
            else
                orderPrice =obj.orders{obj.head}.price;
            end
        end
    end
    
end

