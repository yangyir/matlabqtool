classdef L2DataOpt < handle
    %L2DATA L2数据的类，暂时只用于期权
    % 程刚，20151108
    
    
    %%
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        code;
        under;
        S;  % 实时更新
        CP;  % 1 - call, 2 - put
        K;
        T;
        M; % Moneyness; % (S-K)+  或 (K-S)+
        latest; % 最后的一个
        
        
        
    end
    
%% 原始l2行情
%     行情时间(s)	DataStatus	证券代码	全量(1)/增量(2)	昨日结算价	今日结算价	开盘价	最高价	最低价	最新价	收盘价	动态参考价格	虚拟匹配数量	当前合约未平仓数	申买量1	申买价1	申买量2	申买价2	申买量3	申买价3	申买量4	申买价4	申买量5	申买价5	申卖量1	申卖量1	申卖量2	申卖量2	申卖量3	申卖量3	申卖量4	申卖量4	申卖量5	申卖量5	成交数量	成交金额	产品实时阶段标志	市场时间(0.01s)

    properties(SetAccess = 'private', GetAccess = 'public', Hidden = false)
       quoteTime;%     行情时间(s)
       dataStatus;%    DataStatus	
       secCode;%证券代码	
       accDeltaFlag;%全量(1)/增量(2)	
       preSettle;%昨日结算价	
       settle;%今日结算价	
       open;%开盘价	
       high;%最高价	
       low;%最低价	
       last;%最新价	
       close;%收盘价	
       refP;%动态参考价格	
       virQ;%虚拟匹配数量	
       openInt;%当前合约未平仓数	
       bidQ1;%申买量1	
       bidP1;%申买价1	
       bidQ2;%申买量2	
       bidP2;%申买价2
       bidQ3;%申买量3	
       bidP3;%申买价3	
       bidQ4;%申买量4	
       bidP4;%申买价4	
       bidQ5;%申买量5	
       bidP5;%申买价5	
       askQ1;%申卖量1	
       askP1;%申卖价1	
       askQ2;%申卖量2	
       askP2;%申卖价2	
       askQ3;%申卖量3	
       askP3;%申卖价3	
       askQ4;%申卖量4	
       askP4;%申卖价4	
       askQ5;%申卖量5	
       askP5;%申卖价5	
       volume;%成交数量	
       amount;%成交金额	
       rtflag;%产品实时阶段标志	
       mktTime;%市场时间(0.01s)
        
    end
    
    %% 计算出的值
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        % 这些用last来算
        vol;
        delta;
        gamma;
        theta;
        rho;
        lambda;
        
        
        % 这些用ask和bid来算
        askvol;
        askdelta;
        askgamma;
        asktheta;
        askrho;
        asklambda;
        
        bidvol;
        biddelta;
        bidgamma;
        bidtheta;
        bidrho;
        bidlambda;
        
    end
 
    %% 更新的L2域记录
    properties(SetAccess = 'private', GetAccess = 'public', Hidden = false)
        changedL2fields;  % 更新过的域记录下来
    
        
    end
 
    %% constructor
    methods (Access = 'public', Static = true, Hidden = false)
        function obj = L2Data()
            obj.latest = 0;
        end
    end

    
    %% 常见函数
    methods (Access = 'public', Static = true, Hidden = false)
        fillL2Data(obj, str);
        dispL2Data(obj);
        updateTicksProfile(obj);
        updateTicksTimeSeries(obj);
               
       
        
    end
    
    methods(Static = true)
        demo(); %取历史的l2数据，填充
        
        
    end
    
    
    %% 应急用的一些函数
    methods (Access = 'public', Static = false, Hidden = false)
         copyTo( obj, dest );
        [ newobj ] = getCopy( obj );
        
        updateAsk( obj, origin);
        updateBid(obj , origin);
        updateNonzeroDifferent(  obj, origin);
        
        [ obj ] = push( obj, newL2DataRecord);
        [ obj ] = pushstr( obj, L2str);
        
        [obj ] = calc();
        [ obj ] = calcVol(obj);
        
        [ obj ] = clearChangedL2fields(obj);
        
        
    end
  
    %% 小函数，直接写在类里
    methods (Access = 'public', Static = false, Hidden = false)
        
        function mg = margin(obj)
            % 开仓保证金
            % 最低标准
            % 认购期权义务仓开仓保证金＝[合约前结算价+Max（12%×合约标的前收盘价-认购期权虚值，7%×合约标的前收盘价）] ×合约单位
            % 认沽期权义务仓开仓保证金＝Min[合约前结算价+Max（12%×合约标的前收盘价-认沽期权虚值，7%×行权价格），行权价格] ×合约单位
            % 维持保证金
            % 最低标准
            % 认购期权义务仓维持保证金＝[合约结算价+Max（12%×合约标的收盘价-认购期权虚值，7%×合约标的收盘价）]×合约单位
            % 认沽期权义务仓维持保证金＝Min[合约结算价 +Max（12%×合标的收盘价-认沽期权虚值，7%×行权价格），行权价格]×合约单位
            % 其中，认购期权虚值=Max（行权价-合约标的收盘价，0）
            % 认沽期权虚值=max（合约标的收盘价-行权价，0）
            switch obj.CP
                case {1,'c','C','call','Call', 'CALL'}
                    mg = obj.preSettle + max( obj.S*0.12 - obj.M, obj.S *0.07);
                case {2, 'p', 'P', 'put', 'Put', 'PUT'}
                    mg = min( obj.preSettle+ max( obj.S*0.12 - obj.M,  obj.K*0.07), obj.K);                    
            end
            
        end
        
    end
    
end

