classdef AssetOne < handle
%AssetOne 包含该Asset上发生的挂单，持仓，成交记录，风险和PNL计算，包含行情。
% cg: 加了一些统计量，变得跟Book一样了？ 
% cg, 20160403, 尝试：使用positionLong， positionShort， positionNet
% cg, 20160404, 加入输出函数， 
%         print_pendingEntrusts(assetone)
%         print_pendingEntrusts_quotes(assetone)
% cg, 2016404, 加入函数
%         calc_positionNet(obj)
% cg, 20161015, 加入域， 供marketmaking用
%         askOrderBook@OrderBookPartial;
%         bidOrderBook@OrderBookPartial;
% ！重要： 不要在properties里初始化handle类， 会造成指针混乱， 不同实例全部指向同一指针！！
%     不要：
%     properties
%         askOrderBook@OrderBookPartial = OrderBookPartial('ask');
%     end
%     要：
%     function AssetOne
%         obj.bidOrderBook = OrderBookPartial('ask');
%     end
                    

    
    properties
              
        
        positions@PositionArray = PositionArray;        
       
        
        pendingEntrusts@EntrustArray = EntrustArray;
        finishedEntrusts@EntrustArray = EntrustArray;
        
        
         % 是否这样直接记录更好？
        positionLong@Position;
        positionShort@Position;
        positionNet@Position; % 只供看一看，不是真实仓位
        
        
        
        pendingBuyEntrusts@EntrustArray;
        pendingSellEntrusts@EntrustArray;
        
        % 暂定量，为了做市需要，如果有问题需要回滚删除, 201610
        % 重要： 不要在这里初始化！！！！        
        askOrderBook; %@OrderBookPartial;
        bidOrderBook; %@OrderBookPartial; 
        
%         askOrderBook@OrderBookPartial = OrderBookPartial('ask');
        
        
        
        counter;

        
        % 记录量
        dayTradingMiscs@DayTradingMiscs;
        % 汇总量
        
        
        % 未平仓位
        costFace;   % 仓位的面值成本
        m2mFace;    % 总面值（交易价格）算
        m2mPNL;
        
        % 已平仓位
        realizedPNL;
        fee;
        slippage;   
        
        % 合计
        m2m;        % mark-to-market, 市值
        pnl;        % profit-and-loss, 盈亏


    end
    
    
    
    methods
        % TODO：这里很多函数是直接从Book拷贝而来，在测试完成后，应该将这些重复函数归集到一处。
        % 提取公共部分为基类，或者是某个类的组成类。
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
            
            
            % 辅助：向双向pendingArray中添加
            
            
            % 记录量
            vol = abs(e.volume);
            if(e.offsetFlag == 1)
                assetone.dayTradingMiscs.handle_open_limit(vol);
            elseif (e.offsetFlag == -1)
                assetone.dayTradingMiscs.handle_close_limit(vol);
            end            
        end
        
        
        function query_pendingEntrusts(assetOne, counter)
            % 逐一查询一遍pendingEntrusts
            
            if ~exist( 'counter', 'var')
%                 warning('错误：无法查询，必须提供柜台counter！');
%                 return;
                counter = assetOne.counter;
            end
            
            % 先：打扫一遍pendingEntrusts
            assetOne.sweep_pendingEntrusts;
            
            % 再：从ctr查询剩下的pending
            ea = assetOne.pendingEntrusts;
            L  = ea.latest;
            
            for i = 1:L
                e = ea.node(i);
                % TODO：应该判断e的标的类型（股票、期权、期货）
                ems.query_optEntrust_once_and_fill_dealInfo(e, counter);
            end
            
            % 最后：再打扫一遍pendingEntrusts
            assetOne.sweep_pendingEntrusts;
        end
        
        % 检查pending是否已完成，如已完成，处理
        function sweep_pendingEntrusts(assetone)
            % 清扫pendingEntrusts：
            % 1，如果已完成，remove， 同时移入finishedEntrusts, 更新positions
            % 2，如果数量为0，remove
            
            ea1 = assetone.pendingEntrusts;

            L = ea1.latest;
            for i = L:-1:1
                e = ea1.node(i);
                
                % 如果数量为0， remove
                if e.volume <= 0 
                    disp('wrong entrust');
                    e.println;

                    ea1.removeByIndex(i);
                    continue;
                end
                
                
                if e.is_entrust_closed
                    % 加入finished中， 并更新position
                    assetone.update_finishedEntrust( e)
                    
                    % 从pending中去掉
                    ea1.removeByIndex(i);
                    
                    % 显示一下
                    disp('挂单结束');
                    e.println;
                    continue;
                end
                

            end   
        end
        
        function update_finishedEntrust(assetone,e)
            % 一个entrust结束了，就在book里处理它
            %  （不在此函数里） 1，从pendingEntrust中撤除
            %   2，加入finishedEntrusts
            %   3，改变positions
            %   4，改变cash，fee，slippage等
            
            ea = assetone.finishedEntrusts;            
            pa = assetone.positions;
            
            if e.is_entrust_closed
                % 把pendingEntrust中对应的都拉出来，放进finishedEntrust
                ea.push(e);
                
                % 要把仓位算对了（只在了结的时候算？还是在中间过程算？）
                % 把Entrust转成Position， 再merge
                newp = e.deal_to_position;
                
                
                
                % 如果已有position，合并，否则，新加
                pa.try_merge_ifnot_push(newp);
                
                
                
               % 向positionLong和positionShort中做改变
               if newp.longShortFlag == 1
                   assetone.positionLong.mergePosition( newp );
               elseif newp.longShortFlag == -1
                   assetone.positionShort.mergePosition( newp );
               end

               % 记录Miscs
               % newposition 的volume 可能为负。
               %         direction;      % （@double，setter控制）买卖方向，buy = 1; sell = -1;
               %         offsetFlag = 1; % （@double，setter控制）开平性质, open = 1; close = -1;
               deal_vol = abs(e.dealVolume);
               withdraw_vol = abs(e.cancelVolume);
               if(e.offsetFlag == 1)
                   assetone.dayTradingMiscs.handle_open_filled(deal_vol, withdraw_vol);
               elseif(e.offsetFlag == -1)
                   assetone.dayTradingMiscs.handle_close_filled(deal_vol, withdraw_vol);
               end
                % 进行买卖后，要更新现金变化
                % 面额算的（虚拟）资金
