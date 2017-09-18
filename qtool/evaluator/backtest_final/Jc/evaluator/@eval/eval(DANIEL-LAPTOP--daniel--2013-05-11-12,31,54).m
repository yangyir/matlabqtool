classdef eval
    %EVAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        alpha = Alpha( navOrRate, benchmark, rf, flag);
        beta = Beta( navOrRate, benchmark, flag);
        burkeR  = BurkeRatio(navOrRate, rf, flag);
        calmarR = CalmarRatio( navOrRate, rf, flag);
        lretExclMax = LretExclMax(navOrRate, flag)
        maxConGainTime = MaxConGainTime( navOrRate, flag);
        retExclMax  = RetExclMax(navOrRate, flag)
        sharpeR = SharpeRatio( navOrRate, rf, flag);
        sortinoR = SortinoRatio( navOrRate, rf, flag);
        treynorR = TreynorRatio( navOrRate, benchmark, rf, flag);

        [ infoRatio ] = infoRatio( nav, benchmark,flag );
        upRatio = upr(ret, MAR);
    end
    
end

