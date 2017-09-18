function calc_selection_to_structure(self)
% ����Ȩ��ѡ��ת��ΪStructure��Ϲ���
% ���Ʒ� 20170330

% ������Ȩ�����������
m2tkCallQuote   = self.m2tkCallQuote;
% ������Ȩ�����������
m2tkPutQuote    = self.m2tkPutQuote;        
% ��Լ����ʱ��
portfolio_T_idx = self.portfolio_T_idx;        
% ��Լ��ִ�м�
portfolio_K_idx = self.portfolio_K_idx;         
% ��Լ������
portfolio_amt   = self.portfolio_amt;
% ��Լ���Ϲ��Ϲ�����
portfolio_CPs   = self.portfolio_CPs;     


% ������Ϣ�������
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
        case {'call','Call','C','c','�Ϲ�'}
            optQuote_ = m2tkCallQuote.data( iT_ , iK_ );
            if optQuote_.is_obj_valid
                opts_(end+1)    = optQuote_;
                if optNum_ > 0 
                    pricers_(end+1) = optQuote_.QuoteOpt_2_OptPricer( 'last' );
                else         
                    pricers_(end+1) = optQuote_.QuoteOpt_2_OptPricer( 'last' );
                end
            end
        case {'put','Put','P','p','�Ϲ�'}
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