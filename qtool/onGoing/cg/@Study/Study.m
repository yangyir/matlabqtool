classdef Study
    %STUDY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    
   %% %%%%  �����ࣺ˽�к��������ݶ�������ͨ���� %%%%%%%%%%%%%%%%%%%
    methods (Access = 'private', Static = true, Hidden = true )
    end
    
    %% %%%%   ��һ��:�������㺯�� %%%%%%%%%%%%%%%
    %%%%%%%%%%  ����  xxxYyyZzz ��ʽ����
    methods (Access = 'public', Static = true, Hidden = false)
        % ��future�ն�vol
        [vol, rangePct ]  = dh_dailyFutureVol( code, date );
        [vol, rangePct ]  = dh_dailyStockVol( code, date );
    end
    
   %% %%%% �ڶ��ࣺ��һ���ܺ��� ��������һ��������չʾ�������ܱ����� %%%%%%%%%%%%
    %%%%%%% ���� xxx_xxx_xxx����    
    methods (Access = 'public', Static = true, Hidden = false)
        % ����ʷ��ĳ������Լ��roll cost��@1406
        [ rollCost ]    = dh_plot_continous_IF_roll_cost( iNearby );
        
        % ��IF0Y00�����С�Ŀ���roll cost��@1406
        [ ifroll ]      = dh_IF0Y00_max_min_potential_roll_cost;
        
        % �򵥻�һ��ʱ�������к�Լ��ͼ���նȣ� @1406
        [ contracts ] = dh_plot_all_IF_contracts2(strat_dt, end_dt, type);
        
         % �򵥻�: ĳ��Լ�����������к�Լ��ͼ���նȣ� @1406
        [ contracts ] = dh_plot_all_IF_contracts( aimCode, type);
        
        
        
        
        
    end
    
   %% %%%%    �����ࣺӦ�ò�Σ�script�����õ�һ��͵ڶ��࣬ʵ�ֽϸ��ӹ���
    %%%%%%%%%%%         �����Ըߣ�����������ĳ�����ã����ռ���
    %%%%%%% ���� xxx_xxx_xxx����
    % ���ھ�����������һ����Ӷ���
    % ����Ĵ���Ӧ�ñȽ��ȶ���ȫ��
    
    methods (Access = 'public', Static = true, Hidden = false)
        % �����������۲�ն� @1406
        dh_daily_IF_time_spread(inear, ifar);
        
        % ��
    
    end
    
    
    methods
    end
    
end