%                 bk.cashFace = bk.cashFace - newp.faceCost;
                
            end
        end
        
        
        function calc_positionNet(obj)
            posL = obj.positionLong;
            posS = obj.positionShort;            
            pos  = obj.positionNet;
            
            % 不做instrumentCode的检验？ 节省时间
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

            % 生成新pos，逐一合并
%             pos = Position;
%             pos.instrumentCode = posL.instrumentCode;            
%             pos.merge_position_netoff( posL );
%             pos.merge_position_netoff( posS );
%             obj.positionNet = pos;
            
            
        end
    end
        
    %% 一系列输出函数
    methods
        
        function print_pendingEntrusts(assetone)
            % 打印挂单的情况，形同： 
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
            % 同时打印盘口和挂单
            % 必须把价格全部拿来， 一起排序
            % 参考QuoteOpt.print_pankou() 和
            % EntrustArray.print_assetone_entrusts()
            % 形同：
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
            

            % 先记入未成交单，第5列1代表我方挂单
            pe = assetone.pendingEntrusts;
            L = pe.latest;
            mat0 = zeros(L, 5);
            for i = 1:L
                e = pe.node(i);
                mat0(i,:) = [e.direction, e.price, 0, e.volume, 1];
            end

            % 再记入盘口挂单, 第5列2代表市场挂单
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
            
                         
            % 合并
            % 列1-买卖；列2-价格；列3-市场挂单；列4-我方挂单；列5-标记（好像没用？）
            mat = [mat0; mat1; mat2];
            
            
            % sort price
            [px, idx] = sort(mat(:,2), 'descend');
            L_old = length(px);
            pxuni = unique(px);
            L = length(pxuni);
            
            % 合并同价格的数量
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
            
            
            %% 打印, 卖单在左，买单在右
            % 1列我方卖单，2列市场卖单，3列价格，4列市场卖单，5列我方买单
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
                if matnew(i, 1) == 1  % 买单
                    fprintf('\t\t%0.4f\t', matnew(i,2) );
                    if matnew(i,3) ~= 0 
                        fprintf('%d', matnew(i,3) ) ;
                    end
                    fprintf('\t');
                    if matnew(i,4) ~= 0
                        fprintf('%d', matnew(i,4) );
                    end
                    fprintf('\n');                   
                        
                elseif matnew(i,1) == -1 %卖单
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
        % 每个assetone单独存一个excel，？ 还是大家共同存一个？
        % 是否共存一个交由fn和appendix来控制，appendix为sheetname 后缀。
            %% 核心：放进positions， entrusts
            obj.positions.toExcel(filename, ['positions',appendix]);            
            obj.finishedEntrusts.toExcel(filename, ['f_entrusts', appendix]);
            
            % 先把pendingEntrust页全部清白，再写
            pending_sheet = ['p_Entrust', appendix];
            xlswrite(filename, {''}, pending_sheet,'A:AH');
            obj.pendingEntrusts.toExcel(filename, pending_sheet);
            
            fprintf('save to: %s, appendix:%s\n', filename, appendix);            
        end
        
        function fromExcel(obj, filename, appendix)
            % 从Excel文件中载入内容
            obj.positions.loadExcel(filename, ['positions',appendix]);
            obj.finishedEntrusts.loadExcel(filename, ['f_entrusts', appendix]);
            obj.pendingEntrusts.loadExcel(filename, ['p_Entrust', appendix]);
        end
        
    end
        
        
end