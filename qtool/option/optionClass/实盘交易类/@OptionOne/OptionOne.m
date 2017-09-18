classdef OptionOne < AssetOne
    %%
    % -----------------------------
    % cg, 161017���޸���set.quote�� set.optinfo�� ����orderbook���
    
    
    properties
        optinfo@OptInfo;
        pricer@OptPricer;
        quote@QuoteOpt;
        
      

    end
    
    

    %% setters & getters
    methods
        function set.quote( obj, q )
            % disp('����quote, ͬʱ����positionLong��positionShort');
            L = length(obj.positions.node);
            pos = obj.positions.node(1);
            if( L == 1 && strcmp(pos.instrumentCode, '00000000'))
                pos.instrumentCode = q.code;
                pos.instrumentName = q.optName;
            end
            
            pos = obj.positionLong;
            pos.instrumentCode = q.code;
            pos.instrumentName = q.optName;
            
            pos = obj.positionShort;
            pos.instrumentCode = q.code;
            pos.instrumentName = q.optName;
            obj.quote = q;
            
            
            % ����orderbook�ĸ���
            obj.askOrderBook.code = q.code;
            obj.bidOrderBook.code = q.code;
            obj.askOrderBook.name = q.optName;
            obj.bidOrderBook.name = q.optName;
        end
            
        function set.optinfo(obj, opt)
            % disp('����optionf�� ͬʱ����positionLong, positionShort');
            L = length(obj.positions.node);
            pos = obj.positions.node(1);
            if( L == 1 && strcmp(pos.instrumentCode, '00000000'))
                pos.instrumentCode = opt.code;
                pos.instrumentName = opt.optName;
            end
            
            obj.positionLong.instrumentCode = opt.code;
            obj.positionLong.instrumentName = opt.optName;
            
            obj.positionShort.instrumentCode = opt.code;
            obj.positionShort.instrumentName = opt.optName;
            
            obj.optinfo = opt;
            
            % ����orderbook�ĸ���
            obj.askOrderBook.code = opt.code;
            obj.bidOrderBook.code = opt.code;
            
            obj.askOrderBook.name = opt.optName;
            obj.bidOrderBook.name = opt.optName;
            
            obj.askOrderBook.iT = opt.iT;
            obj.bidOrderBook.iT = opt.iT;            
            
            obj.askOrderBook.iK = opt.iK;
            obj.bidOrderBook.iK = opt.iK;
        end

    end

    %% �����µ�����
    methods
       
        % �µ���������µ�
        [e] = place_entrust_opt(obj, direc, volume, offset, px )
            
            
        % �µ�������һЩ���µ���ʽ
        
        % �����Զ��жϿ�ƽ�֣��ȿ���λ��
        [e] = place_entrust_autoOffset(obj, direc, volume, px);

        
        % ���Ե��ڼ۸�ʽ�����Լ�oppo���޼۳�ƽatpar��last�ۣ�mid��
        [e] = place_entrust_autoPx( obj, direc, volume, offset, pxType);   
        [e] = place_entrust_autoOffset_autoPx( obj, direc, volume, pxType);
        
        
        % ���̿�n��
        [e] = place_entrust_better_nTicks(obj, direc, volume, nTick, offset);
        
        
        % �µ��������ü۸��ò��İٷֱ�
        % [e] = place_entrust_better_nPct(obj, direc, volume, offset, nPct)
        % nPct ��ȡ��0,100%������
        % ask �� bid ��Ϊ100%�� ��
        %����: bid 0%, ...,  ask 100%, ...
        %  ����ask 0%, ...,  bid 100%, ...
        [e] = place_entrust_better_nPct(obj, direc, volume,  nPct, offset)
    
        
    end
    
    
    %% ���ֳ�������
    methods
        % �����������ض���e
        function [] = cancel_entrust_opt(obj, e)
            ctr = obj.counter;
            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
            fprintf('��������');
            e.println;
        end
        
        % ����ȫ���ĵ�, ���������
        function [] = cancel_entrust_all(obj)
            % ����ȫ���ĵ�, ���������

             ctr = obj.counter;
             ea  = obj.pendingEntrusts;
             for i = 1:ea.latest
                 e = ea.node(i);
                 ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
             end
        end
        
        
        % ����ĳ����λ�����еĵ��� buysellFlag = 'buy'. 'sell' �� 'both'
        function [] = cancel_entrusts_atPx( obj, px, buysellFlag )
            
            if ~exist('buysellFlag', 'var') 
                buysellFlag = 'both';
            end

            ctr = obj.counter;
            ea  = obj.pendingEntrusts;
            
            % ��switch�������棬ִ�п�
            switch buysellFlag
                case { 'both' }                    
                    for i = 1:ea.latest
                        e = ea.node(i);
                        if abs( e.price - px ) < 1e-12
                            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
                        end
                    end
                    
                case { 'buy'}
                    for i = 1:ea.latest
                        e = ea.node(i);
                        if abs( e.price - px ) < 1e-12 && e.direction == 1
                            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
                        end
                    end
                    
                case {'sell'}
                    for i = 1:ea.latest
                        e = ea.node(i);
                        if abs( e.price - px ) < 1e-12 && e.direction == -1
                            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
                        end
                    end
            end
            
        end
        
        % ����5������Ĺҵ�
        function [] = cancel_entrusts_outof_nLevel( obj, nLevel )
            if ~exist('nLevel', 'var')
                nLevel = 5;
            end
            
            ctr = obj.counter;
            ea  = obj.pendingEntrusts;
            quote = obj.quote;
            quote.fillQuote;
            
            % ������ɵ���������
            if nLevel == 1
                ask_bound = quote.askP1;
                bid_bound = quote.bidP1;
            elseif nLevel == 2
                ask_bound = quote.askP2;
                bid_bound = quote.bidP2;
            elseif nLevel == 3
                ask_bound = quote.askP3;
                bid_bound = quote.bidP3;
            elseif nLevel == 4
                ask_bound = quote.askP4;
                bid_bound = quote.bidP4;
            else
                ask_bound = quote.askP5;
                bid_bound = quote.bidP5;
            end
            
            % ����ÿ��������������ݴ�����
