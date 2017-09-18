classdef eval
% 算风险收益指标    
% Pan, Qichao; 2013; 好久没用过


    properties
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        alpha   = alpha( navOrRate, benchmark, rf, flag);
        beta    = beta( navOrRate, benchmark, flag);
        burkeR  = BurkeRatio(navOrRate, rf, flag);
        calmarR = CalmarRatio( navOrRate, rf, flag);
        lretExclMax     = LretExclMax(navOrRate, flag)
        maxConGainTime  = MaxConGainTime( navOrRate, flag);
        retExclMax      = RetExclMax(navOrRate, flag)
        sharpeR     = SharpeRatio( navOrRate, rf, flag);
        sortinoR    = SortinoRatio( navOrRate, rf, flag);
        treynorR    = TreynorRatio( navOrRate, benchmark, rf, flag);
        mddVal      = MaxDrawDownVal(nav);
        [ mdd ]     = MaxDrawDown( nav );
        [ span, t1, t2 ] = longestDrawDown( nav );
        [infoRatio]     = infoRatio( nav, benchmark,flag );
        upRatio     = upr(ret, MAR);
        
    end
    
end

