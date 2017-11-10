classdef OptStraddleTradingMulti < handle
    % 多Counter和多Book的操作:多OptStraddleTrading的操作
    % -----------------
    % 吴云峰 20161121 加入containers.Map容器,Key为OptStraddleTrading对象的名称,Value为OptStraddleTrading对象
    % 吴云峰 20161127 加入比率下单函数 place_entrust_opt_proportion(obj, direc, volume, offset, px, proportion);
    % 吴云峰 20161221 添加monitor_strangle_delta0_S0和monitor_iv_vega_theta(obj, px_type);
    % 吴云峰 20160115 bridge_gap_between_straddle(obj, std_name, prct, proportion);
    % 程刚，20171010，添加小函数        function [ ] = monitor_cash_occupied(multi)
    % 程刚，20171010，添加小函数，自己用  []= monitor_cg(self)

    
    
    properties(Access = 'private')
        % 核心变量:OptStraddleTrading的容器
        optstraddletrading_multi;
    end
    
    properties(Access = 'public')
        % 下单比例
        proportion@double;
        
        % 当前选择的期权行情类
        opt@QuoteOpt;
        call@QuoteOpt;
        put@QuoteOpt;
        
        % M2TK
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
        
        % 合并的Book
        BookMulti@Book;
    end
    
    methods
        function obj = OptStraddleTradingMulti()
            obj.optstraddletrading_multi = containers.Map('KeyType', 'char', 'ValueType', 'any');
            obj.BookMulti = Book;
        end
        
        %% 操作
        
        % 设置OptStraddleTrading
        set(obj, optstratrade_name, optstratrade_node);
        
        % 取出对应名称的optstraddletrading
        optstraddletrading_unit = get(obj, optstratrade_name);
        
        % 取出Maps内的所有元素的名称
        function keys_value = keys(obj)
            keys_value = keys(obj.optstraddletrading_multi);
        end
        
        % 数量平均分配
        entrust_amounts = equal_allocation_amount(obj, volume);
        
        % monitor_strangle_delta0_S0
        function [delta0_S, delta] = monitor_strangle_delta0_S0(self)
            % 如果是空则进行清理
            delta0_S = 0;
            delta    = 0;
            optstraddletrading_multi_ = self.optstraddletrading_multi;
            if optstraddletrading_multi_.Count == 0, return; end
            % 针对multi内的第一个stra进行操作
            key_value = keys(optstraddletrading_multi_);
            stra = get(self, key_value{1});
            if isempty(self.call) || isempty(self.put)
                warning('call或者put合约为空')
                return;
            end;
            stra.call = self.call;
            stra.put  = self.put;
            [delta0_S, delta] = stra.monitor_strangle_delta0_S0;
        end
        
        % [] = monitor_iv_vega_theta(obj, px_type);
        function [] = monitor_iv_vega_theta(self, px_type)
            if ~exist('px_type', 'var'), px_type = 'both'; end
            optstraddletrading_multi_ = self.optstraddletrading_multi;
            if optstraddletrading_multi_.Count == 0, return; end;
            % 针对multi内的第一个stra进行操作
            key_value = keys(optstraddletrading_multi_);
            stra = get(self, key_value{1});
            stra.call = self.call;
            stra.put  = self.put;
            stra.monitor_iv_vega_theta(px_type);
        end
        
        function [ summargin ] = monitor_cash_occupied(multi)
           
            marc = multi.call.margin() * multi.call.multiplier;
            marp = multi.put.margin() * multi.put.multiplier;
            summargin = marc + marp;
            fprintf('co%4.0f = C%4.0f + P%4.0f \n', summargin, marc, marp);            
            
        end
        
        function []= monitor_cg(self)
            self.monitor_strangle_delta0_S0;
            self.monitor_iv_vega_theta('both');
            self.monitor_cash_occupied;
        end
        
        %% 设置委托的期权代码
        
        [opt] = set_opt(obj, iT, K , type);
        [c]   = set_call(obj, iT, K_call);
        [p]   = set_put(obj, iT, K_put);
        
        %% 下单操作
        
        % 不同的Book下的等量委托的方式
        % 1,单张期权的等量委托下单：place_entrust_opt,按照固定比例下单
        % proportion默认是每个等量情形,如果有三个账户则是[1 1 1]
        % 输入:proportion，委托的比率按照keys(multi)对应的账户进行设置
        % volume是每个OptStraddleTrading的单位下单数量,proportion是对应的比率
        place_entrust_opt_equal(obj, direc, volume, offset, px);
        % 不同Book下的按照比率委托方式,变量volume对应的是单位下单数量
        % 1,单张期权的按照比率委托下单：模板place_entrust_opt
        place_entrust_opt_proportion(obj, direc, volume, offset, px, proportion);
        % place_entrust_opt:按照obj.proportion比率进行下单
        place_entrust_opt(obj, direc, volume, offset, px);
        
        
        % 2,比率的buy_once：模板buy_once
        buy_once_proportion(obj, volume, offset, rangbu, proportion);
        % buy_once按照obj.proportion比率进行下单
        buy_once(obj, volume, offset, rangbu);
        
        
        % 3,比率的sell_once：模板sell_once
        sell_once_proportion(obj, volume, offset, rangbu, proportion);
        % sell_once按照obj.proportion比率进行下单
        sell_once(obj, volume, offset, rangbu);
        
        
        % 4,逐一对象查询一遍pendingEntrusts
        function query_all_pendingEntrusts( obj )
            nCount = obj.optstraddletrading_multi.Count;
            if nCount == 0
                return;
            end
            
            keys_value = obj.keys;
            for straddle_t = 1:nCount
                optstratrade_obj = get(obj, keys_value{straddle_t});
                ctr  = optstratrade_obj.counter;
                book = optstratrade_obj.book;
                book.query_pendingEntrusts( ctr );
                book.pendingEntrusts.print;
            end
        end
        
        % 5,逐一对象撤单
        function cancel_all_pendingEntrusts( obj )
            nCount = obj.optstraddletrading_multi.Count;
            if nCount == 0
                return;
            end
            
            keys_value = obj.keys;
            for straddle_t = 1:nCount
                optstratrade_obj = get(obj, keys_value{straddle_t});
                ctr  = optstratrade_obj.counter;
                book = optstratrade_obj.book;
                book.cancel_pendingOptEntrusts(ctr);
            end
        end
        
        
        
        %% 汇总操作
        
        % Book的一次性汇总操作
        function book_merge = merge_books(obj)
            nCount = obj.optstraddletrading_multi.Count;
            if nCount == 0
                return;
            end
            book_merge = obj.BookMulti;
            book_merge.positions = PositionArray;
            book_merge.positions.node(1) = [];
            
            keys_value = obj.keys;
            for straddle_t = 1:nCount
                optstratrade_object = get(obj, keys_value{straddle_t});
                pos = optstratrade_object.book.positions;
                for node_t = 1:length(pos.node)
                    one_node = pos.node(node_t);
                    book_merge.positions.try_merge_ifnot_push(one_node.getCopy());
                end
            end
        end
        
        
        function monitor_book_risk_merge(obj, S_low, S_high)
            nCount = obj.optstraddletrading_multi.Count;
            if nCount == 0
                return;
            end
            if ~exist('S_low', 'var')
                S_low = 2.15;
            end
            if ~exist('S_high', 'var')
                S_high = 2.5;
            end
            
            % 1,分别打印各自的Book
            keys_value = obj.keys;
            for straddle_t = 1:nCount
                fprintf('------------------------------%s------------------------------\n', keys_value{straddle_t})
                optstratrade_object = get(obj, keys_value{straddle_t});
                optstratrade_object.monitor_book_risk(S_low, S_high);
                optstratrade_object.book.calc_m2m_pnl_etc;
                optstratrade_object.book.positions
                fprintf('------------------------------------------------------------------\n')
                fprintf('------------------------------------------------------------------\n')
            end
            
            % 2,合并book的打印
            optstratrade_object            = get(obj, keys_value{1});
            new_optStraddleTrading         = eval(class(optstratrade_object));
            new_optStraddleTrading.book    = obj.merge_books;
            new_optStraddleTrading.quote   = optstratrade_object.quote;
            new_optStraddleTrading.volsurf = optstratrade_object.volsurf;
            new_optStraddleTrading.quoteS  = optstratrade_object.quoteS;
            fprintf('---------------------------总体仓位风险监控--------------------------\n')
            new_optStraddleTrading.monitor_book_risk(S_low, S_high);
            
            % 3,Delta展示
            for straddle_t = 1:nCount
                straddle_name = keys_value{straddle_t};
                optstratrade_object = get(obj, straddle_name);
                total_delta   = optstratrade_object.calc_position_delta;
                fprintf('%s 仓位总Delta为 %.4f\n', straddle_name, total_delta)
            end
            total_delta = new_optStraddleTrading.calc_position_delta;
            fprintf('总仓位 Delta为 %.4f\n', total_delta);
        end
        
        
        % 新增函数
        monitor_book_risk_txt( obj, S_low, S_high ); 
        monitor_book_risk_fig( obj, S_low, S_high );
        
        % 将几本book进行按照比率和百分比进行磨平
        bridge_gap_between_straddle(obj, std_name, prct, proportion);
        
    end
    
    
    
    
    
    
    
    
    
    
end