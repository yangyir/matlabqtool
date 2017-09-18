% version 1.0, luhuaibao, 2014.5.30
% ������AnaTicks�������ticksȫ������ͳ��




classdef AnaTicks
    
    properties
        
    end
    
    
    %% %%%%  �����ࣺ˽�к��������ݶ�������ͨ���� %%%%%%%%%%%%%%%%%%%
    methods (Access = 'private', Static = true, Hidden = true )
        % ����atr
        [ ATR ] = atr0( high, low, vclose, atrlen )
        
        % ��tao���ݣ������ڴ˼���
        dist= findFirstEqual(  ts1, ts2, itimes )
        
        % �ƶ������ֵ
        [ r, idx ] = movMax0( ts, len )
        
        % �ƶ�����Сֵ
        [ r, idx ]  = movingMin0( ticks,len,type )
        
        % ��ʱ�����еı仯
        [ varargout ] = chg0( nday,varargin )
        
        % ��ʱ�����еİٷֱȱ仯
        [ varargout ] = pctChg0( nday,varargin )
        
        % ��һ�������������ŵİٷ�λ(chenggang, 140608)
        [ percentile ] = prctileP( vertor, value )
        
        % ��������ʱ��
        [ idx1, idx2, commonTime] = duiqiTime(times1, times2, type, givenTime)
        
    end
    
    
    %% %%%%   ��һ��:�������㺯�������ݶ�����Ticks   %%%%%%%%%%%%%%%
    %%%%%%%%%%  ����  xxxYyyZzz ��ʽ����
    
    methods (Access = 'public', Static = true, Hidden = false)
        
        % ����timespent,timespentΪ�����µ���ʽ�£����鿴���ɽ���ȴ�ʱ��
        [waiting, waiting_tk] = r( ticks,t,limitprice,direction, flag_strict, latency   )
        
        % ����ATR��
        [ vatr ] = ATR( ticks, atrlen )
        
        % ���������ҵ��ļ۲�
        [ bid_ask_spread ] = bas(ticks,asklevel, bidlevel);
               
        % �ƶ������ֵ�������ȥ����ֵ��δ������ֵ
        [ r, idx ]  = movingMax( ticks,len,type )
        
        % �ƶ�����Сֵ�������ȥ����ֵ��δ������ֵ
        [ r, idx ]  = movingMin( ticks,len,type )
        
        %PCTCHG �����ǵ����ٷֱ�
        vchg = pctChg( ticks,len,type )
        
        % CHG �����ǵ���
        vchg = chg( ticks,len,type )
        
        % �նȵĲ�������std����
        vvol = vol( ticks, type )
        
        % �ƶ���vol��������std
        vol = movingVol( ticks,len,type )
        
        % ��������ticks֮���delta
        deltavalue = delta(Ticks1,Ticks2,AdjustMethod)
        
        % ��ǰ�۸��Ƕ೤��ȥʱ������ֵ
        [t, tk] = maxSince( ticks, currentTk, type)
        
        % ��ǰ�۸��Ƕ೤��ȥʱ�����Сֵ
        [t, tk] = minSince( ticks, currentTk, type)
        
        % ��Ϊ����������������۸������İٷ�λ������������ٷ�λ�ļ۸�ֵ(chenggang, 140608)
        [prct]  = percentileP(ticks, currentTk, valuePrice, win, type)
        [value] = percentileV(ticks, currentTk, percentile, win, type)
        
        % δ��һ��ʱ���ڵ����ֵ����λ��
        [mx,tk,t] = maxof( ticks, currentTk, len, type)
        
        % δ��һ��ʱ���ڵ���Сֵ����λ��
        [mx,tk,t] = minof( ticks, currentTk, len, type)
        
        % ����Խ��׵�spread
        [ spread, spTicks ] = pairSpread(ticks1, ticks2, type, timeType, commonTime)
    end
    
    %% %%%% �ڶ��ࣺ��һչʾ���� ��������һ��������չʾ�������ܱ����� %%%%%%%%%%%%
    %%%%%%% ���� xxx_xxx_xxx����
    
    methods (Access = 'public', Static = true, Hidden = false)
        
        % ��command�������ticks�е�last��bid��last��ask�ĸߵ͹�ϵ
        highLowRelation( ticks ) ;
        
        % ͳ��lask��bid1��ask1�Ĵ�С��ϵ, ����һ������һ��
        [ ratio ] = last_bid_ask_relation(ticks, displayFlag);
         
        % hist�����ҵ��ļ۲�
        histBas( ticks, asklevel, bidlevel )
        
        % bid,ask,bas��ͼ
        plotBas( ticks ) ;
        
        % �ɽ��� vs volume
        plot_lastVolume( ticks )
        
        % last/bid/askһ�ײ�ֲַ�
        histDiff( ticks )
        
        % ���̿ڹҵ����
        plot_orderDepth( ticks ,cur, twindow  );
        
        % ��curǰ�����ɸ�tk�Ĺҵ����
        [ ] = plotPanKou( ts, cur, pre_win, post_win );
        
        %% ����
        % ����չʾ�̿����ݣ���ͼ��
        [] = animate_pankou(ticks, stk, etk, step, pauseSec);
        
        % ����չʾ�̿�����(��ͼ���ͼ۸������ݣ���ͼ��
        [] = animate_line_pankou(ticks, stk, etk, step, twindow, pauseSec);
        
         
        
    end
    
    
    
    %% %%%%    �����ࣺӦ�ò�Σ�script�����õ�һ��͵ڶ��࣬�Զ�ʵ�ֹ���
    %%%%%%%%%%%         �����Ըߣ�����������ĳ�����ã����ռ���
    %%%%%%% ���� xxx_xxx_xxx����
    % ���ھ�����������һ����Ӷ���
    % ����Ĵ���Ӧ�ñȽ��ȶ���ȫ��
    
    methods (Access = 'public', Static = true, Hidden = false)

        
        
        % ���onenote��spread�ſںͱտڵķ�ʽ
        ana_spread_enlarge_close(params)
        
        % ����һ�����r���ɽ����޼۵ȴ�ʱ���о�
        taovalue = tao( ticks0 , yields )
        
        % ��taovaluez��Ӧ������plot
        plotTao( tao,minSpread ) ;
        
        % ��Ȩ��������
        estimate_Opt( dataPath ) ; 
        
        
        
        %% cg����ʵ��Ticks�޹أ���ʱ��������
        % �����������۲�ն�
        dh_daily_IF_time_spread(inear, ifar);
        
        % 
        
        
        
    end
    
    
    
end
