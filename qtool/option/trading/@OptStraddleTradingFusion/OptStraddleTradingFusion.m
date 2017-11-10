classdef OptStraddleTradingFusion  < handle
%OPTSTRADDLETRADING Summary of this class goes here
% -----------------
% cg, 20160320, ����opt@QuoteOpt, set_opt(), trade_opt(), �������׵�Ʊ
% ���Ʒ壬20161114������һ�����
% error_entrust_amount = clear_holding( obj, pct, times, competitor_rank,round_interval); [ÿ��ί��ʹ�価���ɽ�]
% error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank); [���ݲ�λʣ������ʽ����ί��ƽ��]
% cg, 20161114, �޸���S0ʱ������Χ�����⣬ �ڣ�
% monitor_strangle_delta0_S0(obj)�� monitor_book_risk(obj, S_low, S_high); 
% Delta�Գ�һ�����µ�:������Ȩ�ֲ�Delta��total_delta = calc_position_delta(obj);������Delta��biaodi_delta = calc_biaodi_delta(obj)
% �ֶ�delta hedge,���ڰٷֱ�һ���Ե���Delta��success = doonce_delta_hedge( obj, opt_delta, biaodi_delta, pct, competitor_rank);
% ���Ʒ�,20161117, �����ֶ�delta hedge,���ڰٷֱ�һ���Ե���Delta
% �콭��20161123�� ����ͨ�����飬ͨ�ù�̨���롣
% ���Ʒ� 20161222 ������Ȩ�Գ庯��doonce_delta_hedge_ByOpt(self, monthsel, one_amount, call_putflag, threshold, opposite)
% ���Ʒ� 20161229 ���Ӳ𵥹��ܺ���:�����һ����������ʡ�ԣ��� buy_once sell_once trade_once���в𵥴���
% place_entrust_opt_apart(obj, direc, volume, offset, px);  place_entrust_opt���в𵥷�װ
% trade_opt_apart(obj, direc, volume, offset, px);          trade_opt���в𵥷�װ
% buy_once/sell_once/trade_once���Բ��µ�
% ���Ʒ� 20170105 ���Ӷ�book/��Counter straddle/strangle�����µ����� openfire����
% ���Ʒ� 20170115 ������StraddleTrading����ĥƽһ����ί�к��� bridge_gap_entrust(std_stra, com_stra, prct, rate, opposite); 
% ���Ʒ� 20170508 ����Straddle��Break Even Point��������:calcStraddleFixedBEP ; calcStraddleDynamicBEP ; plotStraddleDynamicBEP;
        
        
    % ���Ա����еĹ�����
    % ���Ե�ʱ��public��Ϊ�˷���
    properties(SetAccess = 'public', Hidden = false) 
        % �˻���Ϣ, ��ʼ�����ٸĶ�
        counter;          % ��̨
        book@Book = Book; % Ͷ�������Ϣ��ֻ�����¼��������ˣ�ԭ���ϲ���������߼�          
        
        % ��Ȩ����
        quote;
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
        volsurf; % vol surface[volsurf@VolSurface;]
        
        % OptionOne;
        m2tkCallOne@M2TK;
        m2tkPutOne@M2TK;
        
        % �ֻ�����, 50ETF
        counterS;
        bookS@Book;
        quoteS@QuoteStock;
        
        % deltaHedge[dher1@Deltahedging;]
        dher2@Deltahedging2;
    end
    
    
    %********************** ��������ı��� **********************%
    properties
        % һЩ�򵥼�¼
        call@QuoteOpt;
        put@QuoteOpt;
        opt@QuoteOpt;
        S;
        % optNear@QuoteOpt; % ���ڲ�����
        % optFar@QuoteOpt;
        
        % OptionOne, ���Թҵ���
        callOne@OptionOne;
        putOne@OptionOne;
        optOne@OptionOne;
    end

    methods
         
        %% �������� �� ��ѯ���� 
        [hfig] = plot_theoritical_analysis(obj, Smin, Smax);
        [] = monitor_iv_vega_theta(obj, px_type);
        [] = monitor_book_risk(obj, S_low, S_high);
        monitor_book_risk_txt( obj, S_low, S_high );            % ��monitor_book_risk���в��Ϊtxt
        monitor_book_risk_fig( obj, S_low, S_high, h_parent );  % ��monitor_book_risk���в��Ϊfig
        monitor_kuaqi(obj)
        [newobj] = getCopy(obj);
        
        %------------- ÿ��һ��ʱ����ʾһ�£����׸��ٵ���Ϣ -------------%
        function monitor(obj)
            % ȡ��λ�ļ۸�ȡ��ǰ�Ĳ�λ���㵱ǰ��λ��m2m�����ղ����߼���ϣ�����ʾ���� 
            curr_book         = obj.book;
            curr_position     = curr_book.positions;
            finished_entrusts = curr_book.finishedEntrusts;
            
            % ���︺��֤quote�����鳩ͨ���ɣ����ؼ���
            for i = 1:length(curr_position.node)
                position_node = curr_position.node(i);
                opt_quote     = position_node.quote;
                
                % ��H5������£���Ҫinitʱ����H5����
                % ������²�̫��ʱ���þ�ȡ����
                while 1
                    opt_quote.fillQuote;
                    if opt_quote.askQ1 > 0
                        break;
                    else
                        disp('��Ȩ����δ�ӵ�');
                        pause(1);
                    end
                end
            end
            
            curr_book.calc_m2m_pnl_etc();
            curr_position.print;
            finished_entrusts.print;
        end
        
        
        %------------- ��ȡstrangle��delta0��s0���� -------------%
        function [delta0_S, delta] = monitor_strangle_delta0_S0(obj)
            % ����straddle structure
            s = Structure;
            s.volsurf = obj.volsurf;
            S     = obj.quoteS.last;
            obj.S = S;
            s.S   = S;
            
            % ��QuoteOptת��OptPricer���Թ����������
            call = obj.call.QuoteOpt_2_OptPricer('bid');
            put  = obj.put.QuoteOpt_2_OptPricer('bid');
            
            s.optPricers(1) = put;
            s.optPricers(2) = call;
            s.num = [1,1];
            s.inject_environment_params;
            
            % ��delta==0 ��S��
            [delta0_S, delta] = s.calc_delta0_S0(0.5*S, 1.5*S, 0.001);
            fprintf('S0=%0.3f,  delta0=%0.4f\n', delta0_S, delta);
        end
        
        %------------- �ල��ǰ�Ĳ�λ -------------%
        function monitor_positions(obj)
            % ȡ��ǰ�Ĳ�λ���㵱ǰ��λ��m2m
            % ȡ��λ�ļ۸�
            b    = obj.book;
            pa   = b.positions;
            b.calc_m2m_pnl_etc();
            pa.print;
        end
        
        %------------- ��һ��ѯһ��pendingEntrusts -------------%
        function query_book_pendingEntrusts( obj )
            % ��һ��ѯһ��pendingEntrusts
            ctr = obj.counter;
            book = obj.book;
            book.query_pendingEntrusts( ctr );
        end
        
        
        %% ���ú��� �� ������
        [c]   = set_call(obj, iT, K_call)
        [p]   = set_put(obj, iT, K_put)
        [opt] = set_opt(obj, iT, K , type);
        
        
        function init_all(stra)
            %% ��ʼ������strat����counter�� book�� quote
        end
        
        % ��ĩ���رղ���
        function end_day(obj)
            % obj.counter.logout;
            obj.book.eod_virtual_cancel_all_pendingEntrusts(obj.counter);
            obj.book.eod_netof_positions
            obj.book.toExcel;
        end
        
        function set_counters(obj)
            % ��һ��m2tkCallOne��m2tkPutOne�������µ�counter
            % ˼����OptionOne��handle���࣬������޸Ļ�������˴���Ӱ�죡��
            % ��ʱֻ��һ��counter�������н��ף�û�󰭣��Ժ�һ��Ҫ��
            L = length( obj.m2tkCallOne.xProps);
            for iT = 1:4
                for iK = 1:L
                    obj.m2tkCallOne.data(iT, iK).counter = obj.counter;
                    obj.m2tkPutOne.data(iT, iK).counter  = obj.counter;
                end
            end
        end
        
       
        %% �µ�����(����,�𵥲���)
        
        [e] = place_entrust_opt(obj, direc, volume, offset, px);
        trade_opt(obj, direc, volume, offset, px);
        
        function trade_once(obj, volume, direc, offset, rangbu)
            if ~exist('direc', 'var'),     direc = '1';  end
            if ~exist('volume','var'),     volume = 1;   end
            if ~exist('offset', 'var'),    offset = '1'; end
            if ~exist('rangbu', 'var'),    rangbu = 1;   end
            call = obj.call;
            put  = obj.put;
            if isempty(call) || isempty(put)
                error('call����put��ԼΪ��')
            end
            ctr  = obj.counter;
            ctr  = { ctr };
            book = obj.book;
            obj.openfire_tmp(ctr, book, call, put, volume, direc, offset, rangbu, 1);
        end
        
        function buy_once(obj, volume, offset, rangbu)
            direc   = '1';
            if ~exist('volume','var'),     volume = 1;      end
            if ~exist('offset', 'var'),    offset = '1';    end
            if ~exist('rangbu', 'var'),     rangbu = 1;     end
            call = obj.call;
            put  = obj.put;
            if isempty(call) || isempty(put)
                error('call����put��ԼΪ��')
            end
            ctr  = obj.counter;
            ctr  = { ctr };
            book = obj.book;
            obj.openfire_tmp(ctr, book, call, put, volume, direc, offset, rangbu, 1);
        end
        
        function sell_once(obj, volume, offset, rangbu)
            direc   = '2';
            if ~exist('volume','var'),     volume = 1;      end
            if ~exist('offset', 'var'),    offset = '1';    end
            if ~exist('rangbu', 'var'),     rangbu = 1;     end
            call = obj.call;
            put  = obj.put;
            if isempty(call) || isempty(put)
                error('call����put��ԼΪ��')
            end
            ctr  = obj.counter;
            ctr  = { ctr };
            book = obj.book;
            obj.openfire_tmp(ctr, book, call, put, volume, direc, offset, rangbu, 1);
        end
        
        % �����𵥺���
        place_entrust_opt_apart(obj, direc, volume, offset, px); % place_entrust_opt���в𵥷�װ
        trade_opt_apart(obj, direc, volume, offset, px);         % trade_opt���в𵥷�װ
        
        
        function buyclose_call_sellopen_put(obj, volume, rangbu)
            call_direct = '1';
            call_offset = '2';
            put_direct  = '2';
            put_offset  = '1';
            call = obj.call;
            put  = obj.put;
            
            e = Entrust;
            mktNo   = '1';
            stkCode = num2str( opt.code );
            if ~exist('px', 'var')
                % ����quoteOpt
                % ��H5������£���Ҫinitʱ����H5����
                opt.fillQuote;
                
                % Ĭ��ȡ�Լ�
                if strcmp(direc, '1')
                    px = opt.askP1;
                elseif strcmp(direc, '2')
                    px = opt.bidP1;
                end
            end
            
            e.fillEntrust(mktNo, stkCode, direc, px, volume, offset, opt.optName);
        end
        
        function openfire(obj, volume, direc, offset, rangbu )
            % ȡ��ǰS
            % ȡ�����K1��K2����ϣ���gamma
            % ��ʱ���ֶ�ָ��һ��call�� һ��put
            % rangbu���ò����ȣ�ֵ��0, 1��, 0�����������1���ǶԼۣ�Ĭ�ϣ���0.5�����м��
            
            if ~exist('direc', 'var'),    direc = '1';    end
            if ~exist('volume','var'),    volume = 1; end
            if ~exist('offset', 'var'),    offset = '1';    end
            if ~exist('rangbu', 'var'),     rangbu = 0.8;   end
            
            put = obj.put;
            call = obj.call;
            
            % ����quoteOpt
            % ��H5������£���Ҫinitʱ����H5����
            % ������²�̫��ʱ���þ�ȡ����
            while 1
                call.fillQuote;
                put.fillQuote;
                if call.askQ1>0 && put.askQ1>0
                    break;
                else
                    disp('��Ȩ����δ�ӵ�');
                    pause(1);
                end
            end
            
            % �µ�
            ctr = obj.counter;
            book = obj.book;
            
            aimVolumeCall   = volume;
            aimVolumePut    = volume;
            
            while aimVolumeCall > 0  || aimVolumePut > 0
                
                % ����quoteOpt
                % ��H5������£���Ҫinitʱ����H5����
                call.fillQuote;
                put.fillQuote;
                
                % ���entrust, 2��
                e1      = Entrust;
                mktNo   = '1';
                stkCode = num2str( call.code );
                vo      = aimVolumeCall;
                nm      = call.optName(end-6:end);
                if strcmp(direc, '1')
                    px      = call.askP1 * rangbu + call.bidP1 *(1-rangbu);
                elseif strcmp(direc, '2')
                    px      = call.bidP1 * rangbu + call.askP1*(1-rangbu);
                end
                e1.fillEntrust(mktNo, stkCode, direc, px, vo, offset, nm);
                
                e2      = Entrust;
                mktNo   = '1';
                stkCode = num2str(  put.code );
                vo      = aimVolumePut;
                nm      = put.optName(end-6:end);
                if strcmp(direc, '1')
                    px  = put.askP1*rangbu + put.bidP1*(1-rangbu);
                elseif strcmp(direc, '2')
                    px  = put.bidP1*rangbu + put.askP1*(1-rangbu);
                end
                e2.fillEntrust(mktNo, stkCode, direc, px, vo, offset, nm);
                
                % TODO��������ȯ
                % �µ�
                % �µ���������ѵ�������book.pendingEntrusts
                ems.place_optEntrust_and_fill_entrustNo(e1, ctr);
                book.pendingEntrusts.push(e1);
                
                ems.place_optEntrust_and_fill_entrustNo(e2, ctr);
                book.pendingEntrusts.push(e2);

                %%  ����book.pendingEntrusts ��һ��ѯ״̬��
                % ֻ�����������״̬��������
                
                % ��ѯ3�Σ����򳷵� ( ���������������̫���ˣ�
                iter_wait = 1;
                while ~e1.is_entrust_closed || ~e2.is_entrust_closed
                    if iter_wait > 3
                        if ~e1.is_entrust_closed
                            % ��һ�����ڵļ۸����û�б仯���Ͳ����������򣬳���
                            call.fillQuote;
                            if strcmp(direc, '1')
                                px = call.askP1 * rangbu + call.bidP1 *(1-rangbu);
                            elseif strcmp(direc, '2')
                                px = call.bidP1 * rangbu + call.askP1*(1-rangbu);
                            end
                            
                            if abs(px - e1.price) >=0.00005
                                ems.cancel_optEntrust_and_fill_cancelNo(e1, ctr);
                                disp('e1���г���');
                            else
                                disp('e1�۸�δ�䣬�����ҵ�');
                            end
                            
                        end
                        if ~e2.is_entrust_closed
                            put.fillQuote;
                            if strcmp(direc, '1')
                                px  = put.askP1*rangbu + put.bidP1*(1-rangbu);
                            elseif strcmp(direc, '2')
                                px  = put.bidP1*rangbu + put.askP1*(1-rangbu);
                            end
                            
                            if abs( px - e2.price ) >=0.00005
                                ems.cancel_optEntrust_and_fill_cancelNo(e2, ctr);
                                disp('e2���г���');
                            else
                                disp('e2�۸�δ�䣬�����ҵ�');
                            end
                        end
                    end
                    pause(1);
                    ems.query_optEntrust_once_and_fill_dealInfo(e1, ctr);
                    ems.query_optEntrust_once_and_fill_dealInfo(e2, ctr);
                    iter_wait = iter_wait + 1;
                end
                
                % ������ˣ�˵����entrust��close����Ҫ��¼
                book.sweep_pendingEntrusts;
                
                % ͬʱ��׼����һ���µ�
                aimVolumeCall = e1.cancelVolume;
                aimVolumePut  = e2.cancelVolume;
                % aimVolumePut  = 0;
            end
            % �����while����������һ��order��������ˣ���¼
            % ������book���¼�ˣ�book��ÿһ��entrust�����˼�¼
            % ��Ҫ��Ҫ�ڲ����߼����¼
            % obj.book.toExcel;
        end
        
        function place_e(obj)
        end
        function guadan(obj)
        end
        
        %{
        1��clear_holding( obj, pct, times, competitor_rank, round_interval);
        һ����ֺ���[ÿ��ί��ʹ�価���ɽ�]
        �������:pct�ٷֱ�[0~100],timesƽ�ֵ���������,competitor_rank���ּ۸���,round_intervalÿ�ֽ�����ļ��
        �������:δ��ί�гɹ��������ʹ���
        2��error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank);
        һ����ֺ���[���ݲ�λʣ������ʽ����ί�гɽ�]
        �������:pct�ٷֱ�[0~100],timesƽ�ֵ���������,competitor_rank���ּ۸���
        �������:δ��ί�гɹ��������ʹ���
        ���Ʒ� 20161111 ÿ��ί��ʹ�価���ɽ�
        ���Ʒ� 20161115 ���ݲ�λʣ������ʽ����ί��ƽ��
        %}
        error_entrust_amount = clear_holding(obj, pct, times, competitor_rank, round_interval);
        error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank);
        
        %{ 
        ����һ��delta hedge,�����ߣ�
        1,����һ���Լ��㵱ǰ������Ȩ�ʲ���Delta
        2,�ټ���bookS������Delta
        3,�����ݵ�ǰ��ĳֲ�Delta����Delta�Գ�
        ���Ʒ� 20161116
        %}
        % 1,���㵱ǰ������Ȩ�ʲ���Delta:�������,total_delta��������Ȩ��λ��Delta
        function total_delta = calc_position_delta(obj)
            %----------- 1,��ʼ����Ϣ -----------%
            my_book      = obj.book;
            my_positions = my_book.positions;
            pos_node     = my_positions.node;
            total_delta  = 0;
            if isempty(pos_node)
                return;
            end
            len_pos_node = length(pos_node);
            %----------- 2,����������Ȩ��Delta -----------%
            for node_t = 1:len_pos_node 
                optQuote = pos_node(node_t).quote;
                volume   = pos_node(node_t).volume;
                multiplier    = optQuote.multiplier;
                longShortFlag = pos_node(node_t).longShortFlag;
                total_delta   = total_delta + optQuote.delta * volume * longShortFlag * multiplier;
            end
            fprintf('��ǰStraddle�ܲ�λDelta %.4f\r\n', total_delta)
        end
        % 2,���㵱ǰbookS�ڱ���ʲ���Delta:�������,biaodi_delta�ȱ���ʲ���Delta
        function biaodi_delta = calc_biaodi_delta(obj)
            biaodi_position = obj.bookS.positions;
            biaodi_node     = biaodi_position.node;
            biaodi_delta    = 0;
            for node_t = 1:length(biaodi_node)
                volume = biaodi_node(node_t).volume;
                longShortFlag = biaodi_node(node_t).longShortFlag;
                biaodi_delta  = biaodi_delta + volume * longShortFlag;
            end
        end
        % 3,���ڵ�ǰ�ֲֵ�Delta����Delta�Գ�
        % һ���԰��ն��ּ۽��в����µ�,ֱ���ɽ�Ϊֹ
        % �������:opt_delta��Ȩ�ֲֵ�Delta, biaodi_delta����ʲ���Delta, pct�ǲ�λ�ֲ�delta�İٷֱ�
        success = doonce_delta_hedge(obj, opt_delta, biaodi_delta, pct, competitor_rank);
        
        %% �Գ庯��
        % ����:����һ��ִ�м�ѡ����ֵ,ѡ��Call����Put��Լ���жԳ�
        doonce_delta_hedge_ByOpt(self, monthsel, one_amount, call_putflag, threshold, opposite);
        
        %% ����Break Even Point����
        [left_, right_] = calc_payoffBEP(self);
        [left_, right_] = calc_dynamicBEP(self, tau_);
        [hFig, txt] = plot_dynamicBEP(self);
    end
    
    
    %% Static
    methods(Static = true)
        % ί������ֺ���:����27-> 10 10 7
        function this_trading_entrust = split_amount(entrust_amount)
            % ���룺��Ҫί�е��µ����� entrust_amount
            % ���������ί�е��µ����� this_trading_entrust
            entrust_10s  = floor(entrust_amount/10);
            entrust_last = mod(entrust_amount, 10);
            if entrust_10s
                if entrust_last
                    this_trading_entrust = [ones(1, entrust_10s)*10, entrust_last];
                else
                    this_trading_entrust = ones(1, entrust_10s)*10;
                end
            else
                this_trading_entrust = entrust_last;
            end
        end
        
        % ���ڶ�counter ��Book�Ŀ����µ�openfire����
        openfire_tmp(ctrs, books, call, put, volume, direc, offset, rangbu, proportion);
        % ������StraddleTrading����ĥƽһ����ί�к���
        bridge_gap_entrust(std_stra, com_stra, prct, rate, opposite); 
        
        % Straddle����Break Even Point�ĺ���
        result_ = break_event_point_fcn(s, tau, callQuote_, putQuote_, cost);
    end
   
    
    
    
    
end