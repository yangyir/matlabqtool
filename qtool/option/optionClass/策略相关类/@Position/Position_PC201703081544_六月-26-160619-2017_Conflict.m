classdef Position < handle
    %POSITION 记录一条仓位信息
    %  --------------------------------
    % 程刚，20160205
    % 程刚，20160217，约定：所有code都是用char，以避免混乱
    % 程刚，20160223，加入quote，指向行情的指针
    % 程刚，20160318，加入cashOccupied 及 calc_cashOccupied(pos)
    % 程刚，20161027，加入volumeSellable，可用数量，暂时没有任何逻辑照顾它
   
    properties
        instrumentCode = '000000';     % (@char,setter控制)合约代码
        instrumentName@char = '无名'      % 合约名称
        instrumentNo@double = -1;      % 合约编号
        longShortFlag@double = 1;      % 多仓还是空仓， 1， -1
        volume@double = 0;             % 数量，只要是持仓，volume总是正值
        volumeSellable@double = 0;     % 可平仓（可卖）数量， <= volume
        % 记录量
        faceCost = 0;   % 花钱为正
        avgCost = 0;   
        feeCost = 0;
        marginCost = 0;
        
        % 更新量-行情
        quote;      % 指向行情的指针，从qms里取，挂入
        bidpx  = [];
        askpx  = [];
        lastpx = 0;
        
        % 计算量
        m2mFace@double = 0;
        m2mPNL@double  = 0;
        m2mOpenPNL@double     = 0;
        m2mPreClosePNL@double = 0;
        realizedPNL@double    = 0;
        cashOccupied@double   = 0;   % 资金占用（估算，不准确）
    end
    
    methods
        
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
        
        function [obj] = constructQuoteobj(obj)
            %function [obj] = constructQuoteobj(obj)
            if isnan(obj.quote)
               % check quote type
               if strcmp(obj.instrumentCode , '000000')
                   warning('invalid position!');
                   return;
               end
               
               code_num = str2num(obj.instrumentCode);
               if isempty(code_num)
                   quote_obj = QuoteFuture;
                   % todo : replay today by real T;
                   quote_obj.fillFutureInfo(obj.instrumentCode, obj.instrumentName, today);
               elseif code_num > 1000000
                   quote_obj = QuoteOpt;
                   K = obj.parseKFromName;
                   T = obj.parseTFromName;
                   [call, put] = obj.paserOptionTypeFromName;
                   CP = 'call';
                   if ~call
                       CP = 'put';
                   end
                   quote_obj.fillOptInfo(obj.instrumentCode, obj.instrumentName, '510050', T, K, CP);
               else
                   quote_obj = QuoteStock;
                   mrkt = 'sh';                   
                   if code_num < 600000
                       mrkt = 'sz';
                   end
                   quote_obj.fillStockInfo(obj.instrumentCode, obj.instrumentName, mrkt);
               end
               
               obj.quote = quote_obj;              
            end
        end
        
        function [K] = parseKFromName(obj)
            % function [K] = parseKFromName()
            % 当某些持仓期权到期交割后，就没有该品种行情。在做处理时，要从品种
            % 名称中取得K值，用于计算交割payoff和处理相关逻辑。
            % 期权名称举例：50ETF购5月2250
            % 在ETF分红时，K值会调整，名称最后会有字母。
            L = length(obj.instrumentName);
            name = obj.instrumentName;
            if L > 4
                pos = strfind(name, '月');
                K_str = obj.instrumentName(pos : end);
                is_letters = isletter(K_str);
                if max(is_letters) > 0
                    % 该情况说明尾端含有字母。
                    L = length(is_letters);
                    pos_end = 0;
                    for i = 1:L
                        if(is_letters(i) > 0)
                            break;
                        end
                        pos_end = i;
                    end
                    
                    PureKstr = K_str(1:pos_end);
                    K = str2num(PureKstr);
                    K = K/1000;
                    return;
                else
                    K = str2num(K_str);
                    K = K / 1000;
                    return;
                end
            else
                % 该情况说明此名称无效。
                K = NaN;
                return;
            end
        end
        
        function [T] = parseTFromName(obj)
            %function [T] = parseTFromName()
            % 当某些持仓期权到期交割后，就没有该品种行情。在做处理时，要从品种
            % 名称中取得月份，计算到期日，用于计算交割payoff和处理相关逻辑。
            % 期权名称举例：50ETF购5月2250
            name = obj.instrumentName;
            pos = strfind(name, '月');
            if isempty(pos)
                T = 0;
                return;
            else
               pos_c = strfind(name, '购');
               pos_p = strfind(name, '沽');
               if ~isempty(pos_c)
                   pos_s = pos_c;
               elseif ~isempty(pos_p)
                   pos_s = pos_p;
               else
                   T = 0;
                   return;
               end
               m_str = name(pos_s + 1 : pos - 1);
               % 期权到期日是合约月份的第四个周三
               mm = str2num(m_str);
               calendar = Calendar_Test.GetInstance;
               [T, ~] = calendar.nth_week_date(4, 4, mm);
            end
        end
        
        function [iscall, isput] = paserOptionTypeFromName(obj)
            % [iscall, isput] = paserOptionTypeFromName()
            % 当某些持仓期权到期交割后，就没有该品种行情。在做处理时，要从品种
            % 名称中取得call/put 类型，用于计算交割payoff和处理相关逻辑。
            name = obj.instrumentName;
            pos = strfind(name, '沽');
            if isempty(pos)
                iscall = true;
                isput = false;
            else
                iscall = false;
                isput = true;
            end
        end

        
        % 计算量
        function [ v, pl, openPl, preClosePl ] = calc_m2mFace_m2mPNL(obj, quoteOpt)
            % 两个合在一起算比较合适，反正计算量差不多
            if ~exist('quoteOpt', 'var')
                q = obj.quote;
                try
                    if(isnan(q))
                        v  = 0;
                        pl = 0;
                        openPl = 0;
                        preClosePl = 0;
                        obj.m2mFace = v;
                        obj.m2mPNL  = pl;
                        obj.m2mOpenPNL     = openPl;
                        obj.m2mPreClosePNL = preClosePl;
                        return;
                    end
                catch
                end
