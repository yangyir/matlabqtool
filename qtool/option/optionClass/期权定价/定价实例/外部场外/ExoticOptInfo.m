classdef( Hidden = false,Sealed = false ) ExoticOptInfo < handle
    %OPTINFO����Ȩ�Ĺ̶���Ϣ��ͨ��ֻ��һ����Ҳ�ɷŶ��
    %���㺯��calcPayoff��calcTau�ȿ������OptInfoҲ�������OptPricer
    %calcPayoff��Ҫ����K��ST����
    %calcTau��Ҫ����T��currentDate����
    % ---------------------------------------------------------------------
    % ���Ʒ壬20160120
    % ���Ʒ壬20160120��������һ��ʵʱ���µ���Ȩ�۸�px��һ�����㵽������ĺ���calcReturn
    % chenggang,20160121, ����static����init_from_sse_excel()
    % �̸գ�20160124������static����demo()
    % �̸գ�20160124���ı���calcPayoff(ST)��ʹ�ܹ����������ST
    % �̸գ�20160124�������˸��ƹ��캯��getCopy
    % �̸գ�20160202������properties�� @class �÷���������������
    % �̸գ�20160208������set.T, ��Ӧ��ͬ��������, char, cell(char), double
    % �̸գ�20160211������set.CP, ֻ������ֵ'call', 'put'
    % �̸գ�20160217��Լ��������code������char���Ա������
    
    properties(Access = public,Hidden = false)  
        
        % ������Ϣ
        code        = '00000000';  % (@char,setter����) ��Ȩ����,��ͬ '10000283'
        optName@char = '������Ȩ';  % ��ͬ '50ETF3�¹�2200',�ַ���
        T;                      % (@double��setter����)�ɽ���string
        multiplier = 10000;     % ��Լ����
        
        % δ�طŽ����ı���
        currentDate@double = today;           % ��������,��ֵ�����ڣ��� today
        tau = 0;               % �껯ʣ��ʱ��, (T - currentDate)/365
        ST;                    % ���ڼ۸�
        payoff;                % ��Ȩ�ĵ��ڻر�
                
    end
    
    %% ���캯�����������캯�������أ�
    
    methods(Hidden = true)
        
        % ���캯��
        function obj = ExoticOptInfo()     
            obj.currentDate = today;
        end
        
        % ���ƹ��캯��
        function new = copy(obj)
            % copy() is for deep copy case.
            new = feval(class(obj));
            % copy all non-hidden properties
            p = properties(obj);
            for i = 1:length(p)
                new.(p{i}) = obj.(p{i});
            end
        end        
    end
    
    methods
        
        % T��Ҫһ��setter������ʶ��string
        function [ obj ] = set.T(obj, value )
            % T��Ҫһ��setter������ʶ��string

            if isa(value, 'cell')
                [L1, L2] = size(value);
                dn = zeros(L1,L2);
                for i = 1:L1
                    for j = 1:L2
                        dn(i,j) = datenum( value{i,j} );
                    end
                end
            end
            if isa(value, 'char') 
                dn = datenum(value);
            end
            
            if isa(value, 'double')
                dn = value;
            end
            
            obj.T = dn;
            
        end
        
        
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
        
    end

    
    
    %% ��������
    
    methods(Access = 'public', Static = false, Hidden = false)
        
        function fillOptInfo( self, code, optName,T, CP)            
            % ������Ȩ��Ϣ
            self.code = code;
            self.optName = optName;
            self.underCode = underCode;
            self.T = T;
            self.K = K;
            self.CP = CP;   
            
            self.calcTau;            
        end
        
        % ���ڵ��ڼ۸����(�㵽���յ�payoff)
        function [ payoff ] = calcPayoff(obj, ST )            
            % ���ڵ��ڼ۸����(�㵽���յ�payoff)
            if ~exist('ST', 'var'), 
                ST = obj.ST; 
            else
                obj.ST = ST;
            end
            
            switch obj.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    payoff = max( ST - obj.K, zeros(size(ST)) );
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    payoff = max( obj.K - ST, zeros(size(ST))  );
             end   
            
             obj.payoff = payoff;             
        end
        
        % ר������MonteCarloPricer��payoff����
        function [payoff] = calcMCpayoff( obj, S)
            ST = S(:,end);
            switch obj.CP
                case {'call'}
                    payoff = max( ST - obj.K, 0 );
                case { 'put' }
                    payoff = max( obj.K - ST, 0  );
            end
        end
        
        % ����tau 
        function [tau] = calcTau(obj, thisdate)            
            % ����tau            
            if ~exist('thisdate', 'var') 
                thisdate = obj.currentDate;
            else
                obj.currentDate = thisdate;
            end
            
            % TODO��Ҫ����ͷ����漰���ڣ�str��double
            tau = ( obj.T - thisdate + 1 )/365;
            obj.tau = tau;
        end
        
        % ��Ȩ�����Ϣ(���ַ���)
        function [s] = infoShortstr(obj)
            
            % ��ͬ��call[0.34, 2.2]         
            s = sprintf('%s{%0.2fy, %0.0f}', obj.CP, obj.tau, obj.K);
            
        end
        
        % ��Ȩ�����Ϣ(���ַ���)
        function [s] = infoLongstr(obj)
            
            % ��ͬ�� 10000239,50ETF3�¹�2200,call(510050),T=2016-03-12, K=2.3
            s = sprintf('%s,%s,T=%s', obj.code, obj.optName,datestr(obj.T));
            
        end
     
    end
    
end


