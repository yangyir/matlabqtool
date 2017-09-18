classdef OptStructureConfig < handle
    % 期权Structure配置
    % wuyunfeng 20170330 VERSION 0
    
    
    properties( SetAccess = 'public' , GetAccess = 'public' , Hidden = false )
        % Import
        m2tkCallQuote@M2TK;            % 看涨期权的行情的数据
        m2tkPutQuote@M2TK;             % 看跌期权的行情的数据
        curr_biaodi_px  = nan;         % 标的的价格
        portfolio_T_idx = [];          % 合约到期时间
        portfolio_K_idx = [];          % 合约的执行价
        portfolio_amt   = [];          % 合约的数量
        portfolio_CPs   = {};          % 合约的认购认沽性质
        axes_handle     = nan;         % 用于作图的句柄 
        
        % Export
        s@Structure;                   % 期权的组合
        recently_residual_days = nan;  % 交易的剩余天数
        curr_biaodi_axis_px    = nan;  % 坐标轴水平线的刻度值,默认左右五档的间隔
        curr_portfolio_cost    = nan;  % 当前组合的总成本
        curr_portfolio_balance = nan;  % 当前组合的资金净额
        curr_portfolio_greeks  = [];   % 当前组合的希腊字母
    end
    
    methods( Static = false )
        
        % 构造函数
        function self = OptStructureConfig()
            st = Structure;
            st( 1 ) = [];
            self.s  = st;
        end
        
        % 基于标的行情计算坐标轴水平线的刻度值
        calc_biaodi_axis_px(self, minpx, maxpx, interval);
        % 计算未来潜在的交易天数
        calc_recently_residual_days(self);
        % 将期权的选择转换为structure
        calc_selection_to_structure(self);
        
        %{
            计算成本和当前组合的买卖资金净额和greeks
            curr_portfolio_cost
            curr_portfolio_balance
            curr_portfolio_greeks
        %}
        calc_structure_base_info(self);
        
        % 计算payoff
        [ curr_portfolio_payoff ] = calc_structure_payoff(self, price_level);
        % 计算px
        [ curr_portfolio_px ] = calc_structure_px(self, price_level);
        % 计算画图的函数
        calc_plot_payoff(self, minpx, maxpx, interval, port_balance);
        
    end
    
    methods(Static = true)
       % 作图的鼠标点击事件处理回调函数
       payoff_pointer_callback(hObject, eventdata, optstruct);
       
    end
    
    
    
  
    
    
end