%                 isa(q, 'QuoteOpt')
                if strcmp(q.code , obj.instrumentCode)
                    quoteOpt = q;
                end
            end
            
            if exist('quoteOpt', 'var')
                if strcmp(obj.instrumentCode, quoteOpt.code)  % 是同一个东西
                    obj.bidpx = quoteOpt.bidP1;
                    obj.askpx = quoteOpt.askP1;
                    obj.lastpx= quoteOpt.last;
                    openPx    = quoteOpt.open;
                    preClosePx= quoteOpt.preClose;
                    mul = quoteOpt.multiplier;
                end
            else
                openPx     = q.open;
                preClosePx = q.preClose;
                mul = 10000;
            end
            
            
            % 要想到，bidpx和askpx未必有
            if obj.longShortFlag == 1  % 持多仓，要卖，用买价，用低价
                px = obj.bidpx;
            elseif obj.longShortFlag == -1 % 持空仓，要买，用卖价，即高价
                px = obj.askpx;
            end
            
            if px==0
                try
                px = obj.last;
                catch e
                    disp(obj);
                    px = 0;
                end
            end
            
            v = obj.volume * px * obj.longShortFlag * mul; 
            vOpen     = obj.volume * openPx * obj.longShortFlag * mul; 
            vPreClose = obj.volume * preClosePx * obj.longShortFlag * mul; 
            obj.m2mFace = v;
            
            pl = v - obj.faceCost;
            openPl = vOpen - obj.faceCost;
            preClosePl = vPreClose - obj.faceCost;
            obj.m2mPNL = pl;
            obj.m2mOpenPNL     = openPl;
            obj.m2mPreClosePNL = preClosePl;
        end
        
        
        function [co ] = calc_cashOccupied(pos)
            % 如是多仓，占用资金就是cost
            % 如是空仓，占用资金是保证金
            try
                if isnan(pos.quote)
                    co = 0;
                    pos.cashOccupied = co;
                    return;
                end
            catch 
            end
            
            switch pos.longShortFlag
                case 1  % 多仓
                    co = pos.faceCost;
                case -1   % 空仓
                    q  = pos.quote;
                    co = q.margin * q.multiplier * pos.volume;
            end            
            pos.cashOccupied = co;            
        end
        
        
        % 一个newdeal进来了，要做相应的改变
        function update_newdeal(obj)
            % 同方向的deal
            
            
            
            % 反方向的deal
            
            
        end
        
        % 在一个现有position里合并进newPosition
        function [success] = mergePosition(obj, newPosition)
            success = -1;
            c1 = class(obj);
            c2 = class(newPosition);
            if ~strcmp(c1,c2)
                warning('不同类型，合并失败');
                return;
            end
            
            % 如果obj为空？ 直接把newPosition给obj？
            if isempty( obj )
                obj = newPosition.getCopy();
                return;
            end
            
            
            % 合约代码要相同，多空要相同
            if ~strcmp(obj.instrumentCode, newPosition.instrumentCode)
                warning('不同合约，合并失败');
                return;
            end
            
            if obj.longShortFlag ~= newPosition.longShortFlag
                warning('不同多空，合并失败');
                return;
            end
            
            %% 平仓
            % 正常持仓volume总是正值，特殊地，把新交易转成持仓来合并时，可能是负值（卖出）
            % 如果新交易的数量的为负，说明是平仓，则要计入realizedPNL
            if newPosition.volume < 0
                cashIn = - newPosition.faceCost;
                cost   = obj.avgCost * abs( newPosition.volume );
                obj.realizedPNL = obj.realizedPNL + ( cashIn - cost );
                
                % 平仓时，如果记入realizedPNL，就不应对平均持仓成本造成变化
                obj.volume   = obj.volume + newPosition.volume;
                obj.faceCost = obj.avgCost * obj.volume;
                
                success = 1;

           %% 开仓
            elseif newPosition.volume >= 0
                
                % 合并：把数量相加，cost相加，avgCost重算
                obj.volume  = obj.volume + newPosition.volume;
                obj.faceCost = obj.faceCost + newPosition.faceCost;
                % 取回的成交价格因舍入有错
                obj.avgCost = obj.faceCost / obj.volume;
                
                success = 1;
                
            end
            % 不论开平仓，手续费始终存在
            obj.feeCost = obj.feeCost + newPosition.feeCost;
        end
        
        function [success] = merge_position_netoff(obj, newPosition)
            % 轧差合并：同合约position，多空仓轧差合并
            % 并不一定是真的合并，只是轧差计算，慎重使用！
            % 对于期权仓位，是真的合并，因为交易所收盘后会自动轧差
            success = -1;
            c1 = class(obj);
            c2 = class(newPosition);
            if ~strcmp(c1,c2)
                warning('不同类型，轧差合并失败');
                return;
            end
            
            % 合约代码要相同，多空不必须相同
            if ~strcmp(obj.instrumentCode, newPosition.instrumentCode)
                warning('不同合约，轧差合并失败');
                return;
            end
            
            %% main            
            oldV = obj.longShortFlag * obj.volume;
            newV = newPosition.longShortFlag * newPosition.volume;
            netV = oldV + newV;
            
            % 用netV的数量，重新填写
            obj.longShortFlag  = sign(netV);
            obj.volume         = abs(netV);
            obj.faceCost       = obj.faceCost + newPosition.faceCost;
            obj.realizedPNL    = obj.realizedPNL + newPosition.realizedPNL;
            % 轧差合并的情况，视同成交，面值的变化要计入实现收益
            % realizedpnl += delta(facecost）
            % delta(facecost) = newPosition.faceCost;
            obj.realizedPNL    = obj.realizedPNL + newPosition.faceCost;
            obj.avgCost        = obj.faceCost / obj.volume;
            obj.calc_m2mFace_m2mPNL;
            obj.calc_cashOccupied;

            % 不论开平仓，手续费始终存在
            obj.feeCost = obj.feeCost + newPosition.feeCost;
            
            success = 1;
            
        end
        
        function [is_same] = is_same_asset(obj, position)
            is_same = ((strcmp(obj.instrumentCode, position.instrumentCode)) ...
                && (obj.longShortFlag == position.longShortFlag));            
        end

        function [is_same] = is_same_code(obj, position)
            is_same = (strcmp(obj.instrumentCode, position.instrumentCode));            
        end        
        
        function [is_equal] = is_equal_position(obj, position)
            is_equal = ((obj.volume ) == (position.volume));
        end        
    end
    
    %% constructor, copy constructor, display
    methods
        
        
        function [ newobj ] = getCopy( obj )
            %GETCOPY handle子类通用的copy constructor。因为handle是指针类，所以需要
            
            eval( ['newobj = ', class(obj), ';']  );
            flds    = fields( obj );
            
            for i = 1:length(flds)
                fd          = flds{i};
                newobj.(fd) = obj.(fd);
            end                        
        end
        
        function [txt] = print(obj)
            txt = '';
            txt = sprintf('--仓位信息：%s',obj.instrumentCode);
            
            if obj.longShortFlag == 1 
                txt = sprintf('%s：多------\n',txt);
            elseif obj.longShortFlag == -1
                txt = sprintf('%s：空------\n', txt);
            end
            
            txt = sprintf('%s持仓:%d\n', txt, obj.volume);
            txt = sprintf('%s面值成本：%0.2f( 均：%0.2f)\n' , txt, obj.faceCost, obj.avgCost);
            txt = sprintf('%s面值市值：%0.2f（价：%0.2f)\n', txt, obj.m2mFace, obj.lastpx);
            txt = sprintf('%s面值PNL: %0.2f(realized：%0.2f）\n', txt, obj.m2mPNL, obj.realizedPNL);
                     
            if nargout == 0 
                disp(txt);
            end
        end
        
        
        function [txt] = println(obj)
            txt = sprintf('%s %s\t%d\t%d\t%0.0f\t%0.0f\n', ...
                obj.instrumentCode, obj.instrumentName, obj.longShortFlag, ...
                obj.volume, obj.faceCost, obj.m2mFace);
            
            if nargout == 0 
                disp(txt);
            end
        end
    end
    
    %% 输入输出函数
    methods 
        function [title] = to_excel_title(obj)
            flds = properties(obj);
            L = length(flds);
            for i = 1:L
                f = flds{i};
                title{i} = f;
            end
            
        end
        
        function [value_row] = to_excel_value(obj)
            flds = properties(obj);
            L = length(flds);
            for i = 1:L
                f = flds{i};
                value_row{i} = obj.(f);
            end
        end
    end
     
    methods(Static = true )
        demo;
    end
            
        
        
    
   

end