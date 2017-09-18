classdef OptStraddleTradingFusion  < handle
%OPTSTRADDLETRADING Summary of this class goes here
% -----------------
% cg, 20160320, 加入opt@QuoteOpt, set_opt(), trade_opt(), 用于灵活交易单票
% 吴云峰，20161114，加入一件清仓
% error_entrust_amount = clear_holding( obj, pct, times, competitor_rank,round_interval); [每轮委托使其尽量成交]
% error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank); [依据仓位剩余量方式进行委托平仓]
% cg, 20161114, 修改算S0时给定范围的问题， 在：
% monitor_strangle_delta0_S0(obj)， monitor_book_risk(obj, S_low, S_high); 
% Delta对冲一次性下单:计算期权持仓Delta：total_delta = calc_position_delta(obj);计算标的Delta：biaodi_delta = calc_biaodi_delta(obj)
% 手动delta hedge,基于百分比一次性调整Delta：success = doonce_delta_hedge( obj, opt_delta, biaodi_delta, pct, competitor_rank);
% 吴云峰,20161117, 加入手动delta hedge,基于百分比一次性调整Delta
% 朱江，20161123， 测试通用行情，通用柜台接入。
% 吴云峰 20161222 加入期权对冲函数doonce_delta_hedge_ByOpt(self, monthsel, one_amount, call_putflag, threshold, opposite)
% 吴云峰 20161229 增加拆单功能函数:（最后一个参数可以省略）将 buy_once sell_once trade_once进行拆单处理
% place_entrust_opt_apart(obj, direc, volume, offset, px);  place_entrust_opt进行拆单封装
% trade_opt_apart(obj, direc, volume, offset, px);          trade_opt进行拆单封装
% buy_once/sell_once/trade_once可以拆单下单
% 吴云峰 20170105 增加多book/多Counter straddle/strangle开火下单函数 openfire升级
% 吴云峰 20170115 将两个StraddleTrading策略磨平一次性委托函数 bridge_gap_entrust(std_stra, com_stra, prct, rate, opposite); 
% 吴云峰 20170508 新增Straddle的Break Even Point分析函数:calcStraddleFixedBEP ; calcStraddleDynamicBEP ; plotStraddleDynamicBEP;
        
        
    % 策略必须有的公共量
    % 调试的时候public，为了方便
    properties(SetAccess = 'public', Hidden = false) 
        % 账户信息, 初始化后不再改动
        counter;          % 柜台
        book@Book = Book; % 投资组合信息，只负责记录清楚就行了，原则上不参与策略逻辑          
        
        % 期权行情
        quote;
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
        volsurf; % vol surface[volsurf@VolSurface;]
        
        % OptionOne;
        m2tkCallOne@M2TK;
        m2tkPutOne@M2TK;
        
        % 现货行情, 50ETF
        counterS;
        bookS@Book;
        quoteS@QuoteStock;
        
        % deltaHedge[dher1@Deltahedging;]
        dher2@Deltahedging2;
    end
    
    
    %********************** 策略自身的变量 **********************%
    properties
        % 一些简单记录
        call@QuoteOpt;
        put@QuoteOpt;
        opt@QuoteOpt;
        S;
        % optNear@QuoteOpt; % 跨期策略用
        % optFar@QuoteOpt;
        
        % OptionOne, 测试挂单用
        callOne@OptionOne;
        putOne@OptionOne;
        optOne@OptionOne;
    end

    methods
         
        %% 分析函数 和 查询函数 
        [hfig] = plot_theoritical_analysis(obj, Smin, Smax);
        [] = monitor_iv_vega_theta(obj, px_type);
        [] = monitor_book_risk(obj, S_low, S_high);
        monitor_book_risk_txt( obj, S_low, S_high );            % 将monitor_book_risk进行拆分为txt
        monitor_book_risk_fig( obj, S_low, S_high, h_parent );  % 将monitor_book_risk进行拆分为fig
        monitor_kuaqi(obj)
        [newobj] = getCopy(obj);
        
        %------------- 每隔一段时间显示一下，交易跟踪的信息 -------------%
        function monitor(obj)
            % 取仓位的价格，取当前的仓位，算当前仓位的m2m，按照策略逻辑组合，并显示出来 
            curr_book         = obj.book;
            curr_position     = curr_book.positions;
            finished_entrusts = curr_book.finishedEntrusts;
            
            % 这里负责保证quote的行情畅通即可，不必计算
            for i = 1:length(curr_position.node)
                position_node = curr_position.node(i);
                opt_quote     = position_node.quote;
                
                % 用H5行情更新，需要init时启动H5行情
                % 行情更新不太及时，好久取不到
                while 1
                    opt_quote.fillQuote;
                    if opt_quote.askQ1 > 0
                        break;
                    else
                        disp('期权行情未接到');
                        pause(1);
                    end
                end
            end
            
            curr_book.calc_m2m_pnl_etc();
            curr_position.print;
            finished_entrusts.print;
        end
        
        
        %------------- 获取strangle的delta0和s0情形 -------------%
        function [delta0_S, delta] = monitor_strangle_delta0_S0(obj)
            % 构造straddle structure
            s = Structure;
            s.volsurf = obj.volsurf;
            S     = obj.quoteS.last;
            obj.S = S;
            s.S   = S;
            
            % 从QuoteOpt转成OptPricer，以供后面计算用
            call = obj.call.QuoteOpt_2_OptPricer('bid');
            put  = obj.put.QuoteOpt_2_OptPricer('bid');
            
            s.optPricers(1) = put;
            s.optPricers(2) = call;
            s.num = [1,1];
            s.inject_environment_params;
            
            % 算delta==0 的S点
            [delta0_S, delta] = s.calc_delta0_S0(0.5*S, 1.5*S, 0.001);
            fprintf('S0=%0.3f,  delta0=%0.4f\n', delta0_S, delta);
        end
        
        %------------- 监督当前的仓位 -------------%
        function monitor_positions(obj)
            % 取当前的仓位，算当前仓位的m2m
            % 取仓位的价格
            b    = obj.book;
            pa   = b.positions;
            b.calc_m2m_pnl_etc();
            pa.print;
        end
        
        %------------- 逐一查询一遍pendingEntrusts -------------%
        function query_book_pendingEntrusts( obj )
            % 逐一查询一遍pendingEntrusts
            ctr = obj.counter;
            book = obj.book;
            book.query_pendingEntrusts( ctr );
        end
        
        
        %% 设置函数 和 管理函数
        [c]   = set_call(obj, iT, K_call)
        [p]   = set_put(obj, iT, K_put)
        [opt] = set_opt(obj, iT, K , type);
        
        
        function init_all(stra)
            %% 初始化：给strat挂上counter， book， quote
        end
        
        % 日末，关闭策略
        function end_day(obj)
            % obj.counter.logout;
            obj.book.eod_virtual_cancel_all_pendingEntrusts(obj.counter);
            obj.book.eod_netof_positions
            obj.book.toExcel;
        end
        
        function set_counters(obj)
            % 逐一把m2tkCallOne和m2tkPutOne中设置新的counter
            % 思考：OptionOne是handle子类，这里的修改会给所有人带来影响！！
            % 暂时只用一个counter进行做市交易，没大碍，以后一定要改
            L = length( obj.m2tkCallOne.xProps);
            for iT = 1:4
                for iK = 1:L
                    obj.m2tkCallOne.data(iT, iK).counter = obj.counter;
                    obj.m2tkPutOne.data(iT, iK).counter  = obj.counter;
                end
            end
        end
        
       
        %% 下单函数(新增,拆单操作)
        
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
                error('call或者put合约为空')
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
                error('call或者put合约为空')
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
                error('call或者put合约为空')
            end
            ctr  = obj.counter;
            ctr  = { ctr };
            book = obj.book;
            obj.openfire_tmp(ctr, book, call, put, volume, direc, offset, rangbu, 1);
        end
        
        % 新增拆单函数
        place_entrust_opt_apart(obj, direc, volume, offset, px); % place_entrust_opt进行拆单封装
        trade_opt_apart(obj, direc, volume, offset, px);         % trade_opt进行拆单封装
        
        
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
                % 更新quoteOpt
                % 用H5行情更新，需要init时启动H5行情
                opt.fillQuote;
                
                % 默认取对价
                if strcmp(direc, '1')
                    px = opt.askP1;
                elseif strcmp(direc, '2')
                    px = opt.bidP1;
                end
            end
            
            e.fillEntrust(mktNo, stkCode, direc, px, volume, offset, opt.optName);
        end
        
        function openfire(obj, volume, direc, offset, rangbu )
            % 取当前S
            % 取最近的K1，K2，组合，算gamma
            % 暂时：手动指定一个call， 一个put
            % rangbu：让步幅度，值域【0, 1】, 0就是用最不利，1就是对价（默认），0.5就是中间价
            
            if ~exist('direc', 'var'),    direc = '1';    end
            if ~exist('volume','var'),    volume = 1; end
            if ~exist('offset', 'var'),    offset = '1';    end
            if ~exist('rangbu', 'var'),     rangbu = 0.8;   end
            
            put = obj.put;
            call = obj.call;
            
            % 更新quoteOpt
            % 用H5行情更新，需要init时启动H5行情
            % 行情更新不太及时，好久取不到
            while 1
                call.fillQuote;
                put.fillQuote;
                if call.askQ1>0 && put.askQ1>0
                    break;
                else
                    disp('期权行情未接到');
                    pause(1);
                end
            end
            
            % 下单
            ctr = obj.counter;
            book = obj.book;
            
            aimVolumeCall   = volume;
            aimVolumePut    = volume;
            
            while aimVolumeCall > 0  || aimVolumePut > 0
                
                % 更新quoteOpt
                % 用H5行情更新，需要init时启动H5行情
                call.fillQuote;
                put.fillQuote;
                
                % 填充entrust, 2个
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
                
                % TODO：验资验券
                % 下单
                % 下单后就立即把单子塞进book.pendingEntrusts
                ems.place_optEntrust_and_fill_entrustNo(e1, ctr);
                book.pendingEntrusts.push(e1);
                
                ems.place_optEntrust_and_fill_entrustNo(e2, ctr);
                book.pendingEntrusts.push(e2);

                %%  对于book.pendingEntrusts 逐一查询状态？
                % 只针对这两个查状态，并更新
                
                % 查询3次，否则撤单 ( 两个单的情况复杂太多了）
                iter_wait = 1;
                while ~e1.is_entrust_closed || ~e2.is_entrust_closed
                    if iter_wait > 3
                        if ~e1.is_entrust_closed
                            % 查一下现在的价格，如果没有变化，就不撤单，否则，撤单
                            call.fillQuote;
                            if strcmp(direc, '1')
                                px = call.askP1 * rangbu + call.bidP1 *(1-rangbu);
                            elseif strcmp(direc, '2')
                                px = call.bidP1 * rangbu + call.askP1*(1-rangbu);
                            end
                            
                            if abs(px - e1.price) >=0.00005
                                ems.cancel_optEntrust_and_fill_cancelNo(e1, ctr);
                                disp('e1进行撤单');
                            else
                                disp('e1价格未变，继续挂单');
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
                                disp('e2进行撤单');
                            else
                                disp('e2价格未变，继续挂单');
                            end
                        end
                    end
                    pause(1);
                    ems.query_optEntrust_once_and_fill_dealInfo(e1, ctr);
                    ems.query_optEntrust_once_and_fill_dealInfo(e2, ctr);
                    iter_wait = iter_wait + 1;
                end
                
                % 如果到此，说明该entrust已close，需要记录
                book.sweep_pendingEntrusts;
                
                % 同时，准备下一轮下单
                aimVolumeCall = e1.cancelVolume;
                aimVolumePut  = e2.cancelVolume;
                % aimVolumePut  = 0;
            end
            % 上面的while结束，算是一个order真正完成了，记录
            % 不用再book里记录了，book对每一个entrust都做了记录
            % 主要是要在策略逻辑里记录
            % obj.book.toExcel;
        end
        
        function place_e(obj)
        end
        function guadan(obj)
        end
        
        %{
        1，clear_holding( obj, pct, times, competitor_rank, round_interval);
        一键清仓函数[每轮委托使其尽量成交]
        输入参数:pct百分比[0~100],times平仓的轮流次数,competitor_rank对手价格档数,round_interval每轮交易完的间隔
        输出参数:未能委托成功的数量和代码
        2，error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank);
        一键清仓函数[依据仓位剩余量方式进行委托成交]
        输入参数:pct百分比[0~100],times平仓的轮流次数,competitor_rank对手价格档数
        输出参数:未能委托成功的数量和代码
        吴云峰 20161111 每轮委托使其尽量成交
        吴云峰 20161115 依据仓位剩余量方式进行委托平仓
        %}
        error_entrust_amount = clear_holding(obj, pct, times, competitor_rank, round_interval);
        error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank);
        
        %{ 
        进行一次delta hedge,两部走：
        1,首先一次性计算当前所有期权资产的Delta
        2,再计算bookS里面标的Delta
        3,再依据当前标的持仓Delta进行Delta对冲
        吴云峰 20161116
        %}
        % 1,计算当前所有期权资产的Delta:输出参数,total_delta既整体期权仓位的Delta
        function total_delta = calc_position_delta(obj)
            %----------- 1,初始化信息 -----------%
            my_book      = obj.book;
            my_positions = my_book.positions;
            pos_node     = my_positions.node;
            total_delta  = 0;
            if isempty(pos_node)
                return;
            end
            len_pos_node = length(pos_node);
            %----------- 2,计算所有期权的Delta -----------%
            for node_t = 1:len_pos_node 
                optQuote = pos_node(node_t).quote;
                volume   = pos_node(node_t).volume;
                multiplier    = optQuote.multiplier;
                longShortFlag = pos_node(node_t).longShortFlag;
                total_delta   = total_delta + optQuote.delta * volume * longShortFlag * multiplier;
            end
            fprintf('当前Straddle总仓位Delta %.4f\r\n', total_delta)
        end
        % 2,计算当前bookS内标的资产的Delta:输出参数,biaodi_delta既标的资产的Delta
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
        % 3,基于当前持仓的Delta进行Delta对冲
        % 一次性按照对手价进行操作下单,直到成交为止
        % 输入参数:opt_delta期权持仓的Delta, biaodi_delta标的资产的Delta, pct是仓位弥补delta的百分比
        success = doonce_delta_hedge(obj, opt_delta, biaodi_delta, pct, competitor_rank);
        
        %% 对冲函数
        % 功能:基于一个执行价选择阈值,选择Call或者Put合约进行对冲
        doonce_delta_hedge_ByOpt(self, monthsel, one_amount, call_putflag, threshold, opposite);
        
        %% 新增Break Even Point函数
        [left_, right_] = calc_payoffBEP(self);
        [left_, right_] = calc_dynamicBEP(self, tau_);
        [hFig, txt] = plot_dynamicBEP(self);
    end
    
    
    %% Static
    methods(Static = true)
        % 委托量拆分函数:诸如27-> 10 10 7
        function this_trading_entrust = split_amount(entrust_amount)
            % 输入：需要委托的下单数量 entrust_amount
            % 输出：单笔委托的下单数量 this_trading_entrust
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
        
        % 基于多counter 多Book的开火下单openfire函数
        openfire_tmp(ctrs, books, call, put, volume, direc, offset, rangbu, proportion);
        % 将两个StraddleTrading策略磨平一次性委托函数
        bridge_gap_entrust(std_stra, com_stra, prct, rate, opposite); 
        
        % Straddle计算Break Even Point的函数
        result_ = break_event_point_fcn(s, tau, callQuote_, putQuote_, cost);
    end
   
    
    
    
    
end