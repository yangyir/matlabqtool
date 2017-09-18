classdef PositionArray < ArrayBase
    %POSITIONARRAY 此处显示有关此类的摘要
    %   此处显示详细说明
    %  --------------------------------------------
    % 程刚，20160318，加入cashOccupied 及 calc_cashOccupied(pos)

    
    properties(Abstract = false)
        % 这里不能写 node@Position, 因为基类ArrayBase申明node没带任何限制
        % 所有的限制只能在set方法里写
        % 同时，必须初始化成正确的类，否则，后续赋值会出错
        node  = Position;
        
        
        % 还要有一些汇总量
        faceCost;   % 花钱为正
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
                warning('赋值失败：类型错误！');
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
            % pnl是累积的，如果有的position删除了，它的pnl怎么办？
%             pl = obj.realizedPNL;
            pl = 0;
            for i = 1:length(obj.node)
                thispl = obj.node(i).realizedPNL;
                if isnan(thispl), thispl = 0; end
                if isempty(thispl), thispl =0; end
                pl = pl + thispl;
            end
            
            % 加入历史PNL
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
            % 逐一尝试和oldposition合并，如果未果，就加新加newposition
            
            % 验证newp的有效性, 撤单会造成volume==0的情况
            if newp.volume == 0 
                disp('volume==0, 不予合并newPosition');
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
                    ps(i) = oldp;  % 是否需要？
                    disp('合并仓位成功');
                    return;
                end
            end
            warning on;
            
            disp('新建仓位');
            obj.push(newp);
        end
        
        
        
        function [ s] = positionArray_to_structure(pa, pxType)
            % 把positionArray变成structure，以计算、作图等
            % [ s] = positionArray_to_structure(pa, pxType)
            %   pxType取值： 'ask', 'bid', 'mid', 'last'
            % 需要position上已经挂好quote，否则不行
            %   QMS.set_quoteopt_ptr_in_position_array(pa, q)

            
            if ~exist('pxType', 'var')
                pxType  = 'ask';  % 'mid';
            end
            
            % position 转成 pricer和num，加入structure
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
                    disp('position转成optPricer失败');
                end
            end
            
            
        end
            
        
        function [] = clear(pa)
            pa.node = Position;
            pa.faceCost = 0;   % 花钱为正
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

