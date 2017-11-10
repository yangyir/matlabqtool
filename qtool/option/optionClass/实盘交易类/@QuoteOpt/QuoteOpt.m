classdef QuoteOpt < OptInfo 
% ���ڴ�����飬�����ǽ������飬��Ȩר��
% ----------------------------------------
% cg��20160108  
% �ο��� 20160108
% cg, 20160121, ����Ȩ��̬��Ϣר���ó�����д��OptInfo�࣬����̳�OptInfo
%     ���У�T_t����Ϊtau
%     fillOptInfo��������OptInfo
% �̸գ�20160124�������˸��ƹ��캯��
% �̸գ�20160211������Static���� [ quote, m2tkCallQuote, m2tkPutQuote ] = init_from_sse_excel( OptInfoXls );
% ���Ʒ壬20160217��������marginһЩ��صĺ���
% ���Ʒ壬20160218������Wind���������ȡ�������������
% �̸գ�20160302��������������greeks����
%         [  ] = calc_ask_all_greeks( obj );
%         [  ] = calc_bid_all_greeks( obj );
%         [  ] = calc_last_all_greeks( obj );
% �콭��20160327, ��L2�����й���QuoteOpt;
% cg, 20160331�� ���һЩprint������δ���
% cg, 20160401, ���[sss] = println_risk_ask(tmp)�� [sss] = println_risk_bid(obj)
%       [��9��2150:ask]	1542	1	19.4%	 133.9	 267.8	 3.0	 12.0	 -4.7	 58.5       
% cg, 20160401, ��� [sss] = print_risk(tmp, pxType)
%       S = 2.1650  |  01-Apr-2016 15:10:06
%       optName	askpx	askQ	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
%       [��9��2150:ask]	1542	1	19.4%	 133.9	 267.8	 3.0	 12.0	 -4.7	 58.5
%       [��9��2150:bid]	1499	2	18.7%	 134.5	 268.9	 3.1	 12.4	 -4.6	 58.4
% �̸գ�20160402�� ���  print_pankou(quote)
% ���Ʒ壬20160403 ����  print_pankou2(quote)
% �ο�, 20160414���޸�����Ȩ����ֿ��ֱ�֤��ļ���( ����һ������preclose )
% �̸գ�20170104��rĬ��0.035
% �콭, 20170328, ��������r�ķ���
% �̸գ�201705�� print_risk ��ȥ�� 2%delta�� 2%gamma����ʵս����û��;��tmValue
% ���Ʒ� 20170524 Ϊ���ܹ���ȡ��Ʒ��Ȩ��ԼOptCommodityInfo���޸���init_from_sse_excel��BUG
% cg, 20170803, print_risk�У�����margin

%% ��̬����Ϣ
properties
    % ����Դ���ͣ�������CTP,�ɴ�
    srcType = '';
    % ����ԴID: Ĭ��Ϊ-1
    srcId = -1;
end
properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
%         code;  % ��Ȩ����,��ͬ 10000283,��ֵ��
%         optName; % ��ͬ '50ETF3�¹�2200',�ַ���
%         underCode;% ��Ĵ���,��ͬ 510050,��ֵ��
%         CP = 'call';  % 'C', 'c', 'Call', 'call', 'CALL' OR 'P', 'p', 'put', 'Put', 'PUT'
%         K; % ��Ȩִ�м۸�
%         T; % ��Ȩ����ʱ��,��ֵ�����ڣ���datenum('2016-1-27')
%         currentDate; % ��������,��ֵ�����ڣ��� today
%         tau;  % �껯ʣ��ʱ��    
        
        S@double = 0;                  % ��ļ۸�ʵʱ����
        M;                             % Moneyness;  K/S �� ln(K/S)
        M_tau;                         % M/sqrt(tau)
        M_shift;                       % (M_tau - (r - pow(sigma, 2)/2)*sqrt(tau))/sigma;
        Z;                             % M_shift/sigma;
        intrinsicValue;                % (S-K)+  �� (K-S)+
        timeValue@double = 0;          % ʱ���ֵ 
        timeValue_pct@double = 0;      % timeValue_percent : timeValue / S * 100%
        timeValue_pct_a@double = 0;    % timeValue_pct * 1/tau;
        r@double = 0.035;    % �޷�������        
        latest; % ����һ��        
    end
    
    
    %% ������Ϣ
    properties
       quoteTime;%     ����ʱ��(s)
       min;
       sec;
