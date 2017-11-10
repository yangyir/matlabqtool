classdef Entrust < handle
    %ENTRUST 下单类
    %   此处显示详细说明
    % -----------------------------
    % 程刚，20160216,
    % 程刚，20160217，约定：所有code都是用char，以避免混乱
    % 程刚，20160401，加入instrumentName，为了看着方便，修改println
    % 朱江，20160621，为CTP新增两个域，entrustId 和 assetType
    % 朱江，20161221，为期货合约交易新增multiplier域。
    % 朱江，20170607, 增加下单时间戳，已挂时间戳，成交时间戳
    % 朱江，20170607，增加组合单ID。
    % 朱江，20170608，增加deals域。
    % 程刚，20170708，增加域：rankBE, rankWE 
    % 何康，20170912，修正了deal_to_position中平仓feeCost为负的bug
    % 程刚，20171020，println()加入开平仓信息
    
    properties
        % 核心信息 
        marketNo = '1';             %（@char, setter控制）市场编号，'1'上交所，'2'深交所， 并非必须
        instrumentCode = '000000';  % （@char,setter控制）合约代码,
        instrumentName = '无名';    % 为了方便
        instrumentNo;   % 合约编号
        volume;         % 数量， TODO: 仅为正值？( 这是委托的数量 )
        price;          % 价格
        direction;      % （@double，setter控制）买卖方向，buy = 1; sell = -1;
        offsetFlag = 1; % （@double，setter控制）开平性质, open = 1; close = -1;
        closetodayFlag = 0; %% （@double，setter控制）上期所专用，平今平昨, 平今 = 1; 平昨 = 2，默认不设置为0;
                
        entrustNo;            % 委托编号
        entrustType;          % 委托类型, market, limit, stop, fok etc.
        entrustStatus = 0;    % 委托状态, 0表示新对象
                              % 1表示填好了的新单（TODO：检查有效？）
                              % 2表示已下单（获得entrsutNo）
                              % 3，4，...未了结，每查一次加1
                              % -1表示了结了。
        %为CTP使用新增两个域
        entrustId = 0;        %柜台内部委托编号
        assetType = 'Option'; %标的类型：'ETF'/'Option'/'Future'
        
        %以下
        date@double = today;  % 日期， matlab 格式， 如735773
        date2;                % 日期，double或char？，如'20140623'
        time@double = now;    % 时间，matlab格式，如735773.324
        time2;                % double或char？ 时间 'HHMMSSFFF'
        
        % 成交
        dealVolume@double = 0; % 成交数目
        dealAmount@double = 0; % 成交金额
        dealPrice;             % 成交均价
        dealNum@double = 0;    % 成交笔数


        % 撤单信息
        cancelVolume@double = 0;   % 撤单数量
        cancelTime;                % 撤单时间
        cancelNo;                  % 撤单号
        
        recvTime;   % 后台系统接收时间
        updateTime; % 最后修改时间
        
        
        % 相关信息
        tick;       % 时间对应的tick号
        strategyNo; % 策略编号，整数
        orderRef;   % 订单编号
        combNo;     % 组合编号
        roundNo;    % 回合编号
        
        % 费用信息
        fee@double = 0; % 手续费
        % 保证金
        
        % 合约乘数
        multiplier = 10000;
        
        % 挂单排序（估计值）， 用于高频策略
        rankBE = -1;  % best estimation
        rankWE = -1;  % worst estimation
    end
    
    properties(SetAccess = 'private', Hidden = true)
        isCompleted;
    end
    
    properties
        % 增加委托，挂出，成交时间戳
        issue_time_;
        accept_time_;
        complete_time_;
        
        % 增加组合单ID, 默认简单单此处值为-1;
        combi_no_ = -1;
        
        % 增加trades域，用在分析过程中。
        deals_@DealArray;
    end

    methods
        % 基础方法，constructor， copy constructor， display
        [newobj] = getCopy(obj);
        
        % 强制类型转换：所有code都是char
        function [obj] = set.instrumentCode(obj, vin)
            % 强制类型转换：所有code都是char
            if iscell(vin), vin = vin{1}; end
            cl = class(vin);                        
            switch cl
                case {'double' }
                    disp('强制类型转换：code应为char');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('赋值失败：code应为char');
                    return;
            end
            obj.instrumentCode = vout;
        end
        
        
        function [obj] = set.direction(obj, vin)     
            % direction的处理比较繁琐，不同的地方规矩不同
            % HSO32里，‘1’买， ‘2’卖(买是1卖是-1)
            if isa(vin, 'char')
                switch vin
                    case {'1', 'buy', 'b'}                
                        vout = 1;
                    case {'2', 'sell', 's'}
                        vout = -1;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else  % 不规则输入，如nan
                vout = 0;
            end                
            obj.direction = vout;            
        end
        
        function [obj] = set.entrustNo(obj, vin)
            if isa(vin, 'char')
                obj.entrustNo = str2double(vin);
            elseif isa(vin, 'double')
                obj.entrustNo = vin;
            end
        end
        
        function [obj] = set.offsetFlag(obj, vin)
            % 开平仓的规矩不同，Entrust里取数值 -1， 1
            % HSO32里，开仓'1'， 平仓'2'(1是开仓-1是平仓)
            if isa(vin, 'char')
                switch vin
                    case {'1', 'open', 'o'}  % 开仓
                        vout = 1;
                    case {'2', 'close', 'c'}  % 平仓
                        vout = -1;
                    otherwise
                        vout = 0;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else
                vout = 0;
            end
            obj.offsetFlag = vout;
        end    

        function [obj] = set.closetodayFlag(obj, vin)
            % 平今平昨的规矩不同，Entrust里取数值 平今1， 平昨2
            if isa(vin, 'char')
                switch vin
                    case {'1', 'today', 't'}  % 平今
                        vout = 1;
                    case {'2', 'yesterday', 'y'}  % 平昨
                        vout = 2;
                    otherwise
                        vout = 0;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else
                vout = 0;
            end
            obj.closetodayFlag = vout;
        end
        
        % volume非负(这应该是委托的数量)
        function [obj] = set.volume(obj, value)
            % volume非负
            if isnan(value), value = 0; end
            if isa(value, 'double') && (value>=0)
                obj.volume = value;
            else
                obj.volume = value;
                warning('entrust.volume赋值失败：须为非负数字');
            end
        end
        
        % marketNo是char
        function [obj] = set.marketNo(obj, vin)
            % marketNo是char            
            if isa(vin, 'cell'), vin = vin{1}; end
            cl = class(vin);
            switch cl
                case {'double'}
                     vout = num2str(vin);
                case {'char'}
                    vout = vin;
                otherwise
                    warning('赋值失败：entrust.marketNo需要是char');
                    return
            end
            obj.marketNo = vout;
        end
        
        function [obj] = set.assetType(obj, vin)
            if isa(vin, 'cell'), vin = vin{1}; end
            if isa(vin, 'char')
                obj.assetType = vin;
            else
                warning('赋值失败： entrust.assetType 类型为char：ETF Option Future');
            end
            switch obj.assetType
                case 'ETF'
                    obj.multiplier = 100;
                case 'Option'
                    obj.multiplier = 10000;
            end
        end
        
        function [obj] = set.multiplier(obj, value)
            if isa(value, 'double')
                obj.multiplier = value;
            else
                warning('赋值失败，entrust.multiplier 类型为double');
            end
        end
        
        % 委托单的打印(我需要自己制作一个打印的情形)
        function [txt] = println(obj)
            txt = sprintf('[%d:%s,%s,%d,%d] v=%d=%d+%d, px=(%0.4f, %0.4f, %d)\n', ...
                obj.entrustNo, obj.instrumentName, obj.instrumentCode, obj.direction, obj.offsetFlag, ...
                obj.volume, obj.dealVolume, obj.cancelVolume, ...
                obj.price, obj.dealPrice, obj.dealAmount);
            if nargout == 0 
                disp(txt);
            end
        end 
        
        function [deal_summary_struct] = deal_summary(obj)
            % function [evaluate_struct] = evaluate(obj)
            % 委托相关的评价，滑点滑时
            % TODO: evaluate Entrust implementation.
            if obj.deals_.isempty
                deal_summary_struct = [];
                % 滑点：在无成交记录的情况下：成交均价 - 委托价
                % 滑时：成交时间 - 成交
            else
                L = obj.deals_.count;
                % 滑点: 成交均价 - 最优成交价
                
                % 滑时：
            end
        end
        
        function [valid] = is_valid(obj)
            valid = true;
            if strcmp(obj.instrumentCode, '000000')
                valid = false;
            end
        end
        
        function [iscombi] = is_combi(obj)
            iscombi = (obj.combi_no_ ~= -1);
        end
        
        function [entrust_time] = entrustTime(obj)
            entrust_time = obj.issue_time_;
        end
        
        % 这里面目前只有期权的Fee,目前还没有涉及到期货的计算情况(这个需要进行区分)
        function [fee] = calcFee(obj, volume)
            if ~exist('volume', 'var')
                volume = obj.volume;
            end
            fee = 0;
            % 期权手续费分为两部分： 经手费 + 佣金
            % 佣金为每张期权0.3 元
            % 经手费为每张期权2元，卖开 不收经手费
            % 一张期权为10000股。       
            % （@double，setter控制）买卖方向，buy = 1; sell = -1;
            % （@double，setter控制）开平性质, open = 1; close = -1;
            if(obj.direction == -1 && obj.offsetFlag == 1)
                brokerage = 0;%经手费
            else
                brokerage = 2;
            end
            commission = 0.3; %佣金
            fee = (brokerage + commission) * volume; % 交易费用      
            obj.fee = fee;
        end
        
        % 填一个单，准备下的单
        function fillEntrust(obj, marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount, offsetFlag, instrumentName)
            % 填一个单，准备下的单            
            % fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount, offsetFlag, instrumentName)
            if ~exist('offsetFlag', 'var'), offsetFlag = 1; end
            if ~exist('instrumentName', 'var'), instrumentName = '无名'; end
            obj.marketNo        = marketNo;         % 市场
            obj.instrumentCode  = stockCode;        % 代码
            obj.volume          = entrustAmount;    % 委托数量
            obj.price           = entrustPrice;     % 委托价格
            obj.direction       = entrustDirection; % 委托方向(买卖)
            obj.offsetFlag      = offsetFlag;       % 开平方向
            obj.instrumentName  = instrumentName;
            obj.calcFee();
        end
        
        function clearEntrust(e)
            e.updateTime = now;
            e.cancelVolume = e.volume - e.dealVolume;
            e.entrustStatus = -1;
        end
            
        % 读入一个O32的packet, queryEntrust的packet
        function fill_entrust_query_packet_HSO32(e, packet)
            e.updateTime    = now;
            e.dealVolume    = packet.getInt('deal_amount');      % 成交数目
            e.dealAmount    = packet.getDouble('deal_balance');     % 成交金额
            e.dealPrice     = packet.getDouble('deal_price');      % 成交均价
            e.dealNum       = packet.getInt('deal_times');        % 成交笔数
            e.cancelVolume  = packet.getInt('withdraw_amount');     % 撤单笔数
            e.calcFee(e.dealVolume);
            %                     e.cancelTime = now;          
        end
        
        function [position] = deal_to_position(e)
            % 一个结束的下单会对position产生何种影响？
            % 
