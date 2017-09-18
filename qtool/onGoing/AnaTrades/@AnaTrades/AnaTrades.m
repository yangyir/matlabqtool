% 用于对TradeList和EntrustList类进行分析
% 程刚，20140608

classdef AnaTrades
    %ANATRADES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
   %% %%%%  第零类：私有函数，数据对象是普通矩阵 %%%%%%%%%%%%%%%%%%%
    methods (Access = 'private', Static = true, Hidden = true )

    end
    
    
    %% %%%%   第一类:基础计算函数，数据对象是 TEBASE  %%%%%%%%%%%%%%%
    %%%%%%%%%%  采用  xxxYyyZzz 方式命名
    
    methods (Access = 'public', Static = true, Hidden = false)
 
   
    end
    
    %% %%%% 第二类：单一展示函数 （独立的一个分析、展示），可能被调用 %%%%%%%%%%%%
    %%%%%%% 采用 xxx_xxx_xxx命名
    
    methods (Access = 'public', Static = true, Hidden = false)
        


    end
    
    
    
    %% %%%%    第三类：应用层次：script，调用第一类和第二类，自动实现功能
    %%%%%%%%%%%         特异性高，不期望被别的程序调用（最终级）
    %%%%%%% 采用 xxx_xxx_xxx命名
    % 早期尽量避免在这一层里加东西
    % 加入的代码应该比较稳定、全面
    
    methods (Access = 'public', Static = true, Hidden = false)
        
        [ pnl, frq, figtext ] = market_maker_strategy_backtest_cg( entrustList, tradeList, FEE, outFlag)

    end
    
    
 
    
end

