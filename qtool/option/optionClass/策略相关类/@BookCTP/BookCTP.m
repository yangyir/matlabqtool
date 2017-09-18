classdef BookCTP < handle
    %BOOK ��һ������Ľ��׵�Ԫ�����������˻��ĸ���
    % ----------------------------------------------
    % �̸գ�20160210���������
    % �̸գ�20160216��������toExcel��loadExcel����������bookinfoҳ
    % �̸գ�20160318������pendingEntrusts
    % �̸գ�20160327�����˺�������pendingEntrust��finishedEntrusts�Ⱥϳ�һ���ʣ������»���
    % cg, 20160329, ����xlsfn����Ӧ�޸�toExcel(), fromExcel()
    % �콭, 20160427, ����virtual_settlement
  
    
    properties(SetAccess = 'public', Hidden = false , GetAccess = 'public')
        % ������Ϣ
        trader = '����';     % ������
        strategy = 'δ֪';   % ������
  
        % ��¼��Ϣ        
        finishedEntrusts@EntrustArray = EntrustArray;  % ���˽���µ���¼
        pendingEntrusts@EntrustArray = EntrustArray; % ���ˣ�����û�˽�ĵ�
        
        % ��λ��Ϣ
        positions@PositionArray = PositionArray;  
        
        % excel�ļ���
        xlsfn@char;
        
        % nav��ʱ��������Ϣ
        
        
        
        % ������Ϣ
