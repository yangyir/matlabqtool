classdef BinomialPricer < handle
    % BinomialPricer 用二叉树定价方法为期权定价。
    % 其中payoff_handler是根据外部产品特定的定价方法，由外部定义，输入S，得到payoff。
    % u 为delta t 后的价格上涨幅度，d 为价格下降幅度。
    % 理论值：u = exp (sigma * dt^0.5), d = exp(-sigma * dt^0.5)
    properties
        type_@char = 'Europe'; % Europe 为欧式期权，‘America’为美式期权
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
            % 从OptInfo里提取信息，放入element
            if isa(opt, 'OptInfo')
                %option_info 内包含有到期日,sigma, risk free rate 等信息
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
            % 按层导航，展示并取得第layer层第i个元素
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
                % 折现：
                if(strcmp(obj.type_, 'Europe'))
                    obj.f_ = exp(- (obj.r_ * 1/365)) * price;
                else
                % 美式期权可以随时行权，所以在计算价格时需要取payoff和price之间的大者
                    obj.f_ = max(payoff, exp(- (obj.r_ * 1/365)) * price);                
                end
            end
        end
        
        function [f] = calc_price_recusive(obj)
            % 递归方式求payoff，效率奇低，在递归深度不大的情况下，可以作为验证正确性的参考，不适合用于生产。
            if(isempty(obj.up_child) || isempty(obj.down_child))
                payoff = obj.payoff_handler(obj.S_);
                obj.f_ = payoff;
            else
                price = obj.p_ * calc_price_recusive(obj.up_child) + obj.q_ * calc_price_recusive(obj.down_child);
                payoff = obj.payoff_handler(obj.S_);
                % 折现：
                if(strcmp(obj.type_, 'Europe'))
                    obj.f_ = exp(- (obj.r_ * 1/365)) * price;
                else
                % 美式期权可以随时行权，所以在计算价格时需要取payoff和price之间的大者
                    obj.f_ = max(payoff, exp(- (obj.r_ * 1/365)) * price);                
                end
            end
            f = obj.f_;
        end
        
        function [f] = calc_price(obj)
            % 迭代方式计算payoff
            % go to leaf layer
            probe_element = obj;
            while(~isempty(probe_element.up_child))
                probe_element = probe_element.up_child;
            end
            
            leaf_elder_brother = probe_element; %记录下第一个叶子节点
            
            % calc leaf payoff
            probe_element.f_ = probe_element.payoff_handler(probe_element.S_);
            while(~isempty(probe_element.younger_brother))
                probe_element = probe_element.younger_brother;
                probe_element.f_ = probe_element.payoff_handler(probe_element.S_);
            end
            
            % go back to elder brother of leaf layer
            parent_probe = leaf_elder_brother.parent;
            
            % calc self payoff
            while(~isempty(parent_probe.parent)) %从最深层子节点向根做层序遍历
                parent_probe.update_self_payoff();
                brother = parent_probe;
                while(~isempty(brother.younger_brother))
                    brother = brother.younger_brother;
                    brother.update_self_payoff();
                end
                parent_probe = parent_probe.parent;
            end       
            
            %根节点
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
                % 让所有的兄弟都向前一代，从最小的弟弟开始递归
                if ~(isempty(probe_element.younger_brother))
                    probe_element.younger_brother.forward_one_step();
                end                
                probe_element.generate_children(obj.u_,obj.d_,obj.r_);
                
                % merge childrens
                % 从最小的弟弟开始往兄长处合并后代
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
            % 约定Brother方向，约定合并方向为兄合并弟
            % 只有兄长的次子有可能和弟弟的长子一样大，兄长的长子肯定大于弟弟的长子和次子。                        
            if(abs(obj.down_child.S_ - brother.up_child.S_) <= exp(-8))
                % 合并弟弟长子到兄长次子中
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