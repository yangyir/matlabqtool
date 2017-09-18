classdef QStrategy_IFqxtl < QStrategy
    %IFQXTL ���������࣬��IF�͹�Ʊ���������ռ�
    % �̸�
    
    properties
        
        % ָ���������ݵ�ָ��
        IFticks;
        stockTicks; % 300*1 Ticksָ��
        indexTicks;
        
        % �ϳ�index
        stockWeight;  % 300*1
        stockTradable;  % 300*1,  0��1
        stockQ;         % ��Ʊ��������Ӧһ��IF
        pseudoIndexTicks;  % Ticks��
        
        
        % ���޲�Ticks
        spreadTicks;
        
        
        % ����matrix
        stockProfile;  % ���½������ݣ� 300*M
        stockCodes;    % 300*1 cells
        profileHeaders;   % last, volume, askP1,askV1, bidP1,bidV1 ...
        preLatest;
        
        % 
        date;
        date2;
        
        % 
        log
        
        
    end
    
    % �����µ��õ�properties
    properties
        roundNo;
        combNo;
    end

    
    %% constructor
    methods
        function [obj] = QStrategy_IFqxtl(StrategyNo,StrategyName,InstrumentNum,InstrumentName, ...
                date, IFticks, stockTicks, indexTicks, stockCodes, stockWeight   )
           
            obj      = obj@QStrategy(StrategyNo,StrategyName,InstrumentNum,InstrumentName);
           
            
            obj.date    = datenum(date);
            obj.date2   = datestr(date, 'yyyy-mm-dd');       

            
            % �涨IFָ��
            obj.IFticks = IFticks;
            
            % ��ȡIF��Ϣ
            
            
            % ��ȡ����300��Ʊָ��
            obj.stockTicks = stockTicks; 
            
            
            % ��ȡ����300��Ʊ��Ϣ
            obj.indexTicks = indexTicks;
            
            % ����pseudoIndex����
            obj.pseudoIndexTicks = Ticks;
            
            % ����spreadTicks, ��
            obj.spreadTicks         = SpreadTicks(32400, obj.IFticks, obj.pseudoIndexTicks) ;
