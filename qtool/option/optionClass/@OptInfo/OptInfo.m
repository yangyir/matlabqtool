classdef( Hidden = false,Sealed = false ) OptInfo < handle
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
    % �̸գ�20160302���޸ĺ�����setter��ʹT��currentDate�䶯ʱ������tau�ĸ���
    % �콭��20160320, ȥ���䶯T��currentDateʱ����tau����,�ֿ�������պ�����ʱ��tau��
    % cg��161017������iT��iK�� ���ڷ�������
    % �콭��20161226, ����getName()����������Quote���ͱ���һ�·�����
    % ���Ʒ� 20161229 �����ȡ������Լ���� [stockCode, startDate] = fetchOptCodeByFeature(CP, strike, ExpireDate);
    % ���Ʒ� 20170524 Ϊ���ܹ���ȡ��Ʒ��Ȩ��ԼOptCommodityInfo���޸���init_from_sse_excel��BUG
    % ���Ʒ� 20170613 ���Ӻ�Լ�Ƿ�Ϊ�ֺ�ǰ�ĺ�Լis_pre_dividend��[flag] = is_pre_dividend(obj)
    % �̸գ�20170708�� ��is_pre_dividend() ������������
    
    
    properties(Access = public,Hidden = false)  
        % ������Ϣ
        code        = '00000000';   % (@char,setter����) ��Ȩ����,��ͬ '10000283'
        optName@char = '������Ȩ';   % ��ͬ '50ETF3�¹�2200',�ַ���
        underCode   = '510050';     % (@char,setter����)��Ĵ���,��ͬ '510050'
        CP@char = 'call';           %��'call'��'put'��setter���ƣ�, �ɽ���'C', 'c', 'Call', 'call', 'CALL' OR 'P', 'p', 'put', 'Put', 'PUT'
        K@double = 2;               % ��Ȩִ�м۸�
        T = today + 100;            % (@double��setter����)�ɽ���string
        multiplier = 10000;         % ��Լ����
        
        % δ�طŽ����ı���
        % ��������,��ֵ�����ڣ��� today
        currentDate@double = today;           
        tau = 0;               % �껯ʣ��ʱ��, (T - currentDate)/365
        ST;                    % ���ڼ۸�
        payoff;                % ��Ȩ�ĵ��ڻر�

%%-----------------------------�������ر�����-----------------------------%%
        iT@double = 0;                   % ��M2TK�е�λ�ã����ڷ�����
        iK@double = 0;                   % ��M2TK�ֵ�λ�ã����ڷ�����   
%%-----------------------------δ�طŽ���-----------------------------%%
%         S;                     % ��ļ۸�ʵʱ����
%         M;                     % Moneyness; % (S/K)  �� ln(S/K)
%%-----------------------------δ�طŽ���-----------------------------%%
        
%%-----------------------------δ�طŽ���-----------------------------%%
%         num;                   % ��Լ����Ŀ
%         px;                    % ��Ȩ�ļ۸�ʵʱ����
%%-----------------------------δ�طŽ���-----------------------------%% 
    end
    
    %% ���캯�����������캯�������أ�
    
    methods(Hidden = true)
        
        % ���캯��
        function obj = OptInfo()     
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
        end
              
        % �����������ʱ���Զ�����tau
        function obj = set.currentDate(obj, value )
            obj.currentDate = value;
        end
        
        % ֻ��'call', 'put'
        function [obj] = set.CP(obj, value)
            switch value
                case {'C', 'c', 'Call', 'call', 'CALL', '�Ϲ�', '��',1 }
                    obj.CP = 'call';
                case {'P', 'p', 'put', 'Put', 'PUT', '�Ϲ�',  '��', 2}
                    obj.CP = 'put';
            end
        end
        
        % ǿ������ת��������code����char
        function [obj] = set.code(obj, vin)
            % ǿ������ת��������code����char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);                        
            switch cl
                case {'double' }
                   % disp('ǿ������ת����optinfo.codeӦΪchar');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('��ֵʧ�ܣ�optinfo.codeӦΪchar');
                    return;
            end
            obj.code = vout;
        end
        
        % ǿ������ת��������code����char
        function [obj] = set.underCode(obj, vin)
            % ǿ������ת��������code����char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);
            switch cl
                case {'double' }
                    % disp('ǿ������ת����optinfo.underCodeӦΪchar');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('��ֵʧ�ܣ�optinfo.underCodeӦΪchar');
                    return;
            end
            obj.underCode = vout;
        end
       % ǿ������ת��������code����char
        function [obj] = set.optName(obj, vin)
            % ǿ������ת��������code����char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);
            switch cl
                case {'double' }
                    % disp('ǿ������ת����optinfo.underCodeӦΪchar');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('��ֵʧ�ܣ�optinfo.underCodeӦΪchar');
                    return;
            end
            obj.optName = vout;
        end
        % Get�����Է���
        function [name] = getName(obj)
            name = obj.optName;
        end
    end

    
    %% ��������
    
    methods(Access = 'public', Static = false, Hidden = false)
        function [valid] = is_valid_opt(obj)
            % �ж��Ƿ����������Opt
            % [valid] = is_valid_opt()
            % optName@char = '������Ȩ';
            valid = ~strcmp(obj.optName, '������Ȩ');
        end
        
        function fillOptInfo( self, code, optName,underCode, T, K, CP)            
            % ������Ȩ��Ϣ
            self.code = code;
            self.optName = optName;
            self.underCode = underCode;
            self.T = T;
            self.K = K;
            self.CP = CP;   

