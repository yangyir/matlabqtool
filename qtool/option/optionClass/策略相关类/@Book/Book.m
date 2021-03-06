classdef Book < handle
    %BOOK 是一个虚拟的交易单元，类似于子账户的概念
    % ----------------------------------------------
    % 程刚，20160210，基本完成
    % 程刚，20160216，改善了toExcel和loadExcel方法，加入bookinfo页
    % 程刚，20160318，处理pendingEntrusts
    % 程刚，20160327，改了函数名，pendingEntrust，finishedEntrusts等合成一个词，不带下划线
    % cg, 20160329, 加入xlsfn，相应修改toExcel(), fromExcel()
    % 朱江, 20160427, 加入virtual_settlement
    % cg, 161020, 修改 readExcel_HSO32_outfile(obj, filename)
    % 朱江，161108， 修改，将ems中依赖恒生柜台的函数改为通用函数 
    % cg, 161109, 加入readcsv_Huidian_outfile(obj, filename)
    % 吴云峰 20161115, [单个期权资产清仓:目前只适合期权]entrust_succ = clear_opt_entrust_once(obj, stockCode, aim_Remain_Q, counter, competitor_rank)
    % 朱江 20161215, 增加init_book_from_counter方法，用柜台数据初始化Book.
    % 朱江 20161220, 添加一个Structure,辅助监视Book.
    % 程刚 20170109，添加域：name
    % 吴云峰 20170115 添加计算两本Book之差 [ diffBook, print_str ] = calc_diff_of_books(book_standard, book_compare, rate, printstyle);
    % 朱江 20170119 增加恒生柜台的载入Book支持。
    % 吴云峰 20170406 增加计算两本Book之间的最大值和最小值 [minBook, maxBook] = calc_minmax_book(bookleft, bookright, ratioleft, ratioright)
    % 程刚，201705，增加函数print_margin(bk)，输出风险度
    % 朱江，20170718，增加函数load_entrusts_from_counter(counter),载入委托队列功能,暂时只支持CTP
    % cg，20171107，增加域numGreeks; valueGreeks; 
    %           增加函数[]=calc_book_numGreeks(obj), []=calc_book_valueGreeks(obj, S), [] = update_each_position_quote_greeks(obj
    % 
                
 
    
    properties(SetAccess = 'public', Hidden = false , GetAccess = 'public')
        % 基本信息
        name = '未名'        % book名
        trader = '无名';     % 所有人
        strategy = '未知';   % 策略名
  
        % 记录信息        
        finishedEntrusts@EntrustArray = EntrustArray;  % 已了解的下单记录
        pendingEntrusts@EntrustArray = EntrustArray; % 下了，但还没了结的单
        
        % 仓位信息
        positions@PositionArray = PositionArray;  
        
        % Strucure辅助定价
        struct@Structure;
        
        % excel文件名
        xlsfn@char;
        
        % nav等时间序列信息
        % 截面信息
%         holdingCode;% 持仓代码
%         holdingQ;   % 持仓 
%         holdingV;   % 持仓市值   
%         callCode@M2TK= M2TK;     % call行情指针
%         callQ@M2TK   = M2TK;     % call持仓
%         putCode@M2TK = M2TK;     % put行情指针
%         putQ@M2TK    = M2TK;     % put持仓
        
        % 资金管理 -- 所有平仓后，都变成资金
        cash@double;            % 实际资金（共享），实际验资要用这个，直接查
        cashVirtual@double = 0; % 虚拟资金，用于算市值和pnl，虚拟资金可以为负，自己记清楚
        cashPending@double = 0; % 下单后，资金冻结
        cashFace = 0;           % 全部按面值(交易价格）算的资金，可以为负，不考虑保证金
        cashMargin = 0;         % 保证金占用
%         cashOwed@double;   % 欠款，适用于保证金交易，面值=付款（保证金）+欠款
%         cashOut@double;    % 出金
%         cashIn@double;     % 入金
        % 未平仓位
        costFace;   % 仓位的面值成本
        m2mFace;    % 总面值（交易价格）算
        m2mPNL;
        
        % 合计
        m2m;        % mark-to-market, 市值
        pnl;        % profit-and-loss, 盈亏

        % 已平仓位
        realizedPNL;
        historicRealizedPNL;
        fee;
        slippage;   
        % ts信息
        % 分析信息
        
        % book date
        date_ = today; %时间信息 
        
        % temp, 程刚
        numGreeks;  % 按数量的greeks，原始定义的
        valueGreeks;  % 按金额的greeks, 即 1%Delta, 1%Gamma, 1%vega, dtheta, bpRho
    end
    
    %% temp, cg， 成功后移入正式
    methods
        function [] = calc_book_numGreeks(obj)
            
            g = Greeks;
            L = length( obj.positions.node);
            for i = 1:L
                try
                    pos = obj.positions.node(i);
                    quote = pos.quote;
                    
                    q = quote.multiplier * pos.volume * pos.longShortFlag;
                    
                    posDelta = quote.delta * q;
                    posGamma = quote.gamma * q;
                    posVega  = quote.vega * q;
                    posTheta = quote.theta * q;
                    posRho   = quote.rho * q;
                    
                    g.delta = g.delta + posDelta;
                    g.gamma = g.gamma + posGamma;
                    g.vega  = g.vega + posVega;
                    g.theta = g.theta + posTheta;
                    g.rho   = g.rho + posRho;        
                catch
                    warning(' 【取pos——greeks失败】');
                end
            
            
            end
            obj.numGreeks = g;
            
        end
        
        function [] = calc_book_valueGreeks(obj, S )
            
            if ~exist('S', 'var')
                warning('NO input S, use default value 1');
                S = 1;                
            end
            
            
            obj.calc_book_numGreeks();
            
            obj.valueGreeks.delta   = obj.numGreeks.delta * S*0.01;
            obj.valueGreeks.gamma   = obj.numGreeks.gamma * S*S*0.0001;
            obj.valueGreeks.vega    = obj.numGreeks.vega * 0.01;
            obj.valueGreeks.theta   = obj.numGreeks.theta / 365;
            obj.valueGreeks.rho     = obj.numGreeks.rho * 0.0001;
                        
        end
        
        % 把每一position.quote的greeks都重算一遍
        function [] = update_each_position_quote_greeks(obj,S, rfr)
            
            
            L = length( obj.positions.node);
            
            for i = 1:L
                try
                    quote = obj.positions.node(i).quote;
                    if exist('S', 'var'), quote.S = S;  end
                    if exist('rfr', 'var'), quote.r = rfr;  end
                    
                    quote.calc_last_all_greeks();
                    
                catch
                    warning(' 【取pos——greeks失败】');
                end
            end
        end
        
        function [f] = foo(obj)
            
        end
        
        
        
    end
    
    
    
    %%
    methods
        
        % 初始化方法
        function obj = Book()
            obj.finishedEntrusts = EntrustArray;
            obj.pendingEntrusts = EntrustArray;
            obj.positions = PositionArray;
            obj.struct = Structure;
        end                
        
        function [book_date] = date(obj)
            book_date = obj.date_;
        end
        
        function [obj] = merge_book_position(obj, new_book)
            new_pa = new_book.positions;
            new_L  = new_pa.latest;
            
            pa = obj.positions;
            for index = 1:new_L
                p = new_book.positions.node(index).getCopy;
                pa.try_merge_ifnot_push(p);
            end
            
            obj.update_position_structure;
        end
        
        function [obj] = update_position_structure(obj)            
            tmp_s = Structure;            
            pa = obj.positions;
            L = length( pa.node );
            j = 0;
            for i = 1:L
                pos = pa.node(i);
                try
                    if (isnan(pos.quote))
                        continue;
                    end
                catch e
                end
                quote = pos.quote;
                j = j + 1;
                try
                    pricer = quote.QuoteOpt_2_OptPricer('last');
                catch e
                    pricer = OptPricer;
                end
                num = pos.volume * pos.longShortFlag;
                tmp_s.optPricers(j) = pricer;
                tmp_s.num(j)    = num;
            end
                        
            obj.struct.optPricers = tmp_s.optPricers;
            obj.struct.num = tmp_s.num;
        end
        
        function [obj] = update_struct_env(obj, S, vs, r)
            obj.struct.S = S;
            if ~exist('vs', 'var')
                vs = obj.struct.volsurf; 
            end
            if ~exist('r', 'var')
                r = obj.struct.r; 
            end                
            obj.struct.volsurf = vs;            
            obj.struct.r = r;
            obj.struct.inject_environment_params;
        end               
        
        function [] = calc_risks(obj)
            obj.struct.calcAll;
        end
        
        function [delta1] = get_book_delta1(obj)
            delta1 = obj.struct.calcDelta1;
        end
        
        function [gamma1] = get_book_gamma1(obj)
            gamma1 = obj.struct.calcGamma1;
        end
        
        function [theta1] = get_book_theta1(obj)
            theta1 = obj.struct.calcTheta1;
        end
        
        function [vega1] = get_book_vega1(obj)
            vega1 = obj.struct.calcVega1;
        end
        
        function virtual_settlement(book, ST, T)
           % function virtual_settlement(ST, T)
           % 用于处理到期的虚值期权。
           % 该函数有待进一步完善，对于实值期权的处理，以及当Vol为负值时的处理
           % 虚拟交割，把到期仓位全部平掉，换成realizedPNL
           if ~exist('T','var')
               T     = today;
           end
%            bk = obj.book;
           
           % 把相关仓位取出来， 算到期pnl，算虚拟平仓价格
           pa = book.positions;
%            QMS.set_quoteopt_ptr_in_position_array(pa, qms_.optquotes_);
           L = pa.latest;
           % 用settle_pos_idx 记录结算过的pos，之后要从PositionArray中清理掉。
           settle_pos_idx = 0;
           j = 0;
           for i = 1:L
               pos = book.positions.node(i);
               quote = pos.quote;
               try
                   if(isnan(quote))
                       % 当过期的品种没有行情时。构建一个行情对象。
                       quote = QuoteOpt;
                       quote.code = pos.instrumentCode;
                       quote.optName = pos.instrumentName;
                       quoteK = pos.parseKFromName();
                       quote.K = quoteK;
                       quoteT = pos.parseTFromName();
                       quote.T = quoteT;
                       [iscall, isput] = pos.paserOptionTypeFromName();
                       if(iscall)
                           quote.CP = 'call';
                       elseif(isput)
                           quote.CP = 'put';
                       end
                       
                   end
               catch
               end
               % 判断T
               if quote.T > T
                   continue;
               end
               
               quote.S = ST;
               quote.calcIntrinsicValue;
               % 判断虚值
               if (quote.intrinsicValue == 0 || pos.volume == 0)
                   
                   % 输出一次pos
                   pos.println;
                   
                   % 进行一次虚拟交易，价格0，费用0
                   e = Entrust;
                   
                   % 1, 下单信息
                   % 一般地，volume为正，有问题时，可能为负
                   if(pos.volume < 0)
                       continue;
                   else
                       di = - pos.longShortFlag * sign(pos.volume);
                   end
                   
                   vo = abs( pos.volume );
                   % 一定是平仓'2'
                   e.fillEntrust('1', quote.code,  di, 0, vo, '2', quote.optName);
                   
                   % 2, 虚拟下单成功
                   e.entrustNo = 0;
                   book.push_pendingEntrust(e);
                   
                   % 3，虚拟成交信息
                   e.dealAmount = 0;
                   e.dealNum   =  1;
                   e.dealPrice = 0;
                   e.dealVolume = vo;
                   e.fee       = 0;
                   
                   % 4，虚拟成交, 改变position
                   book.sweep_pendingEntrusts
                   % 将PNL记录为历史PNL
                   pa.merge_historic_pnl(pos);
                   
                   j = j + 1;
                   settle_pos_idx(j) = i;

                   continue;
               end
               
               % 如果是实值，在这里处理
               if(quote.intrinsicValue > 0 )
                   % 对于call 权利方：准备K现金行权，获得S-K收益。义务方：准备标的物，以标的价,准备S现金，亏损。
                   switch quote.CP
                       case 'call'
                           settle_pnl = pos.longShortFlag * pos.volume * quote.intrinsicValue;
                           pos.realizedPNL = pos.realizedPNL + settle_pnl;
                           
                       case 'put'
                           % 对于put 权利方：准备标的物。 义务方：准备现金。
                           settle_pnl = pos.longShortFlag * pos.volume * quote.intrinsicValue;
                           pos.realizedPNL = pos.realizedPNL + settle_pnl;                           
                   end
                   
                   % 输出一次pos
                   pos.println;
                   
                   % 进行一次虚拟交易，价格0，费用0
                   e = Entrust;
                   
                   % 1, 下单信息
                   % 一般地，volume为正，有问题时，可能为负
                   if(pos.volume < 0)
                       continue;
                   else
                       di = - pos.longShortFlag * sign(pos.volume);
                   end
                   
                   vo = abs( pos.volume );
                   % 一定是平仓'2'
                   e.fillEntrust('1', quote.code,  di, 0, vo, '2', quote.optName);
                   
                   % 2, 虚拟下单成功
                   e.entrustNo = 0;
                   book.push_pendingEntrust(e);
                   
                   % 3，虚拟成交信息
                   e.dealAmount = 0;
                   e.dealNum   =  1;
                   e.dealPrice = 0;
                   e.dealVolume = vo;
                   e.fee       = 0;
                   
                   % 4，虚拟成交, 改变position
                   book.sweep_pendingEntrusts
                   % 将PNL记录为历史PNL
                   pa.merge_historic_pnl(pos);                   
                   j = j + 1;
                   settle_pos_idx(j) = i;
                   continue;
               end
               
           end
           
           % 清理结算的持仓。
           % 清理时注意需要逆序，以免index失效。
           clean_L = length(settle_pos_idx);
           for i = clean_L : -1 : 1
               rm_pos_idx = settle_pos_idx(i);
               pa.removeByIndex(rm_pos_idx);
           end
           
           book.calc_m2m_pnl_etc;
           book.positions;   
        end
        
        function [book] = eod_netof_positions(book)
            % 日末整理净持仓
            tm = now - floor(now);
            if (tm>=9.5/24  && tm<=15/24)
                fprintf('交易时间，不能进行合并净持仓！');
                return;
            end
            
            while(1)
                pa = book.positions;
                L = length(pa.node);
                % 笨办法，冒泡来比较
                
                for i = 1 : L-1
                    probe = pa.node(i);
                    pair = zeros(1,L);
                    for j = i+1 : L
                        next_p = pa.node(j);
                        if probe.is_same_code(next_p)
                            pair(j - i) = j;
                        end
                    end
                    
                    if 0 == max(pair)
                        merged = false;
                        continue;
                    else
                        merged = true;
                        % merge same asset position
                        len = length(pair);
                        for idx = len : -1 : 1
                            merge_pos_id = pair(idx);
                            if merge_pos_id == 0
                                continue;
                            else
                                % 合并净持仓，并删除末尾元素。从尾部删除不会影响前方迭代器。
                                merge_pos = pa.node(merge_pos_id);
                                probe.merge_position_netoff(merge_pos);
                                pa.removeByIndex(merge_pos_id);
                            end
                        end
                        % 此处跳出probe 的循环，重新整理Positions后再次计算合并
                        break;
                    end
                end
                
                if ~merged
                    % 没有可以继续合并的，结束循环
                    break;
                else
                    continue;
                end
            end
        end
        
        function eod_virtual_cancel_all_pendingEntrusts(book, ctr)
            % 用于日末清理部成单（此时已无法下达cancel指令）
            
            % 检验是否eod，避免搞错
            tm = now - floor(now);
            if (tm>=9.5/24  && tm<=15/24)
                fprintf('交易时间，不能进行虚拟撤单！');
                return;
            end
            
            % 注：应该先查询一遍所有的pendingEntrusts            
            if exist('ctr', 'var')
                book.query_pendingEntrusts(ctr);                
            end
            
            % 日末时，清理未撤销的委托单，部分成交或者是未成交。
            book.sweep_pendingEntrusts;
            
            % 再：改变Entrust的状态码为已处理
            ea = book.pendingEntrusts;
            L  = ea.latest;
            
            for i = 1:L
                e = ea.node(i);
                e.clearEntrust();
            end
            
            % 最后：再打扫一遍pendingEntrusts
            book.sweep_pendingEntrusts;
        end
        
        % 加入一条pendingEntrust， 每次下单后都要加
        function push_pendingEntrust(bk, e)
            eNo = e.entrustNo;
            if isempty(eNo)
                return;
            end
            if isnan(eNo)
                return;
            end
            
            ea = bk.pendingEntrusts;
            ea.push(e);
        end
        
        function query_pendingEntrusts(book, counter)
             % 逐一查询一遍pendingEntrusts
             
             if ~exist( 'counter', 'var')
                 warning('错误：无法查询，必须提供柜台counter！');
                 return;
%                  counter = obj.counter;
             end
            
            % 先：打扫一遍pendingEntrusts
            book.sweep_pendingEntrusts;
            
            % 再：从ctr查询剩下的pending
            ea = book.pendingEntrusts;
            L  = ea.latest;
            
            for i = 1:L
                e = ea.node(i);
                % TODO：应该判断e的标的类型（股票、期权、期货）
                ems.query_optEntrust_once_and_fill_dealInfo(e, counter);
            end
            
            % 最后：再打扫一遍pendingEntrusts
            book.sweep_pendingEntrusts;            
        end
        
        function cancel_pendingOptEntrusts(book, counter)
             if ~exist( 'counter', 'var')
                 warning('错误：无法查询，必须提供柜台counter！');
                 return;
             end       
             
            % 尽力撤，结束后再清理
            ea = book.pendingEntrusts;
            L  = ea.latest;
            
            for i = 1:L
                e = ea.node(i);
                % TODO：应该判断e的标的类型（股票、期权、期货）
                ems.cancel_optEntrust_and_fill_cancelNo(e, counter);
            end
            
            % 查询状态
            book.query_pendingEntrusts(counter);
            
            % 清理
            book.sweep_pendingEntrusts;
        end
        
        
        % 检查pending是否已完成，如已完成，处理
        function sweep_pendingEntrusts(bk)
            % 清扫pendingEntrusts：
            % 1，如果已完成，remove， 同时移入finishedEntrusts, 更新positions
            % 2，如果数量为0， remove
 
            ea1 = bk.pendingEntrusts;
            ea2 = bk.finishedEntrusts;

            L = ea1.latest;
            for i = L:-1:1
                e = ea1.node(i);
                
                % 不在这个函数里做查询
                
                if e.is_entrust_closed
                    % 加入finished中， 并更新position
                    if e.volume > 0
                        bk.update_finishedEntrust( e);
                    end
                    % 从pending中去掉
                    ea1.removeByIndex(i);
                    
                    disp('挂单结束');
                    e.println;
                    continue;
                end
                
                if e.volume <= 0 
                    disp('wrong entrust');
                    ea1.removeByIndex(i);
                    continue;
                end
            end   
        end
        

        function update_finishedEntrust(bk,e)
            % 一个entrust结束了，就在book里处理它
            %  （不在此函数里） 1，从pendingEntrust中撤除
            %   2，加入finishedEntrusts
            %   3，改变positions
            %   4，改变cash，fee，slippage等
            
            ea = bk.finishedEntrusts;            
            pa = bk.positions;
            
%             if e.entrustStatus <= 0  % 已了结
            if e.is_entrust_closed
                % 把pendingEntrust中对应的都拉出来，放进finishedEntrust
                ea.push(e);
                
                % 要把仓位算对了（只在了结的时候算？还是在中间过程算？）
                % 把Entrust转成Position， 再merge
                newp = e.deal_to_position;
                % 如果已有position，合并，否则，新加
                pa.try_merge_ifnot_push(newp);
                
                % 进行买卖后，要更新现金变化
                % 面额算的（虚拟）资金
                bk.cashFace = bk.cashFace - newp.faceCost;
                
                % TODO: cashPending要还给cashVirtual
                % TODO：cashVirtual要减去保证金额
            end
        end
        
        % 计算pnl
        function calc_m2m_pnl_etc(bk)
            % 计算book净值相关的量
            %   1，取持仓资产的价格 ( 放入Position里了，不再在此重复）
            %   2，算positions的m2m, pnl
            %   3，把positions的赋给book
            %   4，取真实cash，由于是共享，没意义了
            %   5，（如可）算资产的保证金，即可变现价值，真个positions的
            
            pa = bk.positions;
            
            %   1,取持仓资产的交易价格
            %  因为position自带quote指针，所以直接取价格就行
            
            %   2，算positions的m2m, pnl
            pa.calc_faceCost;   % 不变量，不涉及行情
            pa.calc_cashOccupied;  % 
            pa.calc_m2mFace_m2mPNL;
            pa.calc_realizedPNL;            
            
            %   3，把position的cost，m2m, pnl 赋给book
            bk.costFace     = pa.faceCost;
            bk.m2mFace      = pa.m2mFace;
            bk.m2mPNL       = pa.m2mPNL ;           
            bk.realizedPNL  = pa.realizedPNL;
            
            %   
            bk.pnl  = bk.realizedPNL + bk.m2mPNL;
        end
        
        % 输出保证金占比
        function print_margin(bk)
            ttlAsset = bk.cash + bk.cashMargin;
            risk = bk.cashMargin/(bk.cash + bk.cashMargin);
            fprintf('[risk] %0.2f%%  =  %0.0f/%0.0f\n' , risk*100, bk.cashMargin, ttlAsset);
        end
        
        function [] = clearExcel(obj, filename)
            [~, sheetNames] = xlsfinfo(filename);
            % Open Excel as a COM Automation server
            Excel = actxserver('Excel.Application');
            % Open Excel workbook
            Workbook = Excel.Workbooks.Open(filename);
            % Clear the content of the sheets (from the second onwards)
            cellfun(@(x) Excel.ActiveWorkBook.Sheets.Item(x).Cells.Clear, sheetNames(:));
            % Now save/close/quit/delete
            Workbook.Save;
            Excel.Workbook.Close;
            invoke(Excel, 'Quit');
            delete(Excel)
        end
        
        % 输入输出历史信息的方法
        function [filename] = toExcel(obj, filename)

            
            %% 默认xlsx类型
            className = class(obj);
            if ~exist('filename', 'var')
                filename = obj.xlsfn;
            end

            if isnan(filename)
                filename = [ 'my_' className '.xlsx'];
            elseif isempty(filename)
                filename = [ 'my_' className '.xlsx'];
            else
                po = strfind(filename, '.xls');
                if isempty(po)
                    % 添加扩展名
                    filename = [filename '.xlsx'];
                else
                    po = po(end);
                    ext = filename(po:end);
                    if ~strcmp(ext, '.xls') ||  ~strcmp(ext, '.xlsx') ...
                            || ~strcmp(ext, '.xlsm') || ~strcmp(ext, '.xlsb')
                        % 改变扩展名
                        filename = [filename(1:po-1) '.xlsx'];
                    end
                end
            end
    
            obj.xlsfn = filename;
            
            %% 先清空excel文件
            obj.clearExcel(obj.xlsfn);
            %% 要放入book自己的信息bookinfo
            
            flds    = properties( obj );
            F       = length(flds);
            table   = cell(F, 2);

            % 第1列写标题,  第2列写数据
            for row = 1:F
                f = flds{row};
                table{row, 1} = f;
                table{row, 2} = obj.(f);
            end
            
            xlswrite(filename, table, 'bookinfo');            
            
            %% 核心：放进positions， entrusts
            obj.positions.toExcel(filename);            
            obj.finishedEntrusts.toExcel(filename);

            obj.pendingEntrusts.toExcel(filename, 'pendingEntrust');
            
            fprintf('saved to: %s\n', filename);
        end
        
        
        function fromExcel(obj,filename)
            % 从excel读取（前日储存的）book
            % book.fromExcel(filename)
            % cg, 20160311, 读取前先清空
            
            
            if ~exist('filename', 'var')
                filename = obj.xlsfn;
            end
            
            %% 读book info
            try
                [num, txt, raw] = xlsread(filename, 'bookinfo');
                [L, C] = size(raw);
                for i = 1:L
                    fd = raw{i, 1};
                    v  = raw{i, 2};
                    if isnan(v), continue; end
                    if isempty(v), continue; end
                    obj.(fd) = v;
                end
            catch e
                disp(e);
            end
            
            %% 核心：读positions, entrusts
            obj.positions.loadExcel(filename, 'Position');
            obj.finishedEntrusts.loadExcel(filename, 'Entrust');
            obj.pendingEntrusts.loadExcel(filename, 'pendingEntrust');
            
            
        end
        
                       
        % 读入从恒生O32系统导出的持仓xls
        function readExcel_HSO32_outfile(obj, filename)
             try
                [num, txt, raw] = xlsread(filename, '综合信息查询_组合证券');
                [L, C] = size(raw);
                
                %% 找到各列的列号
                fdnames = raw(1,:);
                
                c_code = find( strcmp( fdnames, '证券代码'));
                c_name = find( strcmp( fdnames, '证券名称'));
                c_volume = find( strcmp( fdnames, '持仓'));
                c_cost = find( strcmp( fdnames, '当前成本'));
                c_longshort = find( strcmp( fdnames, '持仓多空标志'));
                
                
                %% 逐行取持仓数据
                for i = 2:L-1
                    p = Position;
                    p.instrumentCode = raw{i, c_code};  %证券代码

                    p.instrumentName = raw{i, c_name};   %证券名称
                    p.volume = raw{i, c_volume};          %持仓
                    p.faceCost = raw{i, c_cost};   %当前成本
                    p.avgCost  = p.faceCost/p.volume;
                    
                    tmpls = raw{i, c_longshort}; %持仓多空标志
                    if strcmp(tmpls, '空仓')
                        p.longShortFlag = -1;   %持仓多空标志
                    elseif strcmp(tmpls, '多仓')
                        p.longShortFlag = 1;   %持仓多空标志
                    end
                    p.println;
                    
                    obj.positions.push(p);
                end
                
             catch e
             end
             
            
        end
        
        
        % % 从汇点输出CSV文件里读取
        function readcsv_Huidian_outfile(obj, filename)
             try
                [num, txt, raw] = xlsread(filename);
%                  raw = csvread(filename);
                [L, C] = size(raw);
                
                %% 找到各列的列号
                
%   Columns 1 through 8
%     '市场名称'    '代码'    '名称'    '类别'    '买卖'    '备兑属性'    '持仓'    '可用'
%   Columns 9 through 15
%     '开仓均价'    '最新价'    '市值'    '估算浮动盈亏'    '保证金'    '持仓类别'    'Delta'
%   Columns 16 through 19
%     'Gamma'    'Rho'    'Theta'    'Vega'
                fdnames = raw(1,:);
                
                c_code = find( strcmp( fdnames, '代码'));
                c_name = find( strcmp( fdnames, '名称'));
                c_volume = find( strcmp( fdnames, '持仓'));
                c_avg_cost = find( strcmp( fdnames, '开仓均价'));
                c_longshort = find( strcmp( fdnames, '买卖'));
                
                
                %% 逐行取持仓数据
                for i = 2:L
                    p = Position;
                    p.instrumentCode = raw{i, c_code};  %证券代码

                    p.instrumentName = raw{i, c_name};   %证券名称
                    p.volume = raw{i, c_volume};          %持仓
                    p.avgCost = raw{i, c_avg_cost} * 10000;   %当前成本
                    p.faceCost = p.avgCost * p.volume;
                    
                    tmpls = raw{i, c_longshort}; %持仓多空标志
                    if strcmp(tmpls, '卖')
                        p.longShortFlag = -1;   %持仓多空标志
                    elseif strcmp(tmpls, '买')
                        p.longShortFlag = 1;   %持仓多空标志
                    end
                    p.println;
                    
                    obj.positions.push(p);
                end
                
             catch e
             end
            
        end
       
        function [book] = load_book_from_counter(book, counter)
            % function [book] = load_book_from_counter(book, counter)
            % 从柜台中读取持仓信息和资金信息，用其设置book中的相应信息。
            % 默认恒生柜台为期权户。未来若有额外需求，再完善之
            if isa(counter, 'CounterCTP')               
                book.load_entrusts_from_counter(counter);
            end
            book.sync_account_with_counter(counter);                        
            book.sync_positions_with_counter(counter);    
        end
        
        function [] = sync_account_with_counter(book, counter)
            %function [] = sync_account_with_counter(book, counter)
            if isa(counter, 'CounterHSO32')
                cashObj = Cash;
                cashObj.loadOptCash(counter);
                book.cash = cashObj.optAvailableCash;
                book.cashMargin = cashObj.optOccupiedMargin;
            else
                pause(1);
                [account] = book.read_account_from_counter(counter);
                book.cash = account.available_fund;
                book.cashMargin = account.current_margin;
            end
        end
        
        function [] = sync_positions_with_counter(book, counter)
            %function [] = sync_positions_with_counter(counter)
            % 将同步持仓的函数单独拎出来。
            [positionsarray] = book.read_position_from_counter(counter);
            book.positions = positionsarray;
        end
        
        function [] = load_entrusts_from_counter(obj, counter)
            if isa(counter, 'CounterCTP')
                [earray, ret] = counter.loadEntrusts;
                if ret
                    L = length(earray);
                    pEntArray = EntrustArray;
                    fEntArray = EntrustArray;
                    for i = 1:L
                        einfo = earray(i);
                        e = Entrust;
                        e.instrumentCode = einfo.asset_code;
                        e.instrumentName = einfo.asset_name;
                        e.price = einfo.target_price;
                        e.volume = einfo.target_volume;
                        e.direction = einfo.direction;
                        e.offsetFlag = einfo.offset;
                        e.entrustId = einfo.entrust_id;
                        e.entrustNo = einfo.entrust_no;
                        e.dealVolume = einfo.deal_volume;
                        e.cancelVolume = einfo.cancel_volume;
                        
                        if e.is_entrust_closed
                            fEntArray.push(e);
                        else
                            pEntArray.push(e);
                        end
                    end
                    obj.finishedEntrusts = fEntArray;
                    obj.pendingEntrusts = pEntArray;
                end
                
            end
        end
        
        function [positionarray] = read_position_from_counter(obj, counter)
            % read_position_from_counter(obj, counter)
            % 从柜台中读取PositionArray。
            if isa(counter, 'CounterCTP')
                positionarray = obj.read_position_from_ctp_counter(counter);
            elseif isa(counter, 'CounterXSpeed')
                positionarray = obj.read_position_xspeed_counter(counter);
            elseif isa(counter, 'CounterHSO32')
                positionarray = obj.read_position_from_hs_counter(counter);
            elseif isa(counter, 'CounterHTJG')
                positionarray = obj.flyweight_read_position_from_counter(counter);
            else
                disp(' not supported counter type');
            end
        end
        
        
        function [positionarray] = read_position_xspeed_counter(obj, counter)
            if ~isa(counter, 'CounterXSpeed')
                disp(' not XSpeed Counter')
                return;
            end
            
            positionarray = PositionArray;
%             asset_code", "direction", \
%         "total_position", "available_position", "avg_price", \
%         "face_cost", "margin", "total_fee_cost"};

            [optposition_array, ret] = counter.queryPositions;
            if ret
                L = length(optposition_array);
                for i = 1:L
                    position = Position;
                    position.instrumentCode = optposition_array(i).asset_code;
                    position.instrumentName = optposition_array(i).asset_name;                    
                    position.volume         = optposition_array(i).total_position;
                    position.volumeSellable = optposition_array(i).available_position;
                    position.longShortFlag  = optposition_array(i).direction;
                    position.faceCost = optposition_array(i).face_cost;
                    position.avgCost = optposition_array(i).avg_price;
                    position.marginCost = optposition_array(i).margin;
                    position.feeCost = optposition_array(i).total_fee_cost;
                    positionarray.push(position);
                end
            end
            
        end
        
        function [positionarray] = read_position_from_hs_counter(obj, counter)
            [positionarray, ret] = counter.queryOptPositions('');
            if ~ret
                warning('query Positions failed');
            end
        end
        
        function [positionarray] = read_position_from_ctp_counter(obj, counter)
            if ~isa(counter, 'CounterCTP')
                disp(' not CTP Counter')
                return;
            end
            
            positionarray = PositionArray;
%             asset_code", "direction", \
%         "total_position", "available_position", "avg_price", \
%         "face_cost", "margin", "total_fee_cost"};

            [optposition_array, ret] = counter.queryPositions;
            if ret
                L = length(optposition_array);
                for i = 1:L
                    position = Position;
                    position.instrumentCode = optposition_array(i).asset_code;
%                     position.instrumentName = optposition_array(i).asset_name;                    
                    position.volume         = optposition_array(i).total_position;
                    position.volumeSellable = optposition_array(i).available_position;
                    position.longShortFlag  = optposition_array(i).direction;
                    position.faceCost = optposition_array(i).face_cost;
                    position.avgCost = optposition_array(i).avg_price;
                    position.marginCost = optposition_array(i).margin;
                    position.feeCost = optposition_array(i).total_fee_cost;
                    positionarray.push(position);
                end
            end
            
        end

        function [positionarray] = flyweight_read_position_from_counter(obj, counter)
            
            positionarray = PositionArray;
%             asset_code", "direction", \
%         "total_position", "available_position", "avg_price", \
%         "face_cost", "margin", "total_fee_cost"};

            [optposition_array, ret] = counter.queryPositions;
            if ret
                L = length(optposition_array);
                for i = 1:L
                    position = Position;
                    position.instrumentCode = optposition_array(i).asset_code;
                    position.volume         = optposition_array(i).total_position;
                    position.volumeSellable = optposition_array(i).available_position;
                    position.longShortFlag  = optposition_array(i).direction;
                    position.faceCost = optposition_array(i).face_cost;
                    position.avgCost = optposition_array(i).avg_price;
                    position.marginCost = optposition_array(i).margin;
                    position.feeCost = optposition_array(i).total_fee_cost;
                    positionarray.push(position);
                end
            end
            
        end
        
        
        function [account] = read_account_from_counter(obj, counter)
            % function [obj] = read_account_from_counter(obj, counter)
            % 从柜台中读取Account资金数据
            if isa(counter, 'CounterCTP')
                account = obj.read_account_from_ctp_counter(counter);
            elseif isa(counter, 'CounterXSpeed')
                account = obj.read_account_from_xspeed_counter(counter);
            elseif isa(counter, 'CounterHTJG')
                account = obj.flyweight_read_account_from_counter(counter);
            else
                account = [];
                disp('not support counter');
            end
        end
        
        function [account] = flyweight_read_account_from_counter(obj, counter)
            [account, ret] = counter.queryAccount;
            if ~ret
                disp('query account failed');
            end
        end
        
        function [account] = read_account_from_ctp_counter(obj, counter)
            % function [obj] = read_account_from_ctp_counter(obj, counter)
            % 从CTP柜台中读取Account资金数据
            if ~isa(counter, 'CounterCTP')
                account = [];
                disp('not counter CTP');
            end
            
            [account, ret] = counter.queryAccount;
            if ~ret
                disp('query account failed');
            end
        end
        
        function [account] = read_account_from_xspeed_counter(obj, counter)
            % function [account] = read_account_from_xspeed_counter(obj, counter)
            % 从XSpeed柜台中读取Account资金数据
            
            if ~isa(counter, 'CounterXSpeed')
                account = [];
                disp('not counter XSpeed');
            end
            
            [account, ret] = counter.queryAccount;
            if ~ret
                disp('query account failed');
            end
        end
        
        % 做分析的方法
        [] = virtual_scenario_analysis(obj, cur_vs, cur_S, target_S, target_vol, target_tau, detail);
        
        %{
        添加单个期权资产的平仓委托的方法[这里面只是针对期权的资产,如果需要有股票和期货到时候再写]
        输入参数:stockCode资产代码,aim_Remain_Q目标剩余量,counter柜台,competitor_rank对手价格1:5档
        输出参数:entrust_succ委托是否成功
        吴云峰 20161115 VERSION 0
        %}
        function entrust_succ = clear_opt_entrust_once(obj, stockCode, aim_Remain_Q, counter, competitor_rank)
            if ~exist('competitor_rank' , 'var')
                competitor_rank = 1;
            end
            assert(aim_Remain_Q >= 0);
            assert(ismember(competitor_rank , 1:5));
            %------------------- 1,首先查看当前资产的数量 -------------------%
            my_positions = obj.positions;
            pos_node     = my_positions.node;
            if isempty(pos_node)
                return;
            end
            pre_volume    = 0; % 首先查看当前资产的数量
            len_pos_node  = length(pos_node);
            for node_t = 1:len_pos_node
                instrumentCode = pos_node(node_t).instrumentCode;
                if strcmp(stockCode, instrumentCode)
                    pre_volume    = pos_node(node_t).volume;
                    longShortFlag = pos_node(node_t).longShortFlag;
                    opt_quote     = pos_node(node_t).quote;
                    break;
                else
                    continue;
                end
            end
            if pre_volume == 0 % 如果当前资产没有找到
                fprintf('单个资产平仓目标剩余仓位:%s当前资产代码在book内没有寻找到\r\n', stockCode);
                entrust_succ = false;
                return;
            end
            if aim_Remain_Q >= pre_volume % 如果目标仓位
                fprintf('单个资产平仓目标剩余仓位:%s目标剩余仓位必须要小于当前的仓位\r\n', stockCode);
                entrust_succ = true;
                return;
            end
            
            %------------------- 2,资产委托的准备工作 -------------------%
            aim_Entrust_Q = pre_volume - aim_Remain_Q; % 目标的委托数量
            entrust_10s   = floor(aim_Entrust_Q/10);   % 10单的拆分数量
            entrust_res   = mod(aim_Entrust_Q, 10);    % 剩余委托数量
            if entrust_10s % 构建委托数量
                if entrust_res 
                    entrust_amounts = [ones(1, entrust_10s)*10, entrust_res];
                else
                    entrust_amounts = ones(1, entrust_10s)*10;
                end
            else
                entrust_amounts = entrust_res;
            end
            if longShortFlag > 0 % 委托方向
                direc = '2';
            else
                direc = '1';
            end
            offset = '2'; % 开平方向
            opt_quote.fillQuote;
            switch competitor_rank
                case 1
                    if direc == '1'
                        entrust_px = opt_quote.askP1;
                    else
                        entrust_px = opt_quote.bidP1;
                    end
                case 2
                    if direc == '1'
                        entrust_px = opt_quote.askP2;
                    else
                        entrust_px = opt_quote.bidP2;
                    end
                case 3
                    if direc == '1'
                        entrust_px = opt_quote.askP3;
                    else
                        entrust_px = opt_quote.bidP3;
                    end
                case 4
                    if direc == '1'
                        entrust_px = opt_quote.askP4;
                    else
                        entrust_px = opt_quote.bidP4;
                    end
                case 5
                    if direc == '1'
                        entrust_px = opt_quote.askP5;
                    else
                        entrust_px = opt_quote.bidP5;
                    end
            end
            if abs(entrust_px) < 1e-6
                fprintf('%s当前的委托价格为0,无法平仓\r\n', stockCode);
                entrust_succ = false;
                return;
            end
            optName = opt_quote.optName;
            
            %------------------- 3,资产委托的工作 -------------------%
            my_pendingEntrusts = obj.pendingEntrusts;
            entrust_succ       = true;
            for ea = 1:length(entrust_amounts)
                volume = entrust_amounts(ea);
                one_e  = Entrust;
                mktNo  = '1';
                % 委托单填单
                one_e.fillEntrust(mktNo, stockCode, direc, entrust_px, volume, offset, optName);
                succ = ems.place_optEntrust_and_fill_entrustNo(one_e, counter);
                if succ
                    my_pendingEntrusts.push(one_e);
                else
                    fprintf('%s 委托%s 未来%s 委托价格%.4f 委托数量%d,委托失败\r\n', ...
                        stockCode, direc, offset, entrust_px, volume);
                    entrust_succ = false;
                    break;
                end
            end
        end % function clear_pos_entrust_once
    end
    
    %%
    methods(Static = true)
        demo;
        % 计算两本Book之间的差异 standard基准名称 compare对比名称 rate:compare相对于standard比率,输出两本Book之差
        [ diffBook, print_str ] = calc_diff_of_books(book_standard, book_compare, rate, printstyle);
        % 计算两本Book的仓位最大值和最小值
        [minBook, maxBook] = calc_minmax_book(bookleft, bookright, ratioleft, ratioright);
    end
    

    
    
    
end