%             if e.entrustStatus>=0
            if ~e.is_entrust_closed
                warning('失败：entrustStatus = 未完成，不应转成position');
                return;
            end
            
            % 把已经结束的entrust的deal信息转成一个Position
            position = Position;
            position.instrumentCode = e.instrumentCode;
            position.instrumentName = e.instrumentName;
            position.instrumentNo   = e.instrumentNo;
            position.volume         = e.dealVolume * e.offsetFlag; % 如果是平仓，则volume为负
            position.longShortFlag  = e.offsetFlag * e.direction; % 开，则direction同longshort，关仓，则direction与longshort相反
            position.faceCost       = e.dealAmount * e.direction; % 这里算的是成本，如果卖，则是负成本
            position.avgCost        = position.faceCost / position.volume; % 平均成本   
            position.feeCost        = e.calcFee(abs(position.volume));
        end
            
        function [position] = entrust_to_position(obj)
            % 将某个Entrust快照转为Position结构
            position = Position;
            position.instrumentCode = obj.instrumentCode;
            position.instrumentName = obj.instrumentName;
            position.instrumentNo   = obj.instrumentNo;
            position.volume         = obj.volume * obj.offsetFlag; % 如果是平仓，则volume为负
            position.longShortFlag  = obj.offsetFlag * obj.direction; % 开，则direction同longshort，关仓，则direction与longshort相反
            position.feeCost        = obj.calcFee();
        end
        
        % 小函数，负责转换 -1， 1  -->  '2', '1'
        function [entrustDirection] = get_CounterHSO32_direction( e )
            % 如果柜台是CounterHSO32，下单的direction要用 '1', '2'，这个小函数负责计算
            
            d = e.direction ;
            v = e.volume; % 这个值应该恒为正？
            
            if d*v > 0
                entrustDirection = '1';
            elseif d*v < 0
                entrustDirection = '2';
            else
                entrustDirection = '0';
            end
        end
        
        
        % 小函数，负责转换 -1， 1  -->  '2', '1'
        function [kaiping] = get_CounterHSO32_offset( e )
            % 如果柜台是CounterHSO32，下单的开平（futureDirection或offsetFlag）要用 '1', '2'
            
            kp = e.offsetFlag;
            v = e.volume; % 这个值应该恒为正？
            
            if kp*v > 0
                kaiping = '1';
            elseif kp*v < 0
                kaiping = '2';
            else
                kaiping = '0';
            end
        end
        
        function [flag] = is_entrust_filled(e)
            flag = (e.volume > 0) && (e.volume == e.dealVolume);
        end
        
        function [flag] = is_entrust_canceled(e)
            flag = (e.cancelVolume > 0);
        end
        
        % 小函数，判断本entrust是否结束，并status = -1
        function [ flag ] = is_entrust_closed(e)
            % 判断本entrust是否结束
            % 如果是个有效单，并且已经完全结束（已成+已撤 == 欲下），则置status=-1
            % 委托量为0， 就是废单，就算生命结束了
            if e.volume == 0 
                flag = 1;
                e.entrustStatus = -1;
                return;
            end
            f1 = e.volume > 0; % 此单有效
            f2 = e.volume == e.dealVolume + e.cancelVolume; % 此单结束
            flag = f1&f2;
            if isempty(flag), flag = 0; end
            if flag 
                e.entrustStatus = -1; % 已终止
            end
        end
            
    
    end
    
    %% 合并方法
    methods
        function [obj] = merge_position(obj, other)
            % 将同品种同方向委托的仓位合并
            % 该方法是作为验算的中间步骤，由于会更改对象属性，只应该作用于验算时的拷贝对象。
            % 不应该直接对原始委托做此操作
            if( obj.offsetFlag == other.offsetFlag)                
                obj.volume = obj.volume + other.volume;                
            else
                vol = obj.volume - other.volume;
                if(vol < 0)
                    obj.offsetFlag = other.offsetFlag;
                end
                obj.volume = abs(vol);                 
            end
            obj.fee = obj.fee + other.fee;
            str = sprintf('entrust vol: %d, offset: %d \n', obj.volume, obj.offsetFlag);
            disp(str);            
        end
        
    end
    
    %%
    methods(Static = true)
        demo
        
        function [logical_ret] = is_same_asset(entrust_a, entrust_b)
           logical_ret = (strcmp(entrust_a.instrumentCode, entrust_b.instrumentCode) ...
                          && (entrust_a.direction == entrust_b.direction) ...
                          && strcmp(entrust_a.marketNo ,entrust_b.marketNo));
        end
    end
end