%         holdingCode;% �ֲִ���
%         holdingQ;   % �ֲ� 
%         holdingV;   % �ֲ���ֵ
%         
%         callCode@M2TK= M2TK;     % call����ָ��
%         callQ@M2TK   = M2TK;     % call�ֲ�
%         putCode@M2TK = M2TK;     % put����ָ��
%         putQ@M2TK    = M2TK;     % put�ֲ�
        
        
        % �ʽ���� -- ����ƽ�ֺ󣬶�����ʽ�
        cash@double;            % ʵ���ʽ𣨹�����ʵ������Ҫ�������ֱ�Ӳ�
        cashVirtual@double = 0; % �����ʽ���������ֵ��pnl�������ʽ����Ϊ�����Լ������
        cashPending@double = 0; % �µ����ʽ𶳽�
        cashFace = 0;           % ȫ������ֵ(���׼۸�����ʽ𣬿���Ϊ���������Ǳ�֤��
%         cashOwed@double;   % Ƿ������ڱ�֤���ף���ֵ=�����֤��+Ƿ��
%         cashOut@double;    % ����
%         cashIn@double;     % ���
        


        % δƽ��λ
        costFace;   % ��λ����ֵ�ɱ�
        m2mFace;    % ����ֵ�����׼۸���
        m2mPNL;
        
        
        % �ϼ�
        m2m;        % mark-to-market, ��ֵ
        pnl;        % profit-and-loss, ӯ��

        
        % ��ƽ��λ
        realizedPNL;
        historicRealizedPNL;
        fee;
        slippage;   
        
        % ts��Ϣ
        
        % ������Ϣ
        
        
        
        
        
    end
    
    
    %%
    methods
        
        % ��ʼ������
        function obj = Book()
            obj.finishedEntrusts = EntrustArray;
            obj.pendingEntrusts = EntrustArray;
            obj.positions = PositionArray;
        end
               
        function virtual_settlement(book, ST, T)
           % function virtual_settlement(ST, T)
           % ���ڴ����ڵ���ֵ��Ȩ��
           % �ú����д���һ�����ƣ�����ʵֵ��Ȩ�Ĵ����Լ���VolΪ��ֵʱ�Ĵ���
           % ���⽻��ѵ��ڲ�λȫ��ƽ��������realizedPNL
           if ~exist('T','var')
               T     = today;
           end
%            bk = obj.book;
           
           % ����ز�λȡ������ �㵽��pnl��������ƽ�ּ۸�
           pa = book.positions;
%            QMS.set_quoteopt_ptr_in_position_array(pa, qms_.optquotes_);
           L = pa.latest;
           % ��settle_pos_idx ��¼�������pos��֮��Ҫ��PositionArray���������
           settle_pos_idx = 0;
           j = 0;
           for i = 1:L
               pos = book.positions.node(i);
               quote = pos.quote;
               try
                   if(isnan(quote))
                       % �����ڵ�Ʒ��û������ʱ������һ���������
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
               % �ж�T
               if quote.T > T
                   continue;
               end
               
               quote.S = ST;
               quote.calcIntrinsicValue;
               % �ж���ֵ
               if (quote.intrinsicValue == 0 || pos.volume == 0)
                   
                   % ���һ��pos
                   pos.println;
                   
                   % ����һ�����⽻�ף��۸�0������0
                   e = Entrust;
                   
                   % 1, �µ���Ϣ
                   % һ��أ�volumeΪ����������ʱ������Ϊ��
                   if(pos.volume < 0)
                       continue;
                   else
                       di = - pos.longShortFlag * sign(pos.volume);
                   end
                   
                   vo = abs( pos.volume );
                   % һ����ƽ��'2'
                   e.fillEntrust('1', quote.code,  di, 0, vo, '2', quote.optName);
                   
                   % 2, �����µ��ɹ�
                   e.entrustNo = 0;
                   book.push_pendingEntrust(e);
                   
                   % 3������ɽ���Ϣ
                   e.dealAmount = 0;
                   e.dealNum   =  1;
                   e.dealPrice = 0;
                   e.dealVolume = vo;
                   e.fee       = 0;
                   
                   % 4������ɽ�, �ı�position
                   book.sweep_pendingEntrusts
                   % ��PNL��¼Ϊ��ʷPNL
                   pa.merge_historic_pnl(pos);
                   
                   j = j + 1;
                   settle_pos_idx(j) = i;

               end
               
               % �����ʵֵ�������ﴦ��
               if(quote.intrinsicValue > 0)
                   % ����call Ȩ������׼��K�ֽ���Ȩ�����S-K���档���񷽣�׼�������Ա�ļ�,׼��S�ֽ𣬿���
                   switch quote.CP
                       case 'call'
                           settle_pnl = pos.longShortFlag * pos.volume * quote.intrinsicValue;
                           pos.realizedPNL = pos.realizedPNL + settle_pnl;
                           
                       case 'put'
                           % ����put Ȩ������׼������ ���񷽣�׼���ֽ�
                           settle_pnl = pos.longShortFlag * pos.volume * quote.intrinsicValue;
                           pos.realizedPNL = pos.realizedPNL + settle_pnl;                           
                   end
                   
                   % ���һ��pos
                   pos.println;
                   
                   % ����һ�����⽻�ף��۸�0������0
                   e = Entrust;
                   
                   % 1, �µ���Ϣ
                   % һ��أ�volumeΪ����������ʱ������Ϊ��
                   if(pos.volume < 0)
                       continue;
                   else
                       di = - pos.longShortFlag * sign(pos.volume);
                   end
                   
                   vo = abs( pos.volume );
                   % һ����ƽ��'2'
                   e.fillEntrust('1', quote.code,  di, 0, vo, '2', quote.optName);
                   
                   % 2, �����µ��ɹ�
                   e.entrustNo = 0;
                   book.push_pendingEntrust(e);
                   
                   % 3������ɽ���Ϣ
                   e.dealAmount = 0;
                   e.dealNum   =  1;
                   e.dealPrice = 0;
                   e.dealVolume = vo;
                   e.fee       = 0;
                   
                   % 4������ɽ�, �ı�position
                   book.sweep_pendingEntrusts
                   % ��PNL��¼Ϊ��ʷPNL
                   pa.merge_historic_pnl(pos);                   
                   j = j + 1;
                   settle_pos_idx(j) = i;
               end
               
           end
           
           % �������ĳֲ֡�
           % ����ʱע����Ҫ��������indexʧЧ��
           clean_L = length(settle_pos_idx);
           for i = clean_L : -1 : 1
               rm_pos_idx = settle_pos_idx(i);
               pa.removeByIndex(rm_pos_idx);
           end
           
           book.calc_m2m_pnl_etc;
           book.positions;   
        end
        
        function [book] = eod_netof_positions(book)
            % ��ĩ�����ֲ�
            tm = now - floor(now);
            if (tm>=9.5/24  && tm<=15/24)
                fprintf('����ʱ�䣬���ܽ��кϲ����ֲ֣�');
                return;
            end
            
            while(1)
                pa = book.positions;
                L = length(pa.node);
                % ���취��ð�����Ƚ�
                
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
                                % �ϲ����ֲ֣���ɾ��ĩβԪ�ء���β��ɾ������Ӱ��ǰ����������
                                merge_pos = pa.node(merge_pos_id);
                                probe.merge_position_netoff(merge_pos);
                                pa.removeByIndex(merge_pos_id);
                            end
                        end
                        % �˴�����probe ��ѭ������������Positions���ٴμ���ϲ�
                        break;
                    end
                end
                
                if ~merged
                    % û�п��Լ����ϲ��ģ�����ѭ��
                    break;
                else
                    continue;
                end
            end
        end
        
        function eod_virtual_cancel_all_pendingEntrusts(book, ctr)
            % ������ĩ�����ɵ�����ʱ���޷��´�cancelָ�
            
            % �����Ƿ�eod��������
            tm = now - floor(now);
            if (tm>=9.5/24  && tm<=15/24)
                fprintf('����ʱ�䣬���ܽ������⳷����');
                return;
            end
            
            % ע��Ӧ���Ȳ�ѯһ�����е�pendingEntrusts            
            if exist('ctr', 'var')
                book.query_pendingEntrusts(ctr);                
            end
            
            % ��ĩʱ������δ������ί�е������ֳɽ�������δ�ɽ���
            book.sweep_pendingEntrusts;
            
            % �٣��ı�Entrust��״̬��Ϊ�Ѵ���
            ea = book.pendingEntrusts;
            L  = ea.latest;
            
            for i = 1:L
                e = ea.node(i);
                e.clearEntrust();
            end
            
            % ����ٴ�ɨһ��pendingEntrusts
            book.sweep_pendingEntrusts;
        end
        
        % ����һ��pendingEntrust�� ÿ���µ���Ҫ��
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
             % ��һ��ѯһ��pendingEntrusts
             
             if ~exist( 'counter', 'var')
                 warning('�����޷���ѯ�������ṩ��̨counter��');
                 return;
%                  counter = obj.counter;
             end
            
            % �ȣ���ɨһ��pendingEntrusts
            book.sweep_pendingEntrusts;
            
            % �٣���ctr��ѯʣ�µ�pending
            ea = book.pendingEntrusts;
            L  = ea.latest;
            
            for i = 1:L
                e = ea.node(i);
                % TODO��Ӧ���ж�e�ı�����ͣ���Ʊ����Ȩ���ڻ���
                ems.query_optEntrust_once_and_fill_dealInfo(e, counter);
            end
            
            % ����ٴ�ɨһ��pendingEntrusts
            book.sweep_pendingEntrusts;            
        end
        
        function cancel_pendingOptEntrusts(book, counter)
             if ~exist( 'counter', 'var')
                 warning('�����޷���ѯ�������ṩ��̨counter��');
                 return;
             end       
             
            % ��������������������
            ea = book.pendingEntrusts;
            L  = ea.latest;
            
            for i = 1:L
                e = ea.node(i);
                % TODO��Ӧ���ж�e�ı�����ͣ���Ʊ����Ȩ���ڻ���
                ems.cancel_optEntrust_and_fill_cancelNo(e, counter);
            end
            
            
            % ��ѯ״̬
            book.query_pendingEntrusts(counter);
            
            % ����
            book.sweep_pendingEntrusts;
        end
        
        
        % ���pending�Ƿ�����ɣ�������ɣ�����
        function sweep_pendingEntrusts(bk)
            % ��ɨpendingEntrusts��
            % 1���������ɣ�remove�� ͬʱ����finishedEntrusts, ����positions
            % 2���������Ϊ0�� remove
            
            
            ea1 = bk.pendingEntrusts;
            ea2 = bk.finishedEntrusts;

            L = ea1.latest;
            for i = L:-1:1
                e = ea1.node(i);
                
                % �����������������ѯ
                
                if e.is_entrust_closed
                    % ����finished�У� ������position
                    if e.volume > 0
                        bk.update_finishedEntrust( e);
                    end
                    % ��pending��ȥ��
                    ea1.removeByIndex(i);
                    
                    disp('�ҵ�����');
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
            % һ��entrust�����ˣ�����book�ﴦ����
            %  �����ڴ˺���� 1����pendingEntrust�г���
            %   2������finishedEntrusts
            %   3���ı�positions
            %   4���ı�cash��fee��slippage��
            
            ea = bk.finishedEntrusts;            
            pa = bk.positions;
            
%             if e.entrustStatus <= 0  % ���˽�
            if e.is_entrust_closed
                % ��pendingEntrust�ж�Ӧ�Ķ����������Ž�finishedEntrust
                ea.push(e);
                
                % Ҫ�Ѳ�λ����ˣ�ֻ���˽��ʱ���㣿�������м�����㣿��
                % ��Entrustת��Position�� ��merge
                newp = e.deal_to_position;
                % �������position���ϲ��������¼�
                pa.try_merge_ifnot_push(newp);
                
                % ����������Ҫ�����ֽ�仯
                % �����ģ����⣩�ʽ�
                bk.cashFace = bk.cashFace - newp.faceCost;
                
                % TODO: cashPendingҪ����cashVirtual
                % TODO��cashVirtualҪ��ȥ��֤���
                
                
            end
        end
        
        
        % ����pnl
        function calc_m2m_pnl_etc(bk)
            % ����book��ֵ��ص���
            %   1��ȡ�ֲ��ʲ��ļ۸� ( ����Position���ˣ������ڴ��ظ���
            %   2����positions��m2m, pnl
            %   3����positions�ĸ���book
            %   4��ȡ��ʵcash�������ǹ���û������
            %   5������ɣ����ʲ��ı�֤�𣬼��ɱ��ּ�ֵ�����positions��
            
            pa = bk.positions;
            
            %   1,ȡ�ֲ��ʲ��Ľ��׼۸�
            %  ��Ϊposition�Դ�quoteָ�룬����ֱ��ȡ�۸����
            
            %   2����positions��m2m, pnl
            pa.calc_faceCost;   % �����������漰����
            pa.calc_cashOccupied;  % 
            pa.calc_m2mFace_m2mPNL;
            pa.calc_realizedPNL;            
            
            
            %   3����position��cost��m2m, pnl ����book
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
        
        % ���������ʷ��Ϣ�ķ���
        function [filename] = toExcel(obj, filename)

            
            %% Ĭ��xlsx����
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
    
            obj.xlsfn = filename;
            
            %% �����excel�ļ�
            obj.clearExcel(obj.xlsfn);
            %% Ҫ����book�Լ�����Ϣbookinfo
            
            flds    = properties( obj );
            F       = length(flds);
            table   = cell(F, 2);

            % ��1��д����,  ��2��д����
            for row = 1:F
                f = flds{row};
                table{row, 1} = f;
                table{row, 2} = obj.(f);
            end
            
            xlswrite(filename, table, 'bookinfo');            
            
            %% ���ģ��Ž�positions�� entrusts
            obj.positions.toExcel(filename);            
            obj.finishedEntrusts.toExcel(filename);

            obj.pendingEntrusts.toExcel(filename, 'pendingEntrust');
            
            fprintf('saved to: %s\n', filename);
        end
        
        
        function fromExcel(obj,filename)
            % ��excel��ȡ��ǰ�մ���ģ�book
            % book.fromExcel(filename)
            % cg, 20160311, ��ȡǰ�����
            
            
            if ~exist('filename', 'var')
                filename = obj.xlsfn;
            end
            
            if ~exist(filename, 'file')
                disp('Book �ļ�������');
                return;
            end
            
            %% ��book info
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
            
            %% ���ģ���positions, entrusts
            obj.positions.loadExcel(filename, 'Position');
            obj.finishedEntrusts.loadExcel(filename, 'Entrust');
            obj.pendingEntrusts.loadExcel(filename, 'pendingEntrust');
            
            
        end
        
        
        % �������ķ���
        
        
    end
    
    
    methods(Static = true)
        
        demo;
        
    end
    
    
end

