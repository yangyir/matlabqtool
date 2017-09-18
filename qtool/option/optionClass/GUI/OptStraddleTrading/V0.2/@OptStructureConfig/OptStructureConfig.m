classdef OptStructureConfig < handle
    % ��ȨStructure����
    % wuyunfeng 20170330 VERSION 0
    
    
    properties( SetAccess = 'public' , GetAccess = 'public' , Hidden = false )
        % Import
        m2tkCallQuote@M2TK;            % ������Ȩ�����������
        m2tkPutQuote@M2TK;             % ������Ȩ�����������
        curr_biaodi_px  = nan;         % ��ĵļ۸�
        portfolio_T_idx = [];          % ��Լ����ʱ��
        portfolio_K_idx = [];          % ��Լ��ִ�м�
        portfolio_amt   = [];          % ��Լ������
        portfolio_CPs   = {};          % ��Լ���Ϲ��Ϲ�����
        axes_handle     = nan;         % ������ͼ�ľ�� 
        
        % Export
        s@Structure;                   % ��Ȩ�����
        recently_residual_days = nan;  % ���׵�ʣ������
        curr_biaodi_axis_px    = nan;  % ������ˮƽ�ߵĿ̶�ֵ,Ĭ�������嵵�ļ��
        curr_portfolio_cost    = nan;  % ��ǰ��ϵ��ܳɱ�
        curr_portfolio_balance = nan;  % ��ǰ��ϵ��ʽ𾻶�
        curr_portfolio_greeks  = [];   % ��ǰ��ϵ�ϣ����ĸ
    end
    
    methods( Static = false )
        
        % ���캯��
        function self = OptStructureConfig()
            st = Structure;
            st( 1 ) = [];
            self.s  = st;
        end
        
        % ���ڱ���������������ˮƽ�ߵĿ̶�ֵ
        calc_biaodi_axis_px(self, minpx, maxpx, interval);
        % ����δ��Ǳ�ڵĽ�������
        calc_recently_residual_days(self);
        % ����Ȩ��ѡ��ת��Ϊstructure
        calc_selection_to_structure(self);
        
        %{
            ����ɱ��͵�ǰ��ϵ������ʽ𾻶��greeks
            curr_portfolio_cost
            curr_portfolio_balance
            curr_portfolio_greeks
        %}
        calc_structure_base_info(self);
        
        % ����payoff
        [ curr_portfolio_payoff ] = calc_structure_payoff(self, price_level);
        % ����px
        [ curr_portfolio_px ] = calc_structure_px(self, price_level);
        % ���㻭ͼ�ĺ���
        calc_plot_payoff(self, minpx, maxpx, interval, port_balance);
        
    end
    
    methods(Static = true)
       % ��ͼ��������¼�����ص�����
       payoff_pointer_callback(hObject, eventdata, optstruct);
       
    end
    
    
    
  
    
    
end