%        dataStatus;%    DataStatus	
%        secCode;%֤ȯ����	
%        accDeltaFlag;%ȫ��(1)/����(2)	
       preSettle;   %���ս����	
       preClose;
       etfpreClose; %��ƱETF��ǰ���̼�
       settle;      %���ս����	
       open; %���̼�	
       high; %��߼�	
       low;  %��ͼ�	
       last; %���¼�	
       last_pct; %last_percent: last/S * 100%
       last_pct_a; %last_percent_annualize: last_percent * 1/tau;
       close;%���̼�	
       refP; %��̬�ο��۸�	
       virQ; %����ƥ������	
       openInt;%��ǰ��Լδƽ����	
       bidQ1;%������1	
       bidP1;%�����1	
       bidQ2;%������2	
       bidP2;%�����2
       bidQ3;%������3	
       bidP3;%�����3	
       bidQ4;%������4	
       bidP4;%�����4	
       bidQ5;%������5	
       bidP5;%�����5	
       askQ1;%������1	
       askP1;%������1	
       askQ2;%������2	
       askP2;%������2	
       askQ3;%������3	
       askP3;%������3	
       askQ4;%������4	
       askP4;%������4	
       askQ5;%������5	
       askP5;%������5	
       volume = 0; %�ۼƳɽ�����	
       amount;     %�ۼƳɽ����	
