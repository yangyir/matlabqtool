classdef BookCTP < handle
    %BOOK 是一个虚拟的交易单元，类似于子账户的概念
    % ----------------------------------------------
    % 程刚，20160210，基本完成
    % 程刚，20160216，改善了toExcel和loadExcel方法，加入bookinfo页
    % 程刚，20160318，处理pendingEntrusts
    % 程刚，20160327，改了函数名，pendingEntrust，finishedEntrusts等合成一个词，不带下划线
    % cg, 20160329, 加入xlsfn，相应修改toExcel(), fromExcel()
    % 朱江, 20160427, 加入virtual_settlement
  
    
    properties(SetAccess = 'public', Hidden = false , GetAccess = 'public')
        % 基本信息
        trader = '无名';     % 所有人
        strategy = '未知';   % 策略名
  
        % 记录信息        
        finishedEntrusts@EntrustArray = EntrustArray;  % 已了解的下单记录
        pendingEntrusts@EntrustArray = EntrustArray; % 下了，但还没了结的单
        
        % 仓位信息
        positions@PositionArray = PositionArray;  
        
        % excel文件名
        xlsfn@char;
        
        % nav等时间序列信息
        
        
        
        % 截面信息
%         holdingCode;% 持仓代码
%         holdingQ;   % 持仓 
%         holdingV;   % 持仓市值
%         
%         callCode@M2TK= M2TK;     % call行情指针
%         callQ@M2TK   = M2TK;     % call持仓
%         putCode@M2TK = M2TK;     % put行情指针
%         putQ@M2TK    = M2TK;     % put持仓
        
        
        % 资金管理 -- 所有平仓后，都变成资金
        cash@double;            % 实际资金（共享），实际验资要用这个，直接查
        cashVirtual@double = 0; % 虚拟资金，用于算市值和pnl，虚拟资金可以为负，自己记清楚
        cashPending@double = 0; % 下单后，资金冻结
        cashFace = 0;           % 全部按面值(交易价格）算的资金，可以为负，不考虑保证金
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
        
        
        
        
        
    end
    
    
    %%
    methods
        
        % 初始化方法
        function obj = Book()
            obj.finishedEntrusts = EntrustArray;
            obj.pendingEntrusts = EntrustArray;
            obj.positions = PositionArray;
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

               end
               
               % 如果是实值，在这里处理
               if(quote.intrinsicValue > 0)
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
                        if probe.is_same_asset(next_p)
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
            
            if ~exist(filename, 'file')
                disp('Book 文件不存在');
                return;
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
        
        
        % 做分析的方法
        
        
    end
    
    
    methods(Static = true)
        
        demo;
        
    end
    
    
end

