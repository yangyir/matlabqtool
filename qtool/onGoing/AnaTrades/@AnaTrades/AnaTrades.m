% ���ڶ�TradeList��EntrustList����з���
% �̸գ�20140608

classdef AnaTrades
    %ANATRADES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
   %% %%%%  �����ࣺ˽�к��������ݶ�������ͨ���� %%%%%%%%%%%%%%%%%%%
    methods (Access = 'private', Static = true, Hidden = true )

    end
    
    
    %% %%%%   ��һ��:�������㺯�������ݶ����� TEBASE  %%%%%%%%%%%%%%%
    %%%%%%%%%%  ����  xxxYyyZzz ��ʽ����
    
    methods (Access = 'public', Static = true, Hidden = false)
 
   
    end
    
    %% %%%% �ڶ��ࣺ��һչʾ���� ��������һ��������չʾ�������ܱ����� %%%%%%%%%%%%
    %%%%%%% ���� xxx_xxx_xxx����
    
    methods (Access = 'public', Static = true, Hidden = false)
        


    end
    
    
    
    %% %%%%    �����ࣺӦ�ò�Σ�script�����õ�һ��͵ڶ��࣬�Զ�ʵ�ֹ���
    %%%%%%%%%%%         �����Ըߣ�����������ĳ�����ã����ռ���
    %%%%%%% ���� xxx_xxx_xxx����
    % ���ھ�����������һ����Ӷ���
    % ����Ĵ���Ӧ�ñȽ��ȶ���ȫ��
    
    methods (Access = 'public', Static = true, Hidden = false)
        
        [ pnl, frq, figtext ] = market_maker_strategy_backtest_cg( entrustList, tradeList, FEE, outFlag)

    end
    
    
 
    
end

