classdef AssetOne < handle
%AssetOne ������Asset�Ϸ����Ĺҵ����ֲ֣��ɽ���¼�����պ�PNL���㣬�������顣
% cg: ����һЩͳ��������ø�Bookһ���ˣ� 
% cg, 20160403, ���ԣ�ʹ��positionLong�� positionShort�� positionNet
% cg, 20160404, ������������� 
%         print_pendingEntrusts(assetone)
%         print_pendingEntrusts_quotes(assetone)
% cg, 2016404, ���뺯��
%         calc_positionNet(obj)
% cg, 20161015, ������ ��marketmaking��
%         askOrderBook@OrderBookPartial;
%         bidOrderBook@OrderBookPartial;
% ����Ҫ�� ��Ҫ��properties���ʼ��handle�࣬ �����ָ����ң� ��ͬʵ��ȫ��ָ��ͬһָ�룡��
%     ��Ҫ��
%     properties
%         askOrderBook@OrderBookPartial = OrderBookPartial('ask');
%     end
%     Ҫ��
%     function AssetOne
%         obj.bidOrderBook = OrderBookPartial('ask');
%     end
                    

    
    properties
              
        
        positions@PositionArray = PositionArray;        
       
        
        pendingEntrusts@EntrustArray = EntrustArray;
        finishedEntrusts@EntrustArray = EntrustArray;
        
        
         % �Ƿ�����ֱ�Ӽ�¼���ã�
        positionLong@Position;
        positionShort@Position;
        positionNet@Position; % ֻ����һ����������ʵ��λ
        
        
        
        pendingBuyEntrusts@EntrustArray;
        pendingSellEntrusts@EntrustArray;
        
        % �ݶ�����Ϊ��������Ҫ�������������Ҫ�ع�ɾ��, 201610
        % ��Ҫ�� ��Ҫ�������ʼ����������        
        askOrderBook; %@OrderBookPartial;
        bidOrderBook; %@OrderBookPartial; 
        
%         askOrderBook@OrderBookPartial = OrderBookPartial('ask');
        
        
        
        counter;

        
        % ��¼��
        dayTradingMiscs@DayTradingMiscs;
        % ������
        
        
        % δƽ��λ
        costFace;   % ��λ����ֵ�ɱ�
        m2mFace;    % ����ֵ�����׼۸���
        m2mPNL;
        
        % ��ƽ��λ
        realizedPNL;
        fee;
        slippage;   
        
        % �ϼ�
        m2m;        % mark-to-market, ��ֵ
        pnl;        % profit-and-loss, ӯ��


    end
    
    
    
    methods
        % TODO������ܶຯ����ֱ�Ӵ�Book�����������ڲ�����ɺ�Ӧ�ý���Щ�ظ������鼯��һ����
        % ��ȡ��������Ϊ���࣬������ĳ���������ࡣ
        function obj = AssetOne()
            obj.finishedEntrusts = EntrustArray;
            obj.pendingEntrusts = EntrustArray;
            obj.positions       = PositionArray;
            
%             obj.positionLong  = Position;
%             obj.positionShort = Position;
            obj.positionLong = Position;
            obj.positionShort = Position;
            obj.positionNet = Position;
            obj.positionLong.longShortFlag = 1;
            obj.positionShort.longShortFlag = -1;
            obj.dayTradingMiscs = DayTradingMiscs;
            
            %%
            obj.askOrderBook = OrderBookPartial('ask');
            obj.bidOrderBook = OrderBookPartial('bid');
        end
        
        function push_pendingEntrust(assetone, e)
            eNo = e.entrustNo;
            if isempty(eNo)
                return;
            end
            if isnan(eNo)
                return;
            end
            
            % main 
            ea = assetone.pendingEntrusts;
            ea.push(e);
            
            
            % ��������˫��pendingArray�����
            
            
            % ��¼��
            vol = abs(e.volume);
            if(e.offsetFlag == 1)
                assetone.dayTradingMiscs.handle_open_limit(vol);
            elseif (e.offsetFlag == -1)
                assetone.dayTradingMiscs.handle_close_limit(vol);
            end            
        end
        
        
        function query_pendingEntrusts(assetOne, counter)
            % ��һ��ѯһ��pendingEntrusts
            
            if ~exist( 'counter', 'var')