%             obj.spreadTicks.ticksA  = obj.IFticks;
%             obj.spreadTicks.ticksB  = obj.pseudoIndexTicks;
            
            %
            obj.stockWeight    = stockWeight;
            obj.stockCodes     = stockCodes;
            
            % ��������
            N = length(stockTicks);            
            obj.preLatest = zeros(size(stockTicks));
            obj.profileHeaders = {'last', 'a1','av1','b1','bv1','a2','av2','b2','bv2'};
            M = length(obj.profileHeaders);
            obj.stockProfile = zeros(N, M);
            
            % �ճ�������ÿ�� CSI300 ������*1Ԫ����Ӧ��Ʊ������δ��������
            % ��2400�㣨Ԫ����Ӧ�Ĺ�Ʊ��
            % ����5��IF����Ӧ5*300* obj.stockQ
            for i = 1:N
                tmp_preClose(i) = obj.stockTicks(i).preSettlement;
            end
            obj.stockQ = obj.stockWeight ./ tmp_preClose' * obj.indexTicks.preSettlement;
            
            
            
            % ����
            obj.roundNo = 1;
            obj.combNo = 1;
            
            %
            tmppath = 'V:\root\qtool\onGoing\qxtl\log';
            obj.log = fopen( [ tmppath '\log.txt' ] , 'w');
        end
    end
    
    
   
    %% ���Է���    
    methods
        function  runStrategy(obj)
            %% ����profile��spread
            obj.calcProfile;
            tm = obj.IFticks.time(obj.IFticks.latest);
            obj.calcPseudoIndex(tm);
            
            obj.spreadTicks.update;
            
            
            
            %% �鿴�۲�µ�
            stks = obj.spreadTicks;
            iftks = obj.IFticks;
            pstks = obj.pseudoIndexTicks;
            
            fprintf(obj.log, '%s: %7.1f - %7.2f = %6.4f\n', datestr(tm), iftks.last(iftks.latest), pstks.last(pstks.latest), stks.last(stks.latest));
                        
            % ���ݼ۲�����µ�
            enter_threshold = 0.05 * obj.IFticks.last(obj.IFticks.latest) * 4/52; 
            cond1 = stks.bidP(stks.latest,1) > enter_threshold ;
            cond2 = stks.askP(stks.latest,1) < 0;
            
            % ���в�λ�� ��ʱ��Ϊ1
            cond3 = 1 ;
            cond4 = 1;
            
            cond_open = cond1 & cond3;
            cond_close = cond2 & cond4;
            
            % ����spread
            if cond_open
                fprintf('���ղ�:');
                obj.stockOrder(1,5);
                obj.ifOrder(-1,5);
                
                % ��¼position�ͽ����λ����Ϊ�����Ĳο�       
                
                
                % �߹���һ����ϵ���Ҫ++
                obj.combNo  = obj.combNo  + 1;
            end
            
            
            
            if cond_close
                fprintf('ƽ�ղ�');
                obj.stockOrder(-1,5);
                obj.ifOrder(1,5);
                
                
                % �߹���һ����ϵ���Ҫ++����һ���غ���ɣ�Ҫ++
                obj.roundNo = obj.roundNo + 1;
                obj.combNo  = obj.combNo  + 1;
            end

            
            
            
        end
        
        function [obj] = stockOrder(obj, direction, IFquantity)
            % �ȼ���volume            
            q = IFquantity * 300 * obj.stockQ;
            q = round(q/100)*100;
            
            
            N = length(obj.stockTicks);

            for i = 1 : N
                
                ticks = obj.stockTicks(i);
                l   = ticks.latest;
                
                
                o = Signal;
                %
                if direction == 1 % ����ask1 
                    p = ticks.askP(l,1);
                elseif direction == -1 % ������bid1
                    p = ticks.bidP(l,1);
                end
                % �Լ۵�
                o.price     = p;
                o.volume    = q(i);  % ��
                o.direction = direction;
                o.instrumentID = ticks.code;  % ����
                % ����ǳ�������Ҫ˵��,Ĭ��Ϊ0
%                 o.cancelFlag;
                % ��������ί�к�
%                 o.cancelEntrustNo;
                % ��ƽ��ʶ
%                 o.offSetFlag;
                o.roundNo   = obj.roundNo;
                o.combNo    = obj.combNo; 
                
                
                % δ����i
                obj.order(i) = o;
            end
            
            % ���߷ŵ�������
%             obj.roundNo = obj.roundNo + 1;
%             obj.combNo  = obj.combNo  + 1;
        end
        
        
        function [obj] = ifOrder(obj, direction, IFquantity)

            q = IFquantity;
            
            N = length(obj.stockTicks);
            i = N + 1;
            
            
            
            ticks = obj.IFticks;
            l   = ticks.latest;
            
            
            o = Signal;
            %
            if direction == 1 % ����ask1
                p = ticks.askP(l,1);
            elseif direction == -1 % ������bid1
                p = ticks.bidP(l,1);
            end
            % �Լ۵�
            o.price     = p;
            o.volume    = q;  % IF ��
            o.direction = direction;
            o.instrumentID = ticks.code;  % ����
            % ����ǳ�������Ҫ˵��,Ĭ��Ϊ0
            %                 o.cancelFlag;
            % ��������ί�к�
            %                 o.cancelEntrustNo;
            % ��ƽ��ʶ
            %                 o.offSetFlag;
            o.roundNo   = obj.roundNo;
            o.combNo    = obj.combNo;
            
            
            % δ����i
            obj.order(i) = o;
            
        end
        
    end
    
    
    
    %% ���㺯�� 
    methods
        % ����pseudoIndex
       [obj] = calcPseudoIndex(obj, tm);               
        
        % ֻ�����µ�last��ask��bid
       [obj] = calcProfile(obj);
                    
        
        
        
        %% �����ֲ�Ticks
        function [obj] = calcSpreadTick(obj, tm)
            stks = obj.spreadTicks;
            
        end
        
        
    end
    
end

