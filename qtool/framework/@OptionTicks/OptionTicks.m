classdef OptionTicks < Ticks
%TICKSOPT 期权的Ticks类，在Ticks类上衍生的子类，核心类
% 原用Ticks直接记录期权信息，不够用
% 程刚；140616
    
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        optCode; % 这个代码：'510050C1407M1500'
        optType;  % 'call' , 'put', 'exotic'
        adjustCode; % 调整的编码， 'A', 'B', 'M'
        underCode; % 正股代码
        underName; % 正股名称
        underType; % 正股类型
        underTicks; % 正股Ticks数据（指针）
        underHisVol; % 正股历史volatility
        strikeCode; % 如，3750
        expCode; % 如1407
        strike;  % K，如37.5
%         expDate; % 到期日，如735766
        expDate2; % 到期日，yyyymmdd
        naturalT; % 距离到期日多少自然日
        tradingT; % 距离到期日多少交易日
        rfr; % 无风险利率，暂时为标量      
        
    end
    
    methods(Access = 'public', Static = false, Hidden = false)
        % constructor
        
        % 自动填充一些域
        [ obj ] = fillUnder(obj); 
        [ obj ] = fillTK(obj);
        
        
    end
    
end

