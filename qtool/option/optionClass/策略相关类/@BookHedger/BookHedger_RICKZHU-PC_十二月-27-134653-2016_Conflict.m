classdef BookHedger < BookMonitor
    % BookHedger ������һ��Monitor
    % ��Monitor�Ļ����ϣ��й�̨����Hedge�Ĺ���.
    % hedgers ��HedgerAssetElement�����У�ÿ��element����hedge��ĺ�hedge����
    properties
        counter_ = [];
        hedgers_@HedgeAssetElementArray;
    end
    
    methods
        function [obj] = BookHedger(book)
            obj = obj@BookMonitor(book);
            obj.counter_ = [];
            obj.hedgers_ = HedgeAssetElementArray;
        end
        
        function [obj] = attachCounter(obj, counter)
            obj.counter_ = counter;
        end
        
        function [obj] = attachHedger(obj, quote, direction, offset)
            hedger = HedgeAssetElement;
            hedger.initHedgeElement(quote).setDirection(direction).setOffsetFlag(offset);
            obj.hedgers_.push(hedger);
        end
        
        function [ret] = place_hedge_entrusts(obj)
            ret = obj.hedgers_.foreach_place;
        end
        
        function [ret] = query_hedge_entrust(obj)
            ret = obj.hedgers_.foreach_query;
        end
        
        function
        end
        
        function [ret, entrustArray] = generateHedgeEntrusts(obj)
            entrustArray = EntrustArray;
            ret = false;
            L = obj.hedgers_.count;
            for i = 1:L
                [result,e] = obj.hedgers_.node(i).generate_entrust;
                if result
                    ret = true;
                    entrustArray.push(e);
                end
            end            
        end
                
    end
end