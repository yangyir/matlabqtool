classdef( Hidden = false,Sealed = false ) FutureInfo < handle
    %FutureInfo���ڻ��Ĺ̶���Ϣ��ͨ��ֻ��һ����Ҳ�ɷŶ��
    %calcTau��Ҫ����T��currentDate����
    % ---------------------------------------------------------------------
    % �콭�� 20160304, first issue
    
    properties(Access = public,Hidden = false)  
        % ������Ϣ
        code        = '000000';  % (@char,setter����) �ڻ�����,��ͬ '10000283'
        futureName@char = '�����ڻ�';  % ��ͬ 'IH1603',�ַ���
        T = today + 100;            % (@double��setter����)�ɽ���string
        multiplier = 1;     % ��Լ����
        
        % ��������,��ֵ�����ڣ��� today
        currentDate@double = today;           
        tau = 0;               % �껯ʣ��ʱ��, (T - currentDate)/365
    end
    
    %% ���캯�����������캯�������أ�
    methods(Hidden = true)
        
        % ���캯��
        function obj = FutureInfo()     
            obj.currentDate = today;
        end
        
        % ���ƹ��캯��
        [ newobj ] = getCopy(obj);      
        
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
            
            % ����tau�ĸ���
            obj.calcTau;            
        end
        
        % �����������ʱ���Զ�����tau
        function obj = set.currentDate(obj, value )
            obj.currentDate = value;
            % ����tau�ĸ���
            obj.calcTau;            
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
        
        function fillFutureInfo( self, code, futureName, T)            
            % ������Ȩ��Ϣ
            self.code = code;
            self.futureName = futureName;
            self.T = T;               
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
        function [s] = infoLongstr(obj)
            
            % ��ͬ�� 10000239,50ETF3�¹�2200,call(510050),T=2016-03-12, K=2.3
            s = sprintf('%s,%s,T=%s', obj.code, obj.futureName,...
                datestr(obj.T));            
        end
     
    end
    
%% ---------------------static ����----------------------

    methods(Access = 'public', Static = true, Hidden = false)
    end
    
end