%             self.calcTau;            
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
        
        % ����tau:�߾��ȼ��㵽����
        function [tau] = calcTau(obj, thisdate, calc_type)
            if ~exist('thisdate', 'var')
                thisdate = obj.currentDate;
            else
                obj.currentDate = thisdate;
            end
            
            if ~exist('calc_type', 'var')
                calc_type = 'trading';
            end
            % ����tau
            % tau = (datenum(obj.T) - datenum(thisdate)) / 365;
            switch calc_type
                case 'trading'
                    tau = obj.calcTradingTau(thisdate);
                case 'nature'
                    tau = obj.calcNatureTau(thisdate);
                otherwise
                    tau = obj.calcTradingTau(thisdate);
            end
            
            obj.tau = tau;
        end
        
        function [tau_trad] = calcTradingTau(obj, thisdatetime)
            % ���㽻���գ��߾��ȣ���������Сʱ�����ӵȡ�
            % ����tau
            if ~exist('thisdate', 'var')
                thisdatetime = obj.currentDate;
            else
                obj.currentDate = thisdatetime;
            end
            ct_obj = Calendar_Test.GetInstance();
            tau_trad = ct_obj.trading_days_precise_annualised(thisdatetime, obj.T);
        end
        
        function [tau_nat] = calcTauNatureTau(obj, thisdatetime)
            % ������Ȼ�գ��߾��ȣ���������Сʱ�����ӵȡ�
            if ~exist('thisdate', 'var')
                thisdatetime = obj.currentDate;
            else
                obj.currentDate = thisdatetime;
            end
            ct_obj = Calendar_Test.GetInstance();
            tau_nat = ct_obj.nature_days_precise_annualised(thisdatetime, obj.T);
        end
                
        % ��Ȩ�����Ϣ(���ַ���)
        function [s] = infoShortstr(obj)
            % ��ͬ��call[0.34, 2.2]         
            s = sprintf('%s{%0.2fy, %0.0f}', obj.CP, obj.tau, obj.K);
        end
        
        % ��Ȩ�����Ϣ(���ַ���)
        function [s] = infoLongstr(obj)
            % ���Ʒ壬20160403�������޸�
            % ��ͬ�� 10000239,50ETF3�¹�2200,call(510050),T=2016-03-12, K=2.3
            % 10000605,50ETF��5��2250,call(510050),T=20160525, K=2.25
            s = sprintf('%s,%s,%s(%s),T=%s, K=%0.2f', obj.code, obj.optName,...
                obj.CP, obj.underCode, datestr(obj.T,'yyyymmdd'), obj.K);
        end
        
        % �жϺ�Լ�Ƿ�Ϊ�ֺ�ǰ�ĺ�Լ
        function [ flag ] = is_pre_dividend(obj)
            % �жϺ�Լ�Ƿ�Ϊ�ֺ�ǰ�ĺ�Լ
            %����optName�ж��Ƿ����A
            % optName: '50ETF��1��2397A'
            
            flag    = false;
            optName = obj.optName;
            if optName(end) == 'A'
                flag = true;
            end
        end
        
        
    end
    
    %% �����������
    methods (Access = 'public')
        function [title] = to_excel_title(obj)
            flds = properties(obj);
            L = length(flds);
            for i = 1:L
                f = flds{i};
                title{i} = f;
            end
        end
        
        function [value_row] = to_excel_value(obj)
            flds = properties(obj);
            L = length(flds);
            for i = 1:L
                f = flds{i};
                value_row{i} = obj.(f);
            end
            
        end
        
        function [s] = println(obj)
            disp( obj.infoLongstr);
        end
    end
    
%% ---------------------static ����----------------------

    methods(Access = 'public', Static = true, Hidden = false)
        % ���Ͻ�������Ȩ�б��г�ʼ�����е�optinfo������һϵ��optinfo10000283
        [ oi, m2tkCallinfo, m2tkPutinfo ] = init_from_sse_excel( OptInfoXls );
        % demo
        demo;
        % ����������ȡ��ʷ��Լ����
        [stockCode, startDate, expireDate] = fetch_optCode_by_feature(CP, strike, ExpireDate);
    end
    
    
end