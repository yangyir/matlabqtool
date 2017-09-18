classdef BinomialPricer < handle
    % BinomialPricer �ö��������۷���Ϊ��Ȩ���ۡ�
    % ����payoff_handler�Ǹ����ⲿ��Ʒ�ض��Ķ��۷��������ⲿ���壬����S���õ�payoff��
    % u Ϊdelta t ��ļ۸����Ƿ��ȣ�d Ϊ�۸��½����ȡ�
    % ����ֵ��u = exp (sigma * dt^0.5), d = exp(-sigma * dt^0.5)
    properties
        type_@char = 'Europe'; % Europe Ϊŷʽ��Ȩ����America��Ϊ��ʽ��Ȩ
        S_@double = 1; % asset_price
        P_@double = 1; % probability of S_
        f_@double = NaN;   % option price at S_, sometimes it equals to payoff at S_;
        t_@double = 0;     % time
        T_@double = 3;    
        u_@double = 1.1;  % up rate 
        d_@double = 0.9;  % down rate
        r_@double = 0.05; % risk free rate
        p_@double = NaN;  % up probability;
        q_@double = NaN;  % down probability;
        up_child = [];
        down_child = [];
        younger_brother = [];
        parent = [];
        knock_off_handler = @BinomialPricer.knock_out_nop;
        payoff_handler = @BinomialPricer.payoff_nop;
    end
    
    methods (Static)
        function [p] = payoff_nop(S)
            p = randi(2,1);
        end
        
        function [ret] = knock_out_nop(S)
            ret = false;
        end
    end
    
    methods
        function [obj] = set_params_from_optPricer(obj, opt)
            % ��OptInfo����ȡ��Ϣ������element
            if isa(opt, 'OptInfo')
                %option_info �ڰ����е�����,sigma, risk free rate ����Ϣ
                obj.T_ = opt.T - opt.currentDate;
                obj.S_ = opt.S;
                obj.u_ = exp(opt.sigma * sqrt(1/365));
                obj.d_ = exp(-opt.sigma * sqrt(1/365));
            end
        end
    end
    
    %% print Methods
    methods
        function print_layer(obj)
            obj.print_self();
            probe_element = obj;
            while(~isempty(probe_element.younger_brother))
                probe_element.younger_brother.print_self();
                probe_element = probe_element.younger_brother;
            end
            probe_element = obj;
            if(~isempty(probe_element.up_child))
                probe_element = probe_element.up_child;
                probe_element.print_layer();
            end
        end
        
        function [up_depth, down_depth] = depth(obj)
            up_depth = 0;
            down_depth = 0;
            probe_element = obj;
            while(~isempty(probe_element.up_child))                
                probe_element = probe_element.up_child;
                up_depth = up_depth + 1;
            end

            probe_element = obj;
            while(~isempty(probe_element.down_child))
                probe_element = probe_element.down_child;
                down_depth = down_depth + 1;
            end
        end
        
        function print_self(obj)
            % print self
            disp_str = sprintf('layer = %d, S = %f, P = %f f = %f. \n', obj.t_, obj.S_, obj.P_, obj.f_);
            disp(disp_str);            
        end        
        
        function [node] = print_element_by_layer_i(obj, layer, index)
            % ���㵼����չʾ��ȡ�õ�layer���i��Ԫ��
            probe_element = obj;
            for i = 1 : layer
               probe_element = probe_element.up_child;
            end
            
            for i = 2 : index
                probe_element = probe_element.younger_brother;
            end
            node = probe_element;
            disp(node);
        end
    end
        
    %% calculating methods
    methods
        function update_from_base(obj, base, rate, p)
            obj.type_ = base.type_;
            obj.S_ = base.S_ * rate;
            obj.P_ = base.P_ * p;
            obj.t_ = base.t_ + 1;
            obj.p_ = base.p_;
            obj.q_ = base.q_;
            obj.T_ = base.T_;
            obj.u_ = base.u_;
            obj.d_ = base.d_;
            obj.parent = base;
            obj.payoff_handler = base.payoff_handler;
        end
        
        function update_self_payoff(obj)
            if(isempty(obj.up_child) || isempty(obj.down_child))
                payoff = obj.payoff_handler(obj.S_);
                obj.f_ = payoff;                
            else
                price = obj.p_ * obj.up_child.f_ + obj.q_ * obj.down_child.f_;
                payoff = obj.payoff_handler(obj.S_);
                % ���֣�
                if(strcmp(obj.type_, 'Europe'))
                    obj.f_ = exp(- (obj.r_ * 1/365)) * price;
                else
                % ��ʽ��Ȩ������ʱ��Ȩ�������ڼ���۸�ʱ��Ҫȡpayoff��price֮��Ĵ���
                    obj.f_ = max(payoff, exp(- (obj.r_ * 1/365)) * price);                
                end
            end
        end
        
        function [f] = calc_price_recusive(obj)
            % �ݹ鷽ʽ��payoff��Ч����ͣ��ڵݹ���Ȳ��������£�������Ϊ��֤��ȷ�ԵĲο������ʺ�����������
            if(isempty(obj.up_child) || isempty(obj.down_child))
                payoff = obj.payoff_handler(obj.S_);
                obj.f_ = payoff;
            else
                price = obj.p_ * calc_price_recusive(obj.up_child) + obj.q_ * calc_price_recusive(obj.down_child);
                payoff = obj.payoff_handler(obj.S_);
                % ���֣�
                if(strcmp(obj.type_, 'Europe'))
                    obj.f_ = exp(- (obj.r_ * 1/365)) * price;
                else
                % ��ʽ��Ȩ������ʱ��Ȩ�������ڼ���۸�ʱ��Ҫȡpayoff��price֮��Ĵ���
                    obj.f_ = max(payoff, exp(- (obj.r_ * 1/365)) * price);                
                end
            end
            f = obj.f_;
        end
        
        function [f] = calc_price(obj)
            % ������ʽ����payoff
            % go to leaf layer
            probe_element = obj;
            while(~isempty(probe_element.up_child))
                probe_element = probe_element.up_child;
            end
            
            leaf_elder_brother = probe_element; %��¼�µ�һ��Ҷ�ӽڵ�
            
            % calc leaf payoff
            probe_element.f_ = probe_element.payoff_handler(probe_element.S_);
            while(~isempty(probe_element.younger_brother))
                probe_element = probe_element.younger_brother;
                probe_element.f_ = probe_element.payoff_handler(probe_element.S_);
            end
            
            % go back to elder brother of leaf layer
            parent_probe = leaf_elder_brother.parent;
            
            % calc self payoff
            while(~isempty(parent_probe.parent)) %��������ӽڵ�������������
                parent_probe.update_self_payoff();
                brother = parent_probe;
                while(~isempty(brother.younger_brother))
                    brother = brother.younger_brother;
                    brother.update_self_payoff();
                end
                parent_probe = parent_probe.parent;
            end       
            
            %���ڵ�
            parent_probe.update_self_payoff();
            f = obj.f_;
        end
        
        function merge_element_with_brother(obj, brother)
            obj.P_ = obj.P_ + brother.P_;
            obj.younger_brother = brother.younger_brother;
            brother.younger_brother = [];            
        end
        
        function [obj] = forward_T_step(obj)
            for i = 1:obj.T_
                obj.forward_one_step();
            end
        end
        
        function [obj] = forward_one_step(obj)
            % find elder brother at leaf gen
            probe_element = obj;
            while(~isempty(probe_element.up_child))
                probe_element = probe_element.up_child;
            end
            
            if(probe_element.t_ < probe_element.T_)
                % generator next generation
                % �����е��ֵܶ���ǰһ��������С�ĵܵܿ�ʼ�ݹ�
                if ~(isempty(probe_element.younger_brother))
                    probe_element.younger_brother.forward_one_step();
                end                
                probe_element.generate_children(obj.u_,obj.d_,obj.r_);
                
                % merge childrens
                % ����С�ĵܵܿ�ʼ���ֳ����ϲ����
                if ~(isempty(probe_element.younger_brother))
                    probe_element.merge_children_with_brother(probe_element.younger_brother);
                end                    
            end
        end
        
        function [obj] = generate_children(obj, u, d, r)
            if(isempty(obj.up_child) && isempty(obj.down_child))
                if(isnan(obj.p_) || isnan(obj.q_))
                    [obj.p_, obj.q_] = BinomialElementGenerator.calc_probability(u, d, 1, r);
                end
                obj.up_child = BinomialPricer;
                obj.up_child.update_from_base(obj, u, obj.p_);
                obj.down_child = BinomialPricer;
                obj.down_child.update_from_base(obj, d, obj.q_);
                obj.up_child.younger_brother = obj.down_child;
            end
        end
        
        function [obj] = merge_children_with_brother(obj, brother)
            % Լ��Brother����Լ���ϲ�����Ϊ�ֺϲ���
            % ֻ���ֳ��Ĵ����п��ܺ͵ܵܵĳ���һ�����ֳ��ĳ��ӿ϶����ڵܵܵĳ��Ӻʹ��ӡ�                        
            if(abs(obj.down_child.S_ - brother.up_child.S_) <= exp(-8))
                % �ϲ��ܵܳ��ӵ��ֳ�������
                obj.down_child.merge_element_with_brother(brother.up_child);
                clear_element = brother.up_child;
                brother.up_child = obj.down_child;
                delete(clear_element);
            else
                str = sprintf('down child %f not equal to brothers up child %f. child_layer:%d\n', obj.down_child.S_, brother.up_child.S_, obj.down_child.t_);
                disp(str);
            end
        end
    end
    
    %% pricer test
    methods (Static = true)
        demo
    end
end