%        rtflag;%��Ʒʵʱ�׶α�־	
%        mktTime;%�г�ʱ��(0.01s)
       diffVolume; %�ۼƳɽ�����������
       diffAmount; %�ۼƳɽ���������    
       pLevel = 5; %���鵵λ��Ŀ
    end
        
    %% ����ֵ
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
         % ��Щ��last����
        impvol@double = NaN;
        delta@double = NaN;
        gamma@double = NaN;
        vega@double = NaN;
        theta@double = NaN;
        rho@double = NaN;
        lambda@double = NaN;
        
        % ��Щ��ask��bid����
        askimpvol@double = NaN;
        askdelta@double = NaN;
        askgamma@double = NaN;
        askvega@double = NaN;
        asktheta@double = NaN;
        askrho@double = NaN;
        asklambda@double = NaN;
        
        bidimpvol@double = NaN;
        biddelta@double = NaN;
        bidgamma@double = NaN;
        bidvega@double = NaN;
        bidtheta@double = NaN;
        bidrho@double = NaN;
        bidlambda@double = NaN;
    end
    

    
    %% ���캯�������ƹ��캯��
    methods
        function [px] = get.preClose(obj)
            px = obj.preClose;
            if obj.preClose < 0.00001 && obj.preSettle > 0.00001
                px = obj.preSettle;
            end
        end
        
        function [px] = get.preSettle(obj)
            px = obj.preSettle;
            if obj.preSettle < 0.00001 && obj.preClose > 0.00001
                px = obj.preClose;
            end
        end
        
    end
    methods(Access = 'public', Hidden = true)
        % ���캯��
        function self = QuoteOpt()     
        end     
        [ newobj ] = getCopy( obj );
    end
    
    %% ������Ч�Ժ���
    methods(Access = 'public', Hidden = false)
        function [valid] = is_obj_valid(obj)
            valid = (~strcmp(obj.optName, '������Ȩ'));
        end
        
        function [valid] = is_quote_valid(obj)
            valid = (~isempty(obj.last) && ~isnan(obj.last) && (obj.last > 0)...
                && (obj.askP1 > 0.00001) && (obj.bidP1 > 0.00001) && (obj.askQ1 > 0) && (obj.bidQ1 > 0));
        end
    end
    %% 
    methods(Access = 'public', Static = false, Hidden = false)
        
        function mg = margin( self , calcMode )
            % ���ֱ�֤��
            % ��ͱ�׼
            % �Ϲ���Ȩ����ֿ��ֱ�֤��[��Լǰ�����+Max��12%����Լ���ǰ���̼�-�Ϲ���Ȩ��ֵ��7%����Լ���ǰ���̼ۣ�] ����Լ��λ
            % �Ϲ���Ȩ����ֿ��ֱ�֤��Min[��Լǰ�����+Max��12%����Լ���ǰ���̼�-�Ϲ���Ȩ��ֵ��7%����Ȩ�۸񣩣���Ȩ�۸�] ����Լ��λ
            % ά�ֱ�֤��
            % ��ͱ�׼
            % �Ϲ���Ȩ�����ά�ֱ�֤��[��Լ�����+Max��12%����Լ������̼�-�Ϲ���Ȩ��ֵ��7%����Լ������̼ۣ�]����Լ��λ
            % �Ϲ���Ȩ�����ά�ֱ�֤��Min[��Լ����� +Max��12%���ϱ�����̼�-�Ϲ���Ȩ��ֵ��7%����Ȩ�۸񣩣���Ȩ�۸�]����Լ��λ
            % ���У��Ϲ���Ȩ��ֵ=Max����Ȩ��-��Լ������̼ۣ�0��
            % �Ϲ���Ȩ��ֵ=max����Լ������̼�-��Ȩ�ۣ�0��
            % ���Ʒ壬������һ�����㱣֤��ķ�ʽ calcMode( �����֤��init��ά��keep��֤��ļ��� )
            
            if ~exist( 'calcMode' , 'var' ),calcMode = 'keep';end;
            if isfloat( calcMode ),calcMode = 'keep';end;
            if ~ismember( calcMode , { 'init','keep' } ),calcMode = 'keep';end;
            if isempty( self.etfpreClose ),calcMode = 'keep';end;
            if isnan( self.etfpreClose ),calcMode = 'keep';end;
            
            self.calcIntrinsicValue;
            if isempty( self.preSettle ) 
                preSettle = self.last;
            end 
            if ~isempty( self.preSettle ) 
                if self.preSettle == 0 || isnan( self.preSettle )
                    preSettle = self.last;
                else
                    preSettle = self.preSettle;
                end
            end
            if isempty( self.settle )
                settle = self.last;
            end
            if ~isempty( self.settle ) 
                if self.settle == 0 || isnan( self.settle )
                    settle = self.last;
                else
                    settle = self.preSettle;
                end
            end
            
            % ���㱣֤��
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL', '�Ϲ�', '��',1 }
                switch calcMode
                    case 'init'
                        mg = preSettle + max( self.etfpreClose*0.12 - max([self.K - self.S, 0]), self.etfpreClose *0.07 );
                    case 'keep'
                        mg = settle + max( self.S*0.12 - max([self.K - self.S, 0]), self.S *0.07 );
                end
                case {'P', 'p', 'put', 'Put', 'PUT', '�Ϲ�',  '��', 2}
                    switch calcMode
                        case 'init'
                            mg = min( preSettle + max( self.etfpreClose*0.12 - max([self.S - self.K, 0]), self.K*0.07 ), self.K ); 
                        case 'keep'
                            mg = min( settle + max( self.S*0.12 - max([self.S - self.K, 0]), self.K*0.07 ), self.K ); 
                    end
            end
        end
        
        function ratio = calcMarginRate_bid( self )
            % ����margin��ֵ
            margin = self.margin;
            ratio = self.bidP1/margin;           
        end
        
        % ����ÿ����Ȩ�Ľ��׷���
        function fee = calcFee(self, isAskOpen)
            % ��Ȩ�����ѷ�Ϊ�����֣� ���ַ� + Ӷ��
            % Ӷ��Ϊÿ����Ȩ0.3 Ԫ
            % ���ַ�Ϊÿ����Ȩ2Ԫ������ ���վ��ַ�
            % һ����ȨΪ10000�ɡ�
            if(~exist('isAskOpen', 'var')), isAskOpen = false;end
            
            if(isAskOpen)
                brokerage = 0;%���ַ�
            else
                brokerage = 2;
            end
            commission = 0.3; %Ӷ��
            fee = brokerage + commission; % ���׷���
        end
        
        % ����intrinsic value����
%         function [inValue, tValue] = calcIntrinsicValue( self, S ) 
        function [inValue] = calcIntrinsicValue( self, S )

            % ����intrinsic value������
             if ~exist('S', 'var') 
                S = self.S;
            end                

            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    inValue = max(  [ S - self.K,  0 ]  );
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    inValue = max(  [ self.K - S ,  0 ]  );
            end  
%             tValue  = self.askP1 - inValue;
            self.intrinsicValue = inValue;
