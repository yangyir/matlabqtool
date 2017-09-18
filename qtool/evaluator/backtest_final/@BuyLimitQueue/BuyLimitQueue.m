classdef BuyLimitQueue<handle
    %% �����޼۵�����
    % ������д�������޼۵��������źŷ�����ʱ�򣬱���ָ���޶��۸�Ȼ����ӡ�
    % ���Ӱ��޶��۸�Ӹߵ������С�
    % ���ӳ����Ժ�Ӧ����ʱ��������ָ������У�OrderQueue����
    % newOrder,executeOrder
    % order.time;
    % order.volume;
    % order.price;
    % order.liquidate
    %%
    properties
        orders;           % ָ�����
        head;             % ��һ��ָ���ڶ����е�λ��
        rear;             % ���һ��ָ��֮��һ��λ��
        totVolume;        % �����еľ��µ���
        liquidateLot;     % �����п��ֵ�����
        addLot;           % ������ƽ�ֵ�����
    end
    
    methods
        % ��ʼ��һ������Ϊ20�Ŀն��У����еĳ��ȿ�ʵʱ������
        function obj = BuyLimitQueue()
            obj.orders = cell(1,20);
            obj.head = 1;
            obj.rear = 1;
            obj.totVolume = 0;
            obj.liquidateLot = 0;
            obj.addLot = 0;
        end
        % ��ָ�����
        function add(obj,newOrder)
            lenQ = length(obj.orders);
            % ����ŵ���β����չ����
            if obj.rear==lenQ
                obj.orders = [obj.orders,cell(1,lenQ)];
            end
            
            % ����ǿն��У�ֱ�Ӳ��룻���򣬽��µ��Ӳ��뵽�޶��۸������
            % �޶��۸�����һ������֮������޶��۸���ڵ�һ�����ӣ�����
            % �����ס�
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
            
            % ���¶���״̬
            obj.rear = obj.rear+1;
            obj.totVolume = obj.totVolume+newOrder.volume;
            if newOrder.liquidate == 1
                obj.liquidateLot = obj.liquidateLot+abs(newOrder.volume);
            else
                obj.addLot = obj.addLot+abs(newOrder.volume);
            end

        end
        
        % ������ָ�����
        function executeOrder = pop(obj)
            if obj.rear==obj.head
                error('Order queue is empty!');
            end
            
            % ���¶���״̬
            executeOrder = obj.orders{obj.head};
            obj.totVolume = obj.totVolume-executeOrder.volume;
            if executeOrder.liquidate == 1
                obj.liquidateLot = obj.liquidateLot-abs(executeOrder.volume);
            else
                obj.addLot = obj.addLot-abs(executeOrder.volume);
            end
            obj.head = obj.head+1;
            % �������Ԫ���ŵ��˶����е�֮�󣬽����е�ǰ�벿�ֽ�ȥ
            lenQHalf = length(obj.orders)/2;
            if obj.head>lenQHalf
                numCut = floor(lenQHalf);
                obj.orders = obj.orders(numCut+1:end);
                obj.head = obj.head-numCut;
                obj.rear = obj.rear-numCut;
            end
        end
        
        % �ж��Ƿ�ն�
        function flag = orderEmpty(obj)
            flag = 0;
            if obj.head==obj.rear
                flag = 1;
            end
        end
        
        % �����е�һ�����ӵ��޶��۸�
        function orderPrice = firstOrderPrice(obj)
            if obj.head==obj.rear
                orderPrice = 0;
            else
                orderPrice =obj.orders{obj.head}.price;
            end
        end
    end
    
end