%             fld_a = [ 'askP' num2str(nLevel) ];
%             fld_b = [ 'bidP' num2str(nLevel) ];
%             ask_bound = quote.(fld_a);
%             bid_bound = quote.(fld_b);
            
            % ��һ���飬���������ͳ���
            for i = 1:ea.latest
                e = ea.node(i);
                if e.price < bid_bound || e.price > ask_bound
                    ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
                end
            end
             
        end
        
        
        function cancel_
            
        end
    end
    
    %% ��Ч���ж�
    methods
        function [valid] = is_optone_valid(obj)
            valid = obj.optinfo.is_valid_opt();
            return;
        end
    end
    %% �����������
    methods
        function [] = toExcel(obj, filename, t, k)
            if(~exist('t', 'var') || ~exist('k', 'var'))
                appendix = '';
            else
                appendix = [num2str(t), '_', num2str(k)];
            end
            %% Ĭ��xlsx����
            className = class(obj);
            if ~exist('filename', 'var')
                disp('û��ָ������ļ�');
                return;
            end

            if isnan(filename)
                filename = [ 'my_' className '.xlsx'];
            elseif isempty(filename)
                filename = [ 'my_' className '.xlsx'];
            else
                po = strfind(filename, '.xls');
                if isempty(po)
                    % �����չ��
                    filename = [filename '.xlsx'];
                else
                    po = po(end);
                    ext = filename(po:end);
                    if ~strcmp(ext, '.xls') ||  ~strcmp(ext, '.xlsx') ...
                            || ~strcmp(ext, '.xlsm') || ~strcmp(ext, '.xlsb')
                        % �ı���չ��
                        filename = [filename(1:po-1) '.xlsx'];
                    end
                end
            end    
            
            %% Ҫ����optionOne�Լ�����Ϣoptinfo
            
            flds    = properties( obj.optinfo );
            F       = length(flds);
            table   = cell(F, 2);

            % ��1��д����,  ��2��д����
            for row = 1:F
                f = flds{row};
                table{row, 1} = f;
                table{row, 2} = obj.optinfo.(f);
            end
            
            xlswrite(filename, table, ['OptionOneInfo',appendix]);                        
            toExcel@AssetOne(obj, filename, appendix);
        end
        
        function [value_row] = to_excel_value(obj)
            % row ����������ɣ�1.option info. 2. positionLong, 3. positionShort
            info_value = obj.optinfo.to_excel_value();
            long_pos_value = obj.positionLong.to_excel_value();
            short_pos_value = obj.positionShort.to_excel_value();
            value_row = [info_value, long_pos_value, short_pos_value];
        end
        
        function [title] = to_excel_title(obj)
            % title �������֣� 1. option info. 2. positionLong 3. positionShort
            info_title = obj.optinfo.to_excel_title();
            long_pos_title = obj.positionLong.to_excel_title();
            short_pos_title = obj.positionShort.to_excel_title();
            title = [info_title, long_pos_title, short_pos_title];
        end
        
        function fromExcel(obj, filename, t, k)
            if(~exist('t', 'var') || ~exist('k', 'var'))
                appendix = '';
            else
                appendix = [num2str(t), '_', num2str(k)];
            end     
            
            sheet_opt = ['OptionOneInfo', appendix];
            try
                [num, txt, raw] = xlsread(filename, sheet_opt);
                [L, C] = size(raw);
                for i = 1:L
                    fd = raw{i, 1};
                    v  = raw{i, 2};
                    if isnan(v), continue; end
                    if isempty(v), continue; end
                    obj.optinfo.(fd) = v;
                end
            catch e
                disp(e);
            end
            
            fromExcel@AssetOne(obj, filename, appendix);
        end
    end
end