%             self.timeValue = tValue;
        end
        
        % ����intrinsic value��timeValue, ����
        function [inValue, tValue] = calc_intrinsicValue_timeValue( self, S )  
            % ����intrinsic value������
             if ~exist('S', 'var') 
                S = self.S;
            end                

            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    inValue = max(  [ S - self.K,  0 ]  );
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    inValue = max(  [ self.K - S ,  0 ]  );
            end
            tValue  = self.askP1 - inValue;
            self.intrinsicValue = inValue;
            self.timeValue = tValue;
            self.timeValue_pct = tValue / self.S;      % timeValue_percent : timeValue / S * 100%
            self.timeValue_pct_a = self.timeValue_pct / self.tau;    % timeValue_pct * 1/tau;
        end        
        
        function [m] = calcMoneyness(self)
            % ����moneyness��moneyness�Ķ������ȶ��
            m = log(self.K/self.S);
            m_tau = m / sqrt(self.tau);
            m_shift = (m_tau - (self.r - 0.5 * power(self.impvol, 2))*sqrt(self.tau)) / self.impvol;
            z = m_shift / self.impvol;
            self.M = m;
            self.M_tau = m_tau;
            self.M_shift = m_shift;
            self.Z = z;
        end       
        
        
    end
    
    
    %% ����д��������ĺ���
    methods(Access = 'public', Static = false, Hidden = false)
        % ��������Դ����
        [ self ] = setSrcType(self, src_type);
        % ��������ԴID
        [ self ] = setSrcId(self, src_id); 
        % �����޷�������
        [ self ] = setRate(self, rate);
        % ȡ����ͨ�ú���
        [ self ] = fillQuote(self); 
        % ȡH5�������ݣ� ����
        [ self ] = fillQuoteH5( self );
        
        % ȡWind�������ݣ�����
        [ self ] = fillQuoteWind( self , w );
        
        % ȡL2�������ݣ�����
        [ self ] = fillQuoteL2(self, l2_str);
        
        % ȡCTP����
        [ self ] = fillQuoteCTP(self);
        
        % ȡXSpeed����
        [ self ] = fillQuoteXSpeed(self);
        
        % ��ʷ���鵥��������
        [self] = fillHistoricalQuote(self, day);

    end
    
    methods(Static = true)
        [ quote, m2tkCallQuote, m2tkPutQuote ] = init_from_sse_excel( OptInfoXls );
        [ m2tkCallMargin , m2tkPutMargin ] = calc_margin_rate( OptInfoXls , w );
        demo;
    end
        
      %% �������ݵĺ���
    methods(Access = 'public', Static = false, Hidden = false)
        
        %% ��������greeks����
        [  ] = calc_ask_all_greeks( obj );
        [  ] = calc_bid_all_greeks( obj );
        [  ] = calc_last_all_greeks( obj );
        
        %% ����Dollar Greeks
        function [dollardelta1] = calcDollarDelta1(obj)
            %function [dollardelta1] = calcDollarDelta1(obj)
            dollardelta1 = obj.delta * obj.multiplier * obj.S * 0.01;
        end
        
        %% �����õ�С������ÿ��ֻ��һ��greeks�� ��˼�����Ƿ���getter����
        % ����Impvol
        function [vol] = calcImpvol(self, rf)            
            if ~exist('rf', 'var'), rf = self.r; end
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    vol = blsimpv( self.S, self.K, rf, self.tau, self.last, 10, 0, [],{'call'});
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    vol = blsimpv( self.S, self.K, rf, self.tau, self.last, 10, 0, [],{'put'});
            end   
            if isnan(vol)
                vol = 0.0001;
            end
            self.impvol = vol;
        end
        
        function [vol] = calcImpvol_bid(self, rf)   
            if ~exist('rf', 'var'), rf = self.r; end
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    vol = blsimpv( self.S, self.K, rf, self.tau, self.bidP1, 10, 0, [],{'call'});
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    vol = blsimpv( self.S, self.K, rf, self.tau, self.bidP1, 10, 0, [],{'put'});
            end   
            self.bidimpvol = vol;
        end
        
        function [vol] = calcImpvol_ask(self, rf)    
            if ~exist('rf', 'var'), rf = self.r; end
            tau = self.tau;
            
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    vol = blsimpv( self.S, self.K, rf, tau, self.askP1, 10, 0, [],{'call'});
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    vol = blsimpv( self.S, self.K, rf, tau, self.askP1, 10, 0, [],{'put'});
            end              
            self.askimpvol = vol;
        end
        
        %%%%%%%%%%%%%%%%%%����
        % ����delta 
        % ʹ��lastprice
        function [self] = calcDelta(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end
            [cdelta,pdelta] = blsdelta( self.S, self.K, rf, self.tau, impvol);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.delta = cdelta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.delta = pdelta;
            end
            
        end
        
        % ʹ��bidprice
        function [self] = calcDelta_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end
           
            [cbiddelta,pbiddelta] = blsdelta( self.S, self.K, rf, self.tau, impvol_bid);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.biddelta = cbiddelta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.biddelta = pbiddelta;
            end
            
        end
        
        % ʹ��askprice
        function [self] = calcDelta_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end

            [caskdelta,paskdelta] = blsdelta( self.S, self.K, rf, self.tau, impvol_ask);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.askdelta = caskdelta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.askdelta = paskdelta;
            end
            
        end
        
        % ����Gamma
        
        function [self] = calcGamma(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.gamma = NaN;
                return;
            end
            
            self.gamma = blsgamma(self.S, self.K, rf, self.tau, impvol);    
        end
        % ����bidgamma
        function [self] = calcGamma_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end

            self.bidgamma = blsgamma(self.S, self.K, rf, self.tau, impvol_bid);
        end
        % ����askgamma
        function [self] = calcGamma_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end

            self.askgamma = blsgamma(self.S, self.K, rf, self.tau, impvol_ask);
        end
        
        % ����Vega    
        function [self] = calcVega(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end
            
            self.vega = blsvega(self.S, self.K, rf, self.tau, impvol);
        end
        % ����bidvega
        function [self] = calcVega_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end

            self.bidvega = blsvega(self.S, self.K, rf, self.tau, self.bidimpvol);
        end
        % ����askvega
        function [self] = calcVega_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
                        if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end

            self.askvega = blsvega(self.S, self.K, rf, self.tau, impvol_ask);
        end
        
        % ����theta
        % ʹ��lastprice
        function [self] = calcTheta(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end

            [ctheta,ptheta] = blstheta( self.S, self.K, rf, self.tau, impvol);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.theta = ctheta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.theta = ptheta;
            end
            
        end
        
        % ʹ��bidprice
        function [self] = calcTheta_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end

            [cbidtheta,pbidtheta] = blstheta( self.S, self.K, rf, self.tau, impvol_bid);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.bidtheta = cbidtheta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.bidtheta = pbidtheta;
            end
        end
        
        % ʹ��askprice
        function [self] = calcTheta_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end

            [casktheta,pasktheta] = blstheta( self.S, self.K, rf, self.tau, impvol_ask);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.asktheta = casktheta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.asktheta = pasktheta;
            end
            
        end
        
        % ����rho
        % ʹ��lastprice
        function [self] = calcRho(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end
            
            [crho,prho] = blsrho( self.S, self.K, rf, self.tau, impvol);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.rho = crho;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.rho = prho;
            end
            
        end
        
        % ʹ��bidprice
        function [self] = calcRho_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end

            [cbidrho,pbidrho] = blsrho( self.S, self.K, rf, self.tau, impvol_bid);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.bidrho = cbidrho;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.bidrho = pbidrho;
            end
            
        end
        
        % ʹ��askprice
        function [self] = calcRho_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end
            
            [caskrho,paskrho] = blsrho( self.S, self.K, rf, self.tau, impvol_ask);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.askrho = caskrho;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.askrho = paskrho;
            end
            
        end        
        
        % ����lambda
        % ʹ��lastprice
        function [self] = calcLambda(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end
            
            [clambda,plambda] = blslambda( self.S, self.K, rf, self.tau, impvol);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.lambda = clambda;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.lambda = plambda;
            end
            
        end
        
        % ʹ��bidprice
        function [self] = calcLambda_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end
            
            [cbidlambda,pbidlambda] = blslambda( self.S, self.K, rf, self.tau, impvol_bid);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.bidlambda = cbidlambda;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.bidlambda = pbidlambda;
            end
            
        end
        
        % ʹ��askprice
        function [self] = calcLambda_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end
            [casklambda,pasklambda] = blslambda( self.S, self.K, rf, self.tau, impvol_ask);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.asklambda = casklambda;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.asklambda = pasklambda;
            end
            
        end
   
    end

    %% һЩ����ת����С��������    
    methods
        % ��QuoteOptת����OptPricer�� ��ȡҪ�ؼ��ɣ��漰��ʹ��ʲôsigma������
        function [optPricer ]  = QuoteOpt_2_OptPricer(quoteOpt, vol_type)
            %   vol_typeȡֵ��'ask', 'bid', 'last'
            optPricer = OptPricer;
            
            flds    = properties(OptInfo);
            flds{end+1}  = 'S';
            flds{end+1}  = 'r';
            L       = length(flds);
            for i = 1:L
                fld = flds{i};
                optPricer.(fld) = quoteOpt.(fld);
            end
            
%             sigma: 0.3000
%             S: []
%             r: 0.0500
%             model: 'BS'
%             intrinsicValue: []
%             timeValue: []
%             px: []
            

            %% ����sigma������
            
            % ���б�Ҫ����iv
            if ~exist('vol_type', 'var'), vol_type = 'last'; end
            switch vol_type
                case {'ask'}
                    optPricer.sigma = quoteOpt.askimpvol;
                case {'bid'}
                    optPricer.sigma = quoteOpt.bidimpvol;
                case{'last'}
                    optPricer.sigma = quoteOpt.impvol;
                otherwise
                    optPricer.sigma = quoteOpt.impvol;
            end

        end
        
        % ��QuoteOptת����OptInfo�����ࣩ�� ��ȡ�м��Ҫ�ؼ���
        function [optInfo] = QuoteOpt_2_OptInfo(quoteOpt)
            optInfo = OptInfo; 
            
            flds    = properties(optInfo);
            L       = length(flds);
            for i = 1:L
                fld = flds{i};
                optInfo.(fld) = quoteOpt.(fld);
            end
            
        end
        
        
    end
    
    
    %% ���
    methods
% S = 2.315  |  09-May-2017 14:06:42
% optName	askPx	askQ	iv	1%delta	1%gamma	Dtheta	1%vega	timeV
% [��12��2300:ask]	677	10	2.0%	 223.2	 5.5	 -2.1	 14.7	 527
% [��12��2300:bid]	671	10	1.4%	 230.3	 1.5	 -2.2	 2.7	 521
        function [sss] = print_risk(obj, pxType)
            if ~exist('pxType', 'var') 
                pxType = 'both';
            end
            
%             tmp.calc_ask_all_greeks;
            
            S       = obj.S;
            fprintf('S = %0.3f  |  %s  | mg %0.0f\n', S, datestr(now), obj.margin * obj.multiplier);
            fprintf('optName\taskPx\taskQ\tiv\t1%%delta\t1%%gamma\tDtheta\t1%%vega\ttimeV\ttimeV%%\n');

            switch(pxType)
                case{ 'ask' }
                    sss = obj.println_risk_ask;
                    
                case{ 'bid' }                    
                    sss = obj.println_risk_bid;

                case{ 'both' }
                     sss(1,:) = obj.println_risk_ask;
                     sss(2,:) = obj.println_risk_bid;

            end
        end
        
% optName	askpx	askQ	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��9��2150:ask]	1542	1	19.4%	 133.9	 267.8	 3.0	 12.0	 -4.7	 58.5       
        function [risk] = println_risk_ask(obj)
            

            obj.calc_ask_all_greeks;
            
            S       = obj.S;
            on      = obj.optName(6:end);
            px      = obj.askP1 * obj.multiplier;
            q       = obj.askQ1;
            iv      = obj.askimpvol*100;
            delta   = obj.askdelta * obj.multiplier * S*0.01;
%             delta2  = obj.askdelta * obj.multiplier * S*0.02;
            gamma  = obj.askgamma * obj.multiplier * S*S*0.0001/2 ;
%             gamma2  = obj.askgamma * obj.multiplier * S*S*0.0004/2 ;
            theta   = obj.asktheta * obj.multiplier / 365 ;
            vega    = obj.askvega * obj.multiplier * 0.01;
            
            
            obj.calc_intrinsicValue_timeValue;            
            inV     = obj.intrinsicValue * obj.multiplier;
            tmV     = px - inV;
            tmV_pcta= obj.timeValue_pct_a * 100;
            
            risk    = [px, q, iv, delta,  gamma,  theta, vega, tmV, tmV_pcta];
            
            fprintf('[%s:ask]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.0f\t %0.1f%%\n', on,...
                px, q, iv, delta,   gamma, theta, vega, tmV, tmV_pcta);
            
        end
        
        
% optName	askpx	askQ	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [��9��2150:bid]	1499	2	18.7%	 134.5	 268.9	 3.1	 12.4	 -4.6	 58.4
        function [risk] = println_risk_bid(obj)
            
            obj.calc_ask_all_greeks;
            
            S       = obj.S;
            on      = obj.optName(6:end);
            px      = obj.bidP1 * obj.multiplier;
            q       = obj.bidQ1;
            iv      = obj.bidimpvol*100;
            delta   = obj.biddelta * obj.multiplier * S*0.01;
%             delta2  = obj.biddelta * obj.multiplier * S*0.02;
            gamma  = obj.bidgamma * obj.multiplier * S*S*0.0001/2 ;
%             gamma2  = obj.bidgamma * obj.multiplier * S*S*0.0004/2 ;
            theta   = obj.bidtheta * obj.multiplier / 365 ;
            vega    = obj.bidvega * obj.multiplier * 0.01;
          
            
            obj.calc_intrinsicValue_timeValue;
            inV     = obj.intrinsicValue * obj.multiplier;
            tmV     = px - inV;
            tmV_pcta= obj.timeValue_pct_a * 100;
            
            
            risk    = [px, q, iv, delta,  gamma,  theta, vega, tmV, tmV_pcta];
            
            fprintf('[%s:bid]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.0f\t %0.1f%%\n', on,...
                px, q, iv, delta,   gamma,  theta, vega, tmV, tmV_pcta);
        end
        
        
        function print_pankou(quote)
            % ��ӡ�̿����
            % ��ͬ��
%             7	0.1745
%             2	0.1736
%             1	0.1735
%            10	0.1730
%             8	0.1729
%             --------------------------
%                 0.1705	1
%                 0.1704	1
%                 0.1699	1
%                 0.1690	1
%                 0.1687	10
            
            mat1(1,:) = [quote.askQ5, quote.askP5];
            mat1(2,:) = [quote.askQ4, quote.askP4];
            mat1(3,:) = [quote.askQ3, quote.askP3];
            mat1(4,:) = [quote.askQ2, quote.askP2];
            mat1(5,:) = [quote.askQ1, quote.askP1];
            
            
            mat2(1,:) = [quote.bidP1, quote.bidQ1];
            mat2(2,:) = [quote.bidP2, quote.bidQ2];            
            mat2(3,:) = [quote.bidP3, quote.bidQ3];
            mat2(4,:) = [quote.bidP4, quote.bidQ4];
            mat2(5,:) = [quote.bidP5, quote.bidQ5];

            for i = 1:5
                fprintf('%d\t%0.4f\n', mat1(i,1), mat1(i,2));
            end
            fprintf('-----------------------\n');
            for i = 1:5
                fprintf('\t%0.4f\t%d\n', mat2(i,1), mat2(i,2));
            end
            
        end
        
        
        function mat = print_pankou2( quote )
            mat1(1,:) = [quote.askQ5, quote.askP5];
            mat1(2,:) = [quote.askQ4, quote.askP4];
            mat1(3,:) = [quote.askQ3, quote.askP3];
            mat1(4,:) = [quote.askQ2, quote.askP2];
            mat1(5,:) = [quote.askQ1, quote.askP1];
            last  = quote.last;
            mat2(1,:) = [quote.bidP1, quote.bidQ1];
            mat2(2,:) = [quote.bidP2, quote.bidQ2];            
            mat2(3,:) = [quote.bidP3, quote.bidQ3];
            mat2(4,:) = [quote.bidP4, quote.bidQ4];
            mat2(5,:) = [quote.bidP5, quote.bidQ5];
            
            % �����е����ݷ�����һ��mat����
            mat = cell( 10 , 3 );
            mat( 1:5  , 1:2 ) = num2cell( mat1 ); 
            mat( 6:10 , 2:3 ) = num2cell( mat2 );
            
        end
        
    end

    %% Ϊ���Ա������ṩһ��������ɵĶ��󷽷�
    methods (Access = 'public', Static = true)
        function [obj] = RandomInstance()
            obj = QuoteOpt;
            for i = 1:5
                c_bidP = ['bidP',num2str(i)];
                c_bidV = ['bidQ',num2str(i)];
                obj.(c_bidP) = randi([1 + 50*i, 50 * (i+1)]);
                obj.(c_bidV) = randi([0, 100]);
                c_askP = ['askP',num2str(i)];
                c_askV = ['askQ',num2str(i)];
                obj.(c_askP) = randi([1 + 50*i + 400, 50 * (i+1) + 400]);
                obj.(c_askV) = randi([0, 100]);                
            end
        end
    end
    
end
