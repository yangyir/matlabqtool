function calc_selection_to_structure(self)
% 将期权的选择转换为Structure组合构造
% 吴云峰 20170330

% 看涨期权的行情的数据
m2tkCallQuote   = self.m2tkCallQuote;
% 看跌期权的行情的数据
m2tkPutQuote    = self.m2tkPutQuote;        
% 合约到期时间
portfolio_T_idx = self.portfolio_T_idx;        
% 合约的执行价
portfolio_K_idx = self.portfolio_K_idx;         
% 合约的数量
portfolio_amt   = self.portfolio_amt;
% 合约的认购认沽性质
portfolio_CPs   = self.portfolio_CPs;     


% 基于信息获得数据
opts_    = QuoteOpt;
opts_(1) = [];
pricers_      = OptPricer;
pricers_( 1 ) = [];


for t = 1:length( portfolio_amt )

    % k
    iK_  = portfolio_K_idx(t);
    % t
    iT_  = portfolio_T_idx(t);
    % CP
    iCP_ = portfolio_CPs{t};
    % amt
    optNum_ = portfolio_amt(t);
    
    
    switch iCP_
        case {'call','Call','C','c','认购'}
            optQuote_ = m2tkCallQuote.data( iT_ , iK_ );
            if optQuote_.is_obj_valid
                opts_(end+1)    = optQuote_;
                if optNum_ > 0 
                    pricers_(end+1) = optQuote_.QuoteOpt_2_OptPricer( 'last' );
                else         
                    pricers_(end+1) = optQuote_.QuoteOpt_2_OptPricer( 'last' );
                end
            end
        case {'put','Put','P','p','认沽'}
            optQuote_ = m2tkPutQuote.data( iT_ , iK_ );
            if optQuote_.is_obj_valid
                opts_(end+1)    = optQuote_;
                if optNum_ > 0 
                    pricers_(end+1) = optQuote_.QuoteOpt_2_OptPricer( 'last' );
                else         
                    pricers_(end+1) = optQuote_.QuoteOpt_2_OptPricer( 'last' );
                end
            end
    end
    
end

if ~isempty( opts_ )
    s = Structure;
    s.num        = portfolio_amt;
    s.optInfos   = opts_;
    s.optPricers = pricers_;
    self.s       = s;
else
    st = Structure;
    st(1)  = [];
    self.s = st;
end








end