%                 warning('�����޷���ѯ�������ṩ��̨counter��');
%                 return;
                counter = assetOne.counter;
            end
            
            % �ȣ���ɨһ��pendingEntrusts
            assetOne.sweep_pendingEntrusts;
            
            % �٣���ctr��ѯʣ�µ�pending
            ea = assetOne.pendingEntrusts;
            L  = ea.latest;
            
            for i = 1:L
                e = ea.node(i);
                % TODO��Ӧ���ж�e�ı�����ͣ���Ʊ����Ȩ���ڻ���
                ems.query_optEntrust_once_and_fill_dealInfo(e, counter);
            end
            
            % ����ٴ�ɨһ��pendingEntrusts
            assetOne.sweep_pendingEntrusts;
        end
        
        % ���pending�Ƿ�����ɣ�������ɣ�����
        function sweep_pendingEntrusts(assetone)
            % ��ɨpendingEntrusts��
            % 1���������ɣ�remove�� ͬʱ����finishedEntrusts, ����positions
            % 2���������Ϊ0��remove
            
            ea1 = assetone.pendingEntrusts;

            L = ea1.latest;
            for i = L:-1:1
                e = ea1.node(i);
                
                % �������Ϊ0�� remove
                if e.volume <= 0 
                    disp('wrong entrust');
                    e.println;

                    ea1.removeByIndex(i);
                    continue;
                end
                
                
                if e.is_entrust_closed
                    % ����finished�У� ������position
                    assetone.update_finishedEntrust( e)
                    
                    % ��pending��ȥ��
                    ea1.removeByIndex(i);
                    
                    % ��ʾһ��
                    disp('�ҵ�����');
                    e.println;
                    continue;
                end
                

            end   
        end
        
        function update_finishedEntrust(assetone,e)
            % һ��entrust�����ˣ�����book�ﴦ����
            %  �����ڴ˺���� 1����pendingEntrust�г���
            %   2������finishedEntrusts
            %   3���ı�positions
            %   4���ı�cash��fee��slippage��
            
            ea = assetone.finishedEntrusts;            
            pa = assetone.positions;
            
            if e.is_entrust_closed
                % ��pendingEntrust�ж�Ӧ�Ķ����������Ž�finishedEntrust
                ea.push(e);
                
                % Ҫ�Ѳ�λ����ˣ�ֻ���˽��ʱ���㣿�������м�����㣿��
                % ��Entrustת��Position�� ��merge
                newp = e.deal_to_position;
                
                
                
                % �������position���ϲ��������¼�
                pa.try_merge_ifnot_push(newp);
                
                
                
               % ��positionLong��positionShort�����ı�
               if newp.longShortFlag == 1
                   assetone.positionLong.mergePosition( newp );
               elseif newp.longShortFlag == -1
                   assetone.positionShort.mergePosition( newp );
               end

               % ��¼Miscs
               % newposition ��volume ����Ϊ����
               %         direction;      % ��@double��setter���ƣ���������buy = 1; sell = -1;
               %         offsetFlag = 1; % ��@double��setter���ƣ���ƽ����, open = 1; close = -1;
               deal_vol = abs(e.dealVolume);
               withdraw_vol = abs(e.cancelVolume);
               if(e.offsetFlag == 1)
                   assetone.dayTradingMiscs.handle_open_filled(deal_vol, withdraw_vol);
               elseif(e.offsetFlag == -1)
                   assetone.dayTradingMiscs.handle_close_filled(deal_vol, withdraw_vol);
               end
                % ����������Ҫ�����ֽ�仯
                % �����ģ����⣩�ʽ�
%                 bk.cashFace = bk.cashFace - newp.faceCost;
                
            end
        end
        
        
        function calc_positionNet(obj)
            posL = obj.positionLong;
            posS = obj.positionShort;            
            pos  = obj.positionNet;
            
            % ����instrumentCode�ļ��飿 ��ʡʱ��
            vl = posL.longShortFlag * posL.volume;
            vs = posS.longShortFlag * posS.volume;
            netV = vl + vs;
            
            pos.longShortFlag  = sign(netV);
            pos.volume         = abs(netV);
            pos.faceCost       = posL.faceCost + posS.faceCost;
            pos.realizedPNL    = posL.realizedPNL + posS.realizedPNL;
            pos.avgCost        = pos.faceCost / pos.volume;
            pos.calc_m2mFace_m2mPNL;
            pos.calc_cashOccupied;

            % ������pos����һ�ϲ�
%             pos = Position;
%             pos.instrumentCode = posL.instrumentCode;            
%             pos.merge_position_netoff( posL );
%             pos.merge_position_netoff( posS );
%             obj.positionNet = pos;
            
            
        end
    end
        
    %% һϵ���������
    methods
        
        function print_pendingEntrusts(assetone)
            % ��ӡ�ҵ����������ͬ�� 
