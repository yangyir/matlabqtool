classdef( Hidden = false,Sealed = false ) StockInfo < handle
    %StockInfo�Ź�Ʊ�Ĺ̶���Ϣ��ͨ��ֻ��һ����Ҳ�ɷŶ��
    %calcTau��Ҫ����T��currentDate����
    % ---------------------------------------------------------------------
    % �콭�� 20160304, first issue
    % �콭�� 20161226, ����getName ������������QuoteInfo����һ��
    
    properties(Access = public,Hidden = false)  
        % ������Ϣ
        code        = '000000';  % (@char,setter����) �ڻ�����,��ͬ '10000283'
        stockName@char = '������Ʊ';  % ��ͬ '���A',�ַ���
        market = 'sh';
        multiplier = 100;     % ��Լ����
    end
    
    %% ���캯�����������캯�������أ�
    methods(Hidden = true)
        % ���ƹ��캯��
        [ newobj ] = getCopy(obj);      
        
    end
    
    methods
        % ǿ������ת��������code����char
        function [obj] = set.code(obj, vin)
            % ǿ������ת��������code����char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);                        
            switch cl
                case {'double' }
%                     disp('ǿ������ת����optinfo.codeӦΪchar');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('��ֵʧ�ܣ�optinfo.codeӦΪchar');
                    return;
            end
            obj.code = vout;
        end
        
        function [self] = set.market(self, value)
            if(isa(value, 'char'))
                switch value
                    case {'SH','sH','Sh','sh','shanghai','Shanghai','1'}
                        self.market = 'sh';
                    case {'SZ', 'Sz', 'sZ', 'sz', 'shenzhen', 'Shenzhen', '2'}
                        self.market = 'sz'
                end
            end
        end
        
        function [name] = getName(obj)
            name = obj.stockName;
        end
    end
    
    %% ��������
    
    methods(Access = 'public', Static = false, Hidden = false)
        
        function fillStockInfo( self, code, stockName, market)            
            % ������Ϣ
            self.code = code;
            self.stockName = stockName;
            self.market = market;
        end
        
      
        %�����Ϣ(���ַ���)
        function [s] = infoLongstr(obj)
            
            % ��ͬ�� 10000239,50ETF3�¹�2200,call(510050),T=2016-03-12, K=2.3
            s = sprintf('%s,%s,T=%s', obj.code, obj.stockName,...
                datestr(obj.T));            
        end
     
    end
    
%% ---------------------static ����----------------------

    methods(Access = 'public', Static = true, Hidden = false)
    end
    
end


