classdef QuoteFuture < FutureInfo  %< handle
% ���ڴ�����飬�����ǽ������飬�ڻ�ר��
% ----------------------------------------
% �콭 20160314 ��QuoteOpt
    %% ��̬����Ϣ
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        futureInfo@FutureInfo;    % ��Ȩ��Ϣ        
        latest; % ����һ��
    end
    properties
        % ����Դ���ͣ�������CTP,�ɴ�
        srcType = '';
        % ����ԴID, Ĭ��ֵ��Ϊ-1
        srcId = -1;
        % Greeks 
        delta = 1;
        gamma = 0;
        vega = 0;
        theta = 0;        
        pLevel = 1;
    end
    
    %% ������Ϣ
    properties
       quoteTime;%     ����ʱ��(s)
%        dataStatus;%    DataStatus	
%        secCode;%֤ȯ����	
%        accDeltaFlag;%ȫ��(1)/����(2)	
       preClose;
       preSettle;%���ս����	
%        settle;%���ս����	
       open; %���̼�	
       high; %��߼�	
       low;  %��ͼ�	
       last; %���¼�	
       close;%���̼�	
       refP; %��̬�ο��۸�	
       virQ; %����ƥ������	
       openInt;%��ǰ��Լδƽ����	
       bidQ1;%������1	
       bidP1;%�����1	
%        bidQ2;%������2	
%        bidP2;%�����2
%        bidQ3;%������3	
%        bidP3;%�����3	
%        bidQ4;%������4	
%        bidP4;%�����4	
%        bidQ5;%������5	
%        bidP5;%�����5	
       askQ1;%������1	
       askP1;%������1	
%        askQ2;%������2	
%        askP2;%������2	
%        askQ3;%������3	
%        askP3;%������3	
%        askQ4;%������4	
%        askP4;%������4	
%        askQ5;%������5	
%        askP5;%������5	
       volume = 0; %�ۼƳɽ�����	
       amount;     %�ۼƳɽ����	
%        rtflag;%��Ʒʵʱ�׶α�־	
%        mktTime;%�г�ʱ��(0.01s)
       diffVolume; %�ۼƳɽ�����������
       diffAmount; %�ۼƳɽ���������    
       
    end
        
    
    %% ���캯�������ƹ��캯��
    methods(Access = 'public', Hidden = true)
        % ���캯��
        function self = QuoteFuture()
                   
        end     
    
        function [ newobj ] = getCopy( obj )
            % getCopy() is for deep copy case.
            newobj = feval(class(obj));
            % copy all non-hidden properties
            p = properties(obj);
            for i = 1:length(p)
                newobj.(p{i}) = obj.(p{i});
            end
        end
    end
    
    methods
        %% ����Dollar Greeks
        function [dollardelta1] = calcDollarDelta1(obj)
            %function [dollardelta1] = calcDollarDelta1(obj)
            dollardelta1 = obj.delta * obj.multiplier * obj.last * 0.01;
        end                
    end
    
    %% ������Ч�Ժ���
    methods(Access = 'public', Hidden = false)
        function [valid] = is_obj_valid(obj)
            valid = (~strcmp(obj.optName, '�����ڻ�'));
        end
        
        function [valid] = is_quote_valid(obj)
            valid = (~isempty(obj.last) && ~isnan(obj.last) && (obj.last > 0)...
                    && (obj.askP1 > 0) && (obj.bidP1 > 0) && (obj.askQ1 > 0) && (obj.bidQ1 > 0));
        end
    end
    %% 
    methods(Access = 'public', Static = false, Hidden = false)
        
        function mg = margin( self, account_type )
            
            %���ֱ�֤��
            % �ڻ���֤�������Ͷ��Ϊ40%�� �ױ�Ϊ40%
            
            if ~exist('account_type', 'var')
                account_type = '�ױ�';
            end
            
            if isempty( self.preSettle ) 
                preSettle = self.last;
            else 
                preSettle = self.preSettle;
            end
            
            if ~isempty( self.preSettle ) 
                if self.preSettle == 0 || isnan( self.preSettle )
                    preSettle = self.last;
                else
                    preSettle = self.preSettle;
                end
            end

            mg = 0;
            ct = Calendar_Test.GetInstance();
            t = ct.trading_fraction_day(now);
            if(t < 1)
                % ����
                price = self.last;
            else
                % ��ĩ
                price = preSettle;
            end
            
            switch account_type
                case {'Ͷ��'}
                    % Ͷ���˻���֤�����Ϊ40%
                    mg = price * 0.4;
                case {'�ױ�'}
                    mg = price * 0.2;                    
            end
        end
        
        %�����ָ�ڻ����׷���
        function fee = calcFee(self, isCloseToday)
            % ��ָ�ڻ����׷��� = ��� * ���ʣ�
            % ��ͨ����Ϊ 0.279 / 10000, ���֮0.279
            % ƽ�����Ϊ��ͨ���ʵ�100�����ٷ�֮0.279.
            if ~exist('isCloseToday', 'var'), isCloseToday = false;end
            
            if (isCloseToday)
                fee_rate = 0.279 / 100;
            else
                fee_rate = 0.279 / 10000;
            end
            fee = self.last * fee_rate;
        end
    end
    
    %% ����д��������ĺ���
    methods(Access = 'public', Static = false, Hidden = false)
        % ��������Դ����
        [ self ] = setSrcType(self, src_type);
        % ��������ԴID
        [ self ] = setSrcId(self, src_id);
        % ȡ����ͨ�ú���
        [ self ] = fillQuote(self); 
        
        % ȡH5�������ݣ� ����
        [ self ] = fillQuoteH5( self );
        
        % ȡWind�������ݣ�����
        [ self ] = fillQuoteWind( self , w );
        
        % ȡCTP����
        [ self ] = fillQuoteCTP( self );
        
        % ȡXSpeed����
        [ self ] = fillQuoteXSpeed(self);

        % ��ʷ���鵥��������
        [self] = fillHistoricalQuote(self, day);

    end
    
    
    methods (Access = 'public', Static = true, Hidden = false)
        %% Ϊ����Ŀ�Ĺ���һ���������QuoteFuture
        function [obj] = GetRandomInstance()
            obj = QuoteFuture;
            obj.bidP1 = randi([10,50]);
            obj.bidQ1 = randi([1, 100]);
            obj.askP1 = randi([51, 100]);
            obj.askQ1 = randi([1, 100]);
        end
        
        %% ��Excel�ļ��й���quotes�Ľṹ����Quote_map������
        [quotes, quote_map] = init_from_excel(future_infoxls);
    end
    
end