%            -2	0.0196	
%            -4	0.0195	
%            -7	0.0194	
%                 0.0193	3
%                 0.0193	3
%                 0.0192	3
%                 0.0192	3
%                 0.0192	2


            pe = assetone.pendingEntrusts;
            pe.print_assetone_entrusts;
            
        end
        
        function print_pendingEntrusts_quotes(assetone)
            % ͬʱ��ӡ�̿ں͹ҵ�
            % ����Ѽ۸�ȫ�������� һ������
            % �ο�QuoteOpt.print_pankou() ��
            % EntrustArray.print_assetone_entrusts()
            % ��ͬ��
            % 8		0.1650
            % 6		0.1645
            % 2	11	0.1202
            % 	2	0.1201
            % 	2	0.1184
            % 1	1	0.1181
            % 	1	0.1178
            % 		0.1151	1
            % 		0.1135	1
            % 		0.1131	10	4
            % 		0.1125	1	1
            % 		0.1116	1
            

            % �ȼ���δ�ɽ�������5��1�����ҷ��ҵ�
            pe = assetone.pendingEntrusts;
            L = pe.latest;
            mat0 = zeros(L, 5);
            for i = 1:L
                e = pe.node(i);
                mat0(i,:) = [e.direction, e.price, 0, e.volume, 1];
            end

            % �ټ����̿ڹҵ�, ��5��2�����г��ҵ�
            quote = assetone.quote;
           
            mat1(1,:) = [-1, quote.askP5, quote.askQ5, 0, 2];
            mat1(2,:) = [-1, quote.askP4, quote.askQ4, 0, 2];
            mat1(3,:) = [-1, quote.askP3, quote.askQ3, 0, 2];
            mat1(4,:) = [-1, quote.askP2, quote.askQ2, 0, 2];
            mat1(5,:) = [-1, quote.askP1, quote.askQ1, 0, 2];
            
            
            mat2(1,:) = [1, quote.bidP1, quote.bidQ1, 0, 2];
            mat2(2,:) = [1, quote.bidP2, quote.bidQ2, 0, 2];            
            mat2(3,:) = [1, quote.bidP3, quote.bidQ3, 0, 2];
            mat2(4,:) = [1, quote.bidP4, quote.bidQ4, 0, 2];
            mat2(5,:) = [1, quote.bidP5, quote.bidQ5, 0, 2];
            
                         
            % �ϲ�
            % ��1-��������2-�۸���3-�г��ҵ�����4-�ҷ��ҵ�����5-��ǣ�����û�ã���
            mat = [mat0; mat1; mat2];
            
            
            % sort price
            [px, idx] = sort(mat(:,2), 'descend');
            L_old = length(px);
            pxuni = unique(px);
            L = length(pxuni);
            
            % �ϲ�ͬ�۸������
            matnew = nan( L, 5);
            j = 1;
            for i = 1:L
                % 
                matnew(i, :) = mat(idx(j), :);
                j = j+1;
                if j > L_old
                    continue;
                end
                while matnew(i, 1) == mat(idx(j),1)  && matnew(i,2) == mat(idx(j),2)
                    matnew(i, 3:4)  = matnew(i,3:4) + mat(idx(j),3:4);
                    j = j+1;               
                end
            end
            
            
            %% ��ӡ, ��������������
            % 1���ҷ�������2���г�������3�м۸�4���г�������5���ҷ���
% 8		0.1650	
% 6		0.1645	
% 	11	0.1202	
% 	2	0.1201	
% 	2	0.1184	
% 	1	0.1181	
% 	1	0.1178	
% 		0.1151	1	
% 		0.1135	1	
% 		0.1131	10	4
% 		0.1125	1	1
% 		0.1116	1	
            for i = 1:L
                if matnew(i, 1) == 1  % ��
                    fprintf('\t\t%0.4f\t', matnew(i,2) );
                    if matnew(i,3) ~= 0 
                        fprintf('%d', matnew(i,3) ) ;
                    end
                    fprintf('\t');
                    if matnew(i,4) ~= 0
                        fprintf('%d', matnew(i,4) );
                    end
                    fprintf('\n');                   
                        
                elseif matnew(i,1) == -1 %����
                     if matnew(i,4) ~= 0 
                        fprintf('%d', matnew(i,4) ) ;
                    end
                    fprintf('\t');
                    if matnew(i,3) ~= 0
                        fprintf('%d', matnew(i,3) );
                    end
                    fprintf('\t%0.4f\t\n', matnew(i,2) );
                end
            end

        end
        
        
        
        
        
        function toExcel(obj, filename, appendix)
        % ÿ��assetone������һ��excel���� ���Ǵ�ҹ�ͬ��һ����
        % �Ƿ񹲴�һ������fn��appendix�����ƣ�appendixΪsheetname ��׺��
            %% ���ģ��Ž�positions�� entrusts
            obj.positions.toExcel(filename, ['positions',appendix]);            
            obj.finishedEntrusts.toExcel(filename, ['f_entrusts', appendix]);
            
            % �Ȱ�pendingEntrustҳȫ����ף���д
            pending_sheet = ['p_Entrust', appendix];
            xlswrite(filename, {''}, pending_sheet,'A:AH');
            obj.pendingEntrusts.toExcel(filename, pending_sheet);
            
            fprintf('save to: %s, appendix:%s\n', filename, appendix);            
        end
        
        function fromExcel(obj, filename, appendix)
            % ��Excel�ļ�����������
            obj.positions.loadExcel(filename, ['positions',appendix]);
            obj.finishedEntrusts.loadExcel(filename, ['f_entrusts', appendix]);
            obj.pendingEntrusts.loadExcel(filename, ['p_Entrust', appendix]);
        end
        
    end
        
        
end