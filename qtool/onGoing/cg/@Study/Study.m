classdef Study
    %STUDY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    
   %% %%%%  第零类：私有函数，数据对象是普通矩阵 %%%%%%%%%%%%%%%%%%%
    methods (Access = 'private', Static = true, Hidden = true )
    end
    
    %% %%%%   第一类:基础计算函数 %%%%%%%%%%%%%%%
    %%%%%%%%%%  采用  xxxYyyZzz 方式命名
    methods (Access = 'public', Static = true, Hidden = false)
        % 算future日度vol
        [vol, rangePct ]  = dh_dailyFutureVol( code, date );
        [vol, rangePct ]  = dh_dailyStockVol( code, date );
    end
    
   %% %%%% 第二类：单一功能函数 （独立的一个分析、展示），可能被调用 %%%%%%%%%%%%
    %%%%%%% 采用 xxx_xxx_xxx命名    
    methods (Access = 'public', Static = true, Hidden = false)
        % 看历史上某连续合约的roll cost，@1406
        [ rollCost ]    = dh_plot_continous_IF_roll_cost( iNearby );
        
        % 看IF0Y00最大最小的可能roll cost，@1406
        [ ifroll ]      = dh_IF0Y00_max_min_potential_roll_cost;
        
        % 简单画一段时间内所有合约的图（日度） @1406
        [ contracts ] = dh_plot_all_IF_contracts2(strat_dt, end_dt, type);
        
         % 简单画: 某合约存续期内所有合约的图（日度） @1406
        [ contracts ] = dh_plot_all_IF_contracts( aimCode, type);
        
        
        
        
        
    end
    
   %% %%%%    第三类：应用层次：script，调用第一类和第二类，实现较复杂功能
    %%%%%%%%%%%         特异性高，不期望被别的程序调用（最终级）
    %%%%%%% 采用 xxx_xxx_xxx命名
    % 早期尽量避免在这一层里加东西
    % 加入的代码应该比较稳定、全面
    
    methods (Access = 'public', Static = true, Hidden = false)
        % 看跨期套利价差，日度 @1406
        dh_daily_IF_time_spread(inear, ifar);
        
        % 看
    
    end
    
    
    methods
    end
    
end

