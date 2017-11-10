classdef OptStraddleTradingMulti < handle
    % ��Counter�Ͷ�Book�Ĳ���:��OptStraddleTrading�Ĳ���
    % -----------------
    % ���Ʒ� 20161121 ����containers.Map����,KeyΪOptStraddleTrading���������,ValueΪOptStraddleTrading����
    % ���Ʒ� 20161127 ��������µ����� place_entrust_opt_proportion(obj, direc, volume, offset, px, proportion);
    % ���Ʒ� 20161221 ���monitor_strangle_delta0_S0��monitor_iv_vega_theta(obj, px_type);
    % ���Ʒ� 20160115 bridge_gap_between_straddle(obj, std_name, prct, proportion);
    % �̸գ�20171010�����С����        function [ ] = monitor_cash_occupied(multi)
    % �̸գ�20171010�����С�������Լ���  []= monitor_cg(self)

    
    
    properties(Access = 'private')
        % ���ı���:OptStraddleTrading������
        optstraddletrading_multi;
    end
    
    properties(Access = 'public')
        % �µ�����
        proportion@double;
        
        % ��ǰѡ�����Ȩ������
        opt@QuoteOpt;
        call@QuoteOpt;
        put@QuoteOpt;
        
        % M2TK
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
        
        % �ϲ���Book
        BookMulti@Book;
    end
    
    methods
        function obj = OptStraddleTradingMulti()
            obj.optstraddletrading_multi = containers.Map('KeyType', 'char', 'ValueType', 'any');
            obj.BookMulti = Book;
        end
        
        %% ����
        
        % ����OptStraddleTrading
        set(obj, optstratrade_name, optstratrade_node);
        
        % ȡ����Ӧ���Ƶ�optstraddletrading
        optstraddletrading_unit = get(obj, optstratrade_name);
        
        % ȡ��Maps�ڵ�����Ԫ�ص�����
        function keys_value = keys(obj)
            keys_value = keys(obj.optstraddletrading_multi);
        end
        
        % ����ƽ������
        entrust_amounts = equal_allocation_amount(obj, volume);
        
        % monitor_strangle_delta0_S0
        function [delta0_S, delta] = monitor_strangle_delta0_S0(self)
            % ����ǿ����������
            delta0_S = 0;
            delta    = 0;
            optstraddletrading_multi_ = self.optstraddletrading_multi;
            if optstraddletrading_multi_.Count == 0, return; end
            % ���multi�ڵĵ�һ��stra���в���
            key_value = keys(optstraddletrading_multi_);
            stra = get(self, key_value{1});
            if isempty(self.call) || isempty(self.put)
                warning('call����put��ԼΪ��')
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
            % ���multi�ڵĵ�һ��stra���в���
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
        
        %% ����ί�е���Ȩ����
        
        [opt] = set_opt(obj, iT, K , type);
        [c]   = set_call(obj, iT, K_call);
        [p]   = set_put(obj, iT, K_put);
        
        %% �µ�����
        
        % ��ͬ��Book�µĵ���ί�еķ�ʽ
        % 1,������Ȩ�ĵ���ί���µ���place_entrust_opt,���չ̶������µ�
        % proportionĬ����ÿ����������,����������˻�����[1 1 1]
        % ����:proportion��ί�еı��ʰ���keys(multi)��Ӧ���˻���������
        % volume��ÿ��OptStraddleTrading�ĵ�λ�µ�����,proportion�Ƕ�Ӧ�ı���
        place_entrust_opt_equal(obj, direc, volume, offset, px);
        % ��ͬBook�µİ��ձ���ί�з�ʽ,����volume��Ӧ���ǵ�λ�µ�����
        % 1,������Ȩ�İ��ձ���ί���µ���ģ��place_entrust_opt
        place_entrust_opt_proportion(obj, direc, volume, offset, px, proportion);
        % place_entrust_opt:����obj.proportion���ʽ����µ�
        place_entrust_opt(obj, direc, volume, offset, px);
        
        
        % 2,���ʵ�buy_once��ģ��buy_once
        buy_once_proportion(obj, volume, offset, rangbu, proportion);
        % buy_once����obj.proportion���ʽ����µ�
        buy_once(obj, volume, offset, rangbu);
        
        
        % 3,���ʵ�sell_once��ģ��sell_once
        sell_once_proportion(obj, volume, offset, rangbu, proportion);
        % sell_once����obj.proportion���ʽ����µ�
        sell_once(obj, volume, offset, rangbu);
        
        
        % 4,��һ�����ѯһ��pendingEntrusts
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
        
        % 5,��һ���󳷵�
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
        
        
        
        %% ���ܲ���
        
        % Book��һ���Ի��ܲ���
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
            
            % 1,�ֱ��ӡ���Ե�Book
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
            
            % 2,�ϲ�book�Ĵ�ӡ
            optstratrade_object            = get(obj, keys_value{1});
            new_optStraddleTrading         = eval(class(optstratrade_object));
            new_optStraddleTrading.book    = obj.merge_books;
            new_optStraddleTrading.quote   = optstratrade_object.quote;
            new_optStraddleTrading.volsurf = optstratrade_object.volsurf;
            new_optStraddleTrading.quoteS  = optstratrade_object.quoteS;
            fprintf('---------------------------�����λ���ռ��--------------------------\n')
            new_optStraddleTrading.monitor_book_risk(S_low, S_high);
            
            % 3,Deltaչʾ
            for straddle_t = 1:nCount
                straddle_name = keys_value{straddle_t};
                optstratrade_object = get(obj, straddle_name);
                total_delta   = optstratrade_object.calc_position_delta;
                fprintf('%s ��λ��DeltaΪ %.4f\n', straddle_name, total_delta)
            end
            total_delta = new_optStraddleTrading.calc_position_delta;
            fprintf('�ܲ�λ DeltaΪ %.4f\n', total_delta);
        end
        
        
        % ��������
        monitor_book_risk_txt( obj, S_low, S_high ); 
        monitor_book_risk_fig( obj, S_low, S_high );
        
        % ������book���а��ձ��ʺͰٷֱȽ���ĥƽ
        bridge_gap_between_straddle(obj, std_name, prct, proportion);
        
    end
    
    
    
    
    
    
    
    
    
    
end