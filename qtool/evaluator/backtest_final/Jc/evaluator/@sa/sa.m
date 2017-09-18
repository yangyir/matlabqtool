classdef sa
    %TSM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    
    %% static tools
    methods (Access = 'public', Static = true, Hidden = false)
        [ indFinal, indAbsDiscInter,indAbsContInter,indRelDiscInter,indRelContInter] = EvalY( Y, riskFreeRate,benchmark );
        [ indAbsContFinal,indAbsContInter] = EvalAbsContY( nav,riskFree,benchmark );
        [ indAbsDiscFinal,indAbsDiscInter] = EvalAbsDiscY( nav,riskFree,benchmark );
        [ indOprnDayFinal,indOprnDayInter] = EvalYY(YY);
        [ indRelContFinal,indRelContInter] = EvalRelContY( nav, riskFree,benchmark );
        [ indRelDiscFinal,indRelDiscInter] = EvalRelDiscY( nav, riskFree,benchmark );
        [ indOprnFinal, tradelist] = EvalTradelist( position,price,commissionIndex,slippageRatio,volume);
        
        
        [ nav, portfolio,tradelist ] = CalcY(fundInitValue,price,position,commission_index,slippageRatio,volume)
        
        
        
        objSingleAsset = build_SingleAsset(assetname,data, dates);
        
        %to cell 

        cel = tsm2cell( tsm );
        
    end
    
    
    
    
    %% private tools
    methods (Access = 'private', Static = true, Hidden = false)
        
        
        [ asset ] = update_SingleAsset( asset, indicator, indName );
    end
    
    
     methods (Access = 'private', Static = true, Hidden = false)
        
         
     end
     
    
end

