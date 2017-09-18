classdef Position < handle
    %POSITION ��¼һ����λ��Ϣ
    %  --------------------------------
    % �̸գ�20160205
    % �̸գ�20160217��Լ��������code������char���Ա������
    % �̸գ�20160223������quote��ָ�������ָ��
    % �̸գ�20160318������cashOccupied �� calc_cashOccupied(pos)
    % �̸գ�20161027������volumeSellable��������������ʱû���κ��߼��չ���
   
    properties
        instrumentCode = '000000';     % (@char,setter����)��Լ����
        instrumentName@char = '����'      % ��Լ����
        instrumentNo@double = -1;      % ��Լ���
        longShortFlag@double = 1;      % ��ֻ��ǿղ֣� 1�� -1
        volume@double = 0;             % ������ֻҪ�ǳֲ֣�volume������ֵ
        volumeSellable@double = 0;     % ��ƽ�֣������������� <= volume
        % ��¼��
        faceCost = 0;   % ��ǮΪ��
        avgCost = 0;   
        feeCost = 0;
        marginCost = 0;
        
        % ������-����
        quote;      % ָ�������ָ�룬��qms��ȡ������
        bidpx  = [];
        askpx  = [];
        lastpx = 0;
        
        % ������
        m2mFace@double = 0;
        m2mPNL@double  = 0;
        m2mOpenPNL@double     = 0;
        m2mPreClosePNL@double = 0;
        realizedPNL@double    = 0;
        cashOccupied@double   = 0;   % �ʽ�ռ�ã����㣬��׼ȷ��
    end
    
    methods
        
        % ǿ������ת��������code����char
        function [obj] = set.instrumentCode(obj, vin)
            % ǿ������ת��������code����char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);                        
            switch cl
                case {'double' }
                    disp('ǿ������ת����codeӦΪchar');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('��ֵʧ�ܣ�codeӦΪchar');
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
            % ��ĳЩ�ֲ���Ȩ���ڽ���󣬾�û�и�Ʒ�����顣��������ʱ��Ҫ��Ʒ��
            % ������ȡ��Kֵ�����ڼ��㽻��payoff�ʹ�������߼���
            % ��Ȩ���ƾ�����50ETF��5��2250
            % ��ETF�ֺ�ʱ��Kֵ�������������������ĸ��
            L = length(obj.instrumentName);
            name = obj.instrumentName;
            if L > 4
                pos = strfind(name, '��');
                K_str = obj.instrumentName(pos : end);
                is_letters = isletter(K_str);
                if max(is_letters) > 0
                    % �����˵��β�˺�����ĸ��
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
                % �����˵����������Ч��
                K = NaN;
                return;
            end
        end
        
        function [T] = parseTFromName(obj)
            %function [T] = parseTFromName()
            % ��ĳЩ�ֲ���Ȩ���ڽ���󣬾�û�и�Ʒ�����顣��������ʱ��Ҫ��Ʒ��
            % ������ȡ���·ݣ����㵽���գ����ڼ��㽻��payoff�ʹ�������߼���
            % ��Ȩ���ƾ�����50ETF��5��2250
            name = obj.instrumentName;
            pos = strfind(name, '��');
            if isempty(pos)
                T = 0;
                return;
            else
               pos_c = strfind(name, '��');
               pos_p = strfind(name, '��');
               if ~isempty(pos_c)
                   pos_s = pos_c;
               elseif ~isempty(pos_p)
                   pos_s = pos_p;
               else
                   T = 0;
                   return;
               end
               m_str = name(pos_s + 1 : pos - 1);
               % ��Ȩ�������Ǻ�Լ�·ݵĵ��ĸ�����
               mm = str2num(m_str);
               calendar = Calendar_Test.GetInstance;
               [T, ~] = calendar.nth_week_date(4, 4, mm);
            end
        end
        
        function [iscall, isput] = paserOptionTypeFromName(obj)
            % [iscall, isput] = paserOptionTypeFromName()
            % ��ĳЩ�ֲ���Ȩ���ڽ���󣬾�û�и�Ʒ�����顣��������ʱ��Ҫ��Ʒ��
            % ������ȡ��call/put ���ͣ����ڼ��㽻��payoff�ʹ�������߼���
            name = obj.instrumentName;
            pos = strfind(name, '��');
            if isempty(pos)
                iscall = true;
                isput = false;
            else
                iscall = false;
                isput = true;
            end
        end

        
        % ������
        function [ v, pl, openPl, preClosePl ] = calc_m2mFace_m2mPNL(obj, quoteOpt)
            % ��������һ����ȽϺ��ʣ��������������
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
                if strcmp(obj.instrumentCode, quoteOpt.code)  % ��ͬһ������
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
            
            
            % Ҫ�뵽��bidpx��askpxδ����
            if obj.longShortFlag == 1  % �ֶ�֣�Ҫ��������ۣ��õͼ�
                px = obj.bidpx;
            elseif obj.longShortFlag == -1 % �ֿղ֣�Ҫ�������ۣ����߼�
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
            % ���Ƕ�֣�ռ���ʽ����cost
            % ���ǿղ֣�ռ���ʽ��Ǳ�֤��
            try
                if isnan(pos.quote)
                    co = 0;
                    pos.cashOccupied = co;
                    return;
                end
            catch 
            end
            
            switch pos.longShortFlag
                case 1  % ���
                    co = pos.faceCost;
                case -1   % �ղ�
                    q  = pos.quote;
                    co = q.margin * q.multiplier * pos.volume;
            end            
            pos.cashOccupied = co;            
        end
        
        
        % һ��newdeal�����ˣ�Ҫ����Ӧ�ĸı�
        function update_newdeal(obj)
            % ͬ�����deal
            
            
            
            % �������deal
            
            
        end
        
        % ��һ������position��ϲ���newPosition
        function [success] = mergePosition(obj, newPosition)
            success = -1;
            c1 = class(obj);
            c2 = class(newPosition);
            if ~strcmp(c1,c2)
                warning('��ͬ���ͣ��ϲ�ʧ��');
                return;
            end
            
            % ���objΪ�գ� ֱ�Ӱ�newPosition��obj��
            if isempty( obj )
                obj = newPosition.getCopy();
                return;
            end
            
            
            % ��Լ����Ҫ��ͬ�����Ҫ��ͬ
            if ~strcmp(obj.instrumentCode, newPosition.instrumentCode)
                warning('��ͬ��Լ���ϲ�ʧ��');
                return;
            end
            
            if obj.longShortFlag ~= newPosition.longShortFlag
                warning('��ͬ��գ��ϲ�ʧ��');
                return;
            end
            
            %% ƽ��
            % �����ֲ�volume������ֵ������أ����½���ת�ɳֲ����ϲ�ʱ�������Ǹ�ֵ��������
            % ����½��׵�������Ϊ����˵����ƽ�֣���Ҫ����realizedPNL
            if newPosition.volume < 0
                cashIn = - newPosition.faceCost;
                cost   = obj.avgCost * abs( newPosition.volume );
                obj.realizedPNL = obj.realizedPNL + ( cashIn - cost );
                
                % ƽ��ʱ���������realizedPNL���Ͳ�Ӧ��ƽ���ֲֳɱ���ɱ仯
                obj.volume   = obj.volume + newPosition.volume;
                obj.faceCost = obj.avgCost * obj.volume;
                
                success = 1;

           %% ����
            elseif newPosition.volume >= 0
                
                % �ϲ�����������ӣ�cost��ӣ�avgCost����
                obj.volume  = obj.volume + newPosition.volume;
                obj.faceCost = obj.faceCost + newPosition.faceCost;
                % ȡ�صĳɽ��۸��������д�
                obj.avgCost = obj.faceCost / obj.volume;
                
                success = 1;
                
            end
            % ���ۿ�ƽ�֣�������ʼ�մ���
            obj.feeCost = obj.feeCost + newPosition.feeCost;
        end
        
        function [success] = merge_position_netoff(obj, newPosition)
            % ����ϲ���ͬ��Լposition����ղ�����ϲ�
            % ����һ������ĺϲ���ֻ��������㣬����ʹ�ã�
            % ������Ȩ��λ������ĺϲ�����Ϊ���������̺���Զ�����
            success = -1;
            c1 = class(obj);
            c2 = class(newPosition);
            if ~strcmp(c1,c2)
                warning('��ͬ���ͣ�����ϲ�ʧ��');
                return;
            end
            
            % ��Լ����Ҫ��ͬ����ղ�������ͬ
            if ~strcmp(obj.instrumentCode, newPosition.instrumentCode)
                warning('��ͬ��Լ������ϲ�ʧ��');
                return;
            end
            
            %% main            
            oldV = obj.longShortFlag * obj.volume;
            newV = newPosition.longShortFlag * newPosition.volume;
            netV = oldV + newV;
            
            % ��netV��������������д
            obj.longShortFlag  = sign(netV);
            obj.volume         = abs(netV);
            obj.faceCost       = obj.faceCost + newPosition.faceCost;
            obj.realizedPNL    = obj.realizedPNL + newPosition.realizedPNL;
            % ����ϲ����������ͬ�ɽ�����ֵ�ı仯Ҫ����ʵ������
            % realizedpnl += delta(facecost��
            % delta(facecost) = newPosition.faceCost;
            obj.realizedPNL    = obj.realizedPNL + newPosition.faceCost;
            obj.avgCost        = obj.faceCost / obj.volume;
            obj.calc_m2mFace_m2mPNL;
            obj.calc_cashOccupied;

            % ���ۿ�ƽ�֣�������ʼ�մ���
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
            %GETCOPY handle����ͨ�õ�copy constructor����Ϊhandle��ָ���࣬������Ҫ
            
            eval( ['newobj = ', class(obj), ';']  );
            flds    = fields( obj );
            
            for i = 1:length(flds)
                fd          = flds{i};
                newobj.(fd) = obj.(fd);
            end                        
        end
        
        function [txt] = print(obj)
            txt = '';
            txt = sprintf('--��λ��Ϣ��%s',obj.instrumentCode);
            
            if obj.longShortFlag == 1 
                txt = sprintf('%s����------\n',txt);
            elseif obj.longShortFlag == -1
                txt = sprintf('%s����------\n', txt);
            end
            
            txt = sprintf('%s�ֲ�:%d\n', txt, obj.volume);
            txt = sprintf('%s��ֵ�ɱ���%0.2f( ����%0.2f)\n' , txt, obj.faceCost, obj.avgCost);
            txt = sprintf('%s��ֵ��ֵ��%0.2f���ۣ�%0.2f)\n', txt, obj.m2mFace, obj.lastpx);
            txt = sprintf('%s��ֵPNL: %0.2f(realized��%0.2f��\n', txt, obj.m2mPNL, obj.realizedPNL);
                     
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
    
    %% �����������
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