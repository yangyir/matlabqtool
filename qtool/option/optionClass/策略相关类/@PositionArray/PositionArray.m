classdef PositionArray < ArrayBase
    %POSITIONARRAY �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    %  --------------------------------------------
    % �̸գ�20160318������cashOccupied �� calc_cashOccupied(pos)

    
    properties(Abstract = false)
        % ���ﲻ��д node@Position, ��Ϊ����ArrayBase����nodeû���κ�����
        % ���е�����ֻ����set������д
        % ͬʱ�������ʼ������ȷ���࣬���򣬺�����ֵ�����
        node  = Position;
        
        
        % ��Ҫ��һЩ������
        faceCost;   % ��ǮΪ��
        m2mFace;
        m2mPNL;
        m2mOpenPNL;
        m2mPreClosePNL;
        realizedPNL;
        cashOccupied@double;
        realizedHistoricPNL@double;
    end
    
    methods
        function set.node(self, node)
            if isa(node, 'Position')
                self.node = node;
            else
                warning('��ֵʧ�ܣ����ʹ���');
            end
        end
        
        function [c] = calc_faceCost(obj)
            c = 0 ;
            for i = 1:length(obj.node)
                c = c + obj.node(i).faceCost;
            end
            obj.faceCost = c;
        end
        
       function [co] = calc_cashOccupied(obj)
            co = 0 ;
            for i = 1:length(obj.node)                
                co = co + obj.node(i).calc_cashOccupied;
            end
            obj.cashOccupied = co;
       end
        
        
        function [pl] = calc_realizedPNL(obj)
            % pnl���ۻ��ģ�����е�positionɾ���ˣ�����pnl��ô�죿
%             pl = obj.realizedPNL;
            pl = 0;
            for i = 1:length(obj.node)
                thispl = obj.node(i).realizedPNL;
                if isnan(thispl), thispl = 0; end
                if isempty(thispl), thispl =0; end
                pl = pl + thispl;
            end
            
            % ������ʷPNL
            hist_pl = 0;
            for j = 1:length(obj.realizedHistoricPNL)
                hist_pl = hist_pl + obj.realizedHistoricPNL(j);
            end
            obj.realizedPNL = pl + hist_pl;
        end
        
        function [v, pl, openpl, preclosepl] = calc_m2mFace_m2mPNL(obj)
            v = 0;
            pl = 0;
            openpl = 0;
            preclosepl = 0;
%             rpl = 0;
            for i = 1:length(obj.node)
                posi = obj.node(i);
                posi.calc_m2mFace_m2mPNL();
                v = v + posi.m2mFace;
                pl = pl + posi.m2mPNL;
                openpl = openpl + posi.m2mOpenPNL;
                preclosepl = preclosepl + posi.m2mPreClosePNL;
%                 rpl = rpl + posi.realizedPNL;
            end
            obj.m2mFace = v;
            obj.m2mPNL = pl;
            obj.m2mOpenPNL = openpl;
            obj.m2mPreClosePNL = preclosepl;
        end
        
        function [obj] = sort_by_code(obj)
            % sort_by_code() will sort the entrusts by lexicographical order
            % according their instrument code
            % convert element code to fit sort argument
            % build in sort function accept {'code a' 'code b' 'code c' 'code d'}
            [~,idx] = sort({obj.node.instrumentCode});
            obj.node = obj.node(idx);
        end
        
        function new = copy(obj)
            % copy() is for deep copy case.
            new = feval(class(obj));
            % copy all non-hidden properties
            p = properties(obj);
            for i = 1:length(p)
                new.(p{i}) = obj.(p{i});
            end
        end      
        
        function [obj] = merge_historic_pnl(obj, pos)
            pos_realizedPNL = pos.realizedPNL + pos.m2mPNL;
            last = length(obj.realizedHistoricPNL);
            obj.realizedHistoricPNL(last + 1) = pos_realizedPNL;
        end
        
        function [successMerge] = try_merge_ifnot_push(obj, newp)
            % ��һ���Ժ�oldposition�ϲ������δ�����ͼ��¼�newposition
            
            % ��֤newp����Ч��, ���������volume==0�����
            if newp.volume == 0 
                disp('volume==0, ����ϲ�newPosition');
                return;
            end
            
            ps = obj.node;
            L = length(ps);
            L2 = obj.latest;
            L = min(L, L2);
            
            warning off;
            for i = 1:L
                oldp = ps(i);
                successMerge = oldp.mergePosition(newp);
                if successMerge == 1
                    ps(i) = oldp;  % �Ƿ���Ҫ��
                    disp('�ϲ���λ�ɹ�');
                    return;
                end
            end
            warning on;
            
            disp('�½���λ');
            obj.push(newp);
        end
        
        
        
        function [ s] = positionArray_to_structure(pa, pxType)
            % ��positionArray���structure���Լ��㡢��ͼ��
            % [ s] = positionArray_to_structure(pa, pxType)
            %   pxTypeȡֵ�� 'ask', 'bid', 'mid', 'last'
            % ��Ҫposition���Ѿ��Һ�quote��������
            %   QMS.set_quoteopt_ptr_in_position_array(pa, q)

            
            if ~exist('pxType', 'var')
                pxType  = 'ask';  % 'mid';
            end
            
            % position ת�� pricer��num������structure
            L = pa.latest;
            L = length( pa.node );
            
            s = Structure;
            for i = 1:L
                try
                    pos = pa.node(i);
                    quote = pos.quote;
                    pricer = quote.QuoteOpt_2_OptPricer( pxType );
                    num = pos.volume * pos.longShortFlag;
                    s.optPricers(i) = pricer;
                    s.num(i)    = num;
                catch
                    disp('positionת��optPricerʧ��');
                end
            end
            
            
        end
            
        
        function [] = clear(pa)
            pa.node = Position;
            pa.faceCost = 0;   % ��ǮΪ��
            pa.m2mFace = 0;
            pa.m2mPNL = 0;
            pa.realizedPNL = 0;
            pa.cashOccupied = 0;
        end
       
        function [] = fillHistoricalQuote(pa, day)
            % 
            L = length( pa.node );
            for i = 1:L
                p = pa.node(i);
                p.constructQuoteobj;
                p.quote.fillHistoricalQuote(day);
            end
        end
    end
    
    methods (Static = true)
        [merged_array] = merge_two_position_array(src_arr, dst_arr);
    end
    
    methods(Static = true)
        demo;
        
    end
end

