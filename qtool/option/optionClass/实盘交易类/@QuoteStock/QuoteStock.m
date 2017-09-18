classdef QuoteStock < StockInfo  %< handle
% ���ڴ�����飬�����ǽ������飬��Ʊר��
% ----------------------------------------
% �콭 20160314 ��QuoteOpt
    %% ��̬����Ϣ
    properties
        % ����Դ���ͣ�������CTP,�ɴ�
        srcType = '';
        % ����ԴID��Ĭ��ֵ��Ϊ-1
        srcId = -1;
        % Greeks 
        delta = 1;
        gamma = 0;
        vega = 0;
        theta = 0;
        pLevel = 5;
    end
    
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        stockInfo@StockInfo;    % ��Ȩ��Ϣ        
        latest; % ����һ��
    end
    
    
    %% ������Ϣ
    properties
       quoteTime;%     ����ʱ��(s)
%        dataStatus;%    DataStatus	
%        secCode;%֤ȯ����	
%        accDeltaFlag;%ȫ��(1)/����(2)	
%        preSettle;%���ս����	
%        settle;%���ս����	
       preClose;
       preSettle;
       open; %���̼�	
       high; %��߼�	
       low;  %��ͼ�	
       last; %���¼�	
       close;%���̼�	
%        refP; %��̬�ο��۸�	
%        virQ; %����ƥ������	
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
    end
    
    %% ���캯�������ƹ��캯��
    methods(Access = 'public', Hidden = true)
        % ���캯��
        function self = QuoteStock()
                   
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
    
    %% ������Ч�Ժ���
    methods(Access = 'public', Hidden = false)
        function [valid] = is_obj_valid(obj)
            valid = (~strcmp(obj.optName, '������Ʊ'));
        end
        
        function [valid] = is_quote_valid(obj)
            valid = (~isempty(obj.last) && ~isnan(obj.last) && (obj.last > 0));
        end
    end
    
    methods
        %% ����Dollar Greeks
        function [dollardelta1] = calcDollarDelta1(obj)
            %function [dollardelta1] = calcDollarDelta1(obj)
            dollardelta1 = obj.delta * obj.multiplier * obj.last * 0.01;
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
        
        % ȡһ��L2���ݣ�����
        [ self ] = fillQuoteL2(self, l2_str);

        % ȡCTP����
        [ self ] = fillQuoteCTP( self );

        % ȡXSpeed����
        [ self ] = fillQuoteXSpeed( self );
        
        % ��ʷ���鵥��������
        [self] = fillHistoricalQuote(self, day);
        
    end
    
    methods(Access = 'public', Static = true)
        %% ��Excel�ļ��й���quotes�Ľṹ����Quote_map������
        [quotes, quote_map] = init_from_excel(stockInfoXlsx);
    end
    


    
end
