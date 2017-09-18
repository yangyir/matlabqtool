classdef OptionInfo<handle
    %OPTIONINFO 
    % --------------------------
    % �̸գ�201511
    % �̸գ�20160126������һ���µĸ������� OptInfo���������ʱ����ô����
    
    
%     ��Լ�̶���Ϣ
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        contractCode; % ��Լ���룺10000427
        optCode; % ��Լ���״��룺'510050C1407M1500'
        optAbbr; % ��Լ��ƣ�50ETF��11��2100
        optType;  % 'call' , 'put', 'exotic'
        adjustCode; % �����ı��룬 'A', 'B', 'M'
        underCode = '510050.SH'; % ���ɴ���
        underName = '50ETF'; % ��������
        underType = 'etf'; % ��������
        underTicks; % ����Ticks���ݣ�ָ�룩
        underHisVol; % ������ʷvolatility
        strikeCode; % �磬3750
        expCode; % ��1407
        strike;  % K����37.5
%         expDate; % �����գ���735766
        expDate2; % �����գ�yyyymmdd
        rfr; % �޷������ʣ���ʱΪ����  
        contractMulti = 10000; % ��Լ��λ��10000
    end
    
    %  ������������ص�״̬��
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        date; %��������
        isTrading = 1; % �Ƿ���
        isNew = 0; % �Ƿ��¹�
        isAdj = 0; % �Ƿ����
        isHalt = 0; % �Ƿ�ͣ��
        naturalT; % ���뵽���ն�����Ȼ��
        tradingT; % ���뵽���ն��ٽ�����
        preSettle; % ǰ�����
        zhangting; % ��ͣ��
        dieting; % ��ͣ��
        
    end
    
    methods(Access = 'public', Static = true, Hidden = false)
        function [K, Under, Type, T] = abbrBreakdown(str)
            K = str(end-3:end);
            Under = str(1:5)
            Type = str(6);
            T = str(7:end-4);    
        end
    end
    
        
     methods(Access = 'public', Static = false, Hidden = false)
         % constructor
         function [obj] = OptionInfo()
%              obj = OptionInfo;
             
             
         end
         
         % ���Ͻ�������Ϣ�����Ͻ���Ĭ��˳��
%          ��Լ����	��Լ���״���	��Լ���	���ȯ���Ƽ�����	����	��Ȩ��	��Լ��λ	��Ȩ��Ȩ��	��Ȩ������	������	�¹�	��ͣ�۸�	��ͣ�۸�	ǰ�����	����	ͣ��
         function [obj] = readSSEdailyInfo(obj, str, i)
             % 
                if ~exist('i', 'var'), i = 1 ; end                
             %
             info{i} = regexp(str, '\t', 'split');
             obj.contractCode{i} = info{1}; %��Լ����
             obj.optCode{i}    = info{2}; %��Լ���״���
             obj.optAbbr{i}    = info{3}; %��Լ���
             %���ȯ���Ƽ�����
             obj.optType{i} = info{5}; %����	
             obj.strike{i} = info{6}; %��Ȩ��	
             obj.contractMulti{i} = info{7}; %��Լ��λ	
             obj.expDate2(i) = str2double(info{8}); %��Ȩ��Ȩ��	
             %��Ȩ������	
             %������	
             %�¹�	
             %��ͣ�۸�	
             %��ͣ�۸�	
             %ǰ�����	
             %����	
             %ͣ��
         end

             

         function [obj] = autoAbbr(obj)
            str = obj.optAbbr;
            [K,Under, Type, T ] = OptionInfo.abbrBreakdown(str);
            obj.expCode = T;
            obj.strikeCode = K;
            obj.underName = Under;
            obj.optType = Type;  
            obj.strike = str2double(K)*0.01;
            
         end
         
        
         
%          function 
    end
    
end

