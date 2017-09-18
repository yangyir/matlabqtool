function self = openfire(self)
% 进行下单
% 一次开火 = 多次下单
% 一个下单 = 多次执行（deal/withdraw )
% ---------------------
% hm
% cg，修改下单撤单逻辑
% cg, 为Deltahedging2类专门做修改，适用counter和book


%% 准备工作
counter     = self.counter;
book        = self.book;
marketNo    = self.marketNo;
stockCode   = self.stockCode;

% 数量和方向
entrustPrice    = self.current_underling_price;
aimHoldingQ     = self.current_delta * self.option_multiplier * self.num_option_lot;
entrustAmount   = aimHoldingQ - self.current_holding_q ;
entrustDirection= getDirection( entrustAmount);
entrustAmount   = round( abs(entrustAmount) / 100 ) * 100;

% 做一次验资, (买入方向+资金充足)
entrustValue  = entrustAmount * entrustPrice;
if entrustValue > self.cash && entrustDirection == '1'
    warning('验资失败：账户资金少于下单金额');
    return;
end

% 做一次验券, (卖出方向+券量充足)
% entrustValue  = entrustAmount * entrustPrice;
% if entrustAmount > self.enable_amount && entrustDirection == '2'
%     warning('验资失败：可卖数量少于下单数量');
%     return;
% end

%% 只要entrustAmount不为0，就反复下单， 因为有反复循环，所以用while
deal_q       = 0;
withdraw_q   = 0;
while entrustAmount >= 100
    
    %  判断现在是否为交易时间，但是还未考虑交易熔断机制
%     if (datenum(now) < datenum([date,' 09:31:00'])) || ((datenum(now) > datenum([date,' 11:29:00'])) && (datenum(now) < datenum([date,' 13:01:00']) )) ||...
%             (datenum(now) > datenum([date,' 14:59:00']))
%         return
%     end

    %  价格 /为了保证成交，买入卖出时都让０．０１
    if entrustDirection == '1'
        % 判断为买入，现价加０．０１
%         entrustPrice  = self.get_current_price_h5() + 0.01;
        entrustPrice  = self.get_current_price() + 0.01;

    elseif entrustDirection == '2'
        % 如果为卖出，现价减０．０１
%         entrustPrice  = self.get_current_price_h5() - 0.01;
        entrustPrice  = self.get_current_price() - 0.01;

    end
    
    % debug用
    entrustDirection = '1';
    entrustPrice = 0.1;
    
    % 填充一笔entrust
    e = Entrust;
    e.price =  entrustPrice;
    e.volume = entrustAmount;
    e.instrumentCode = stockCode;
    e.direction = entrustDirection;
    e.date = today;     e.date2 = datestr(e.date);
    e.time = now;       e.time2 = datestr(e.time);
    
    % 发一个订单
    [errorCode,errorMsg,entrustNo] = counter.entrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount);
    if errorCode == 0
        fprintf('[%d]委托成功{%s, %d, %0.4f}', entrustNo, entrustDirection, entrustAmount, entrustPrice);
        e.entrustNo = entrustNo;

        % 处理刚刚发出的一个订单，直至close（成交完成/部成+撤单/撤单完成）
        iter_wait = 1;
        flag_this_entrust_close = 0;
        while ~flag_this_entrust_close
            [errorCode,errorMsg,packet] = counter.queryEntrusts(entrustNo);
            if errorCode < 0
                disp(['查委托失败。错误信息为:',errorMsg]);
                pause(1);
                break;
            else
%                 disp('-------------委托信息--------------');
%                 PrintPacket2(packet); %打印委托信息                
                                
                e.fill_entrust_query_packet_HSO32(packet);

                e.updateTime = now;

                % 若完全成交，则退出循环
                deal_q = packet.getInt('deal_amount');
                if deal_q == entrustAmount
                    fprintf('[%d, %d]已成交：(%d/%d)\n', entrustNo,iter_wait, deal_q, entrustAmount);
%                     e.tradeVolume = deal_q;
                    flag_this_entrust_close = 1; 
                    continue;
                end
                
                % 若撤单完成，也退出循环
                withdraw_q = packet.getInt('withdraw_amount');
                if deal_q + withdraw_q == entrustAmount
                    fprintf('[%d, %d]已撤单：下单%d = 成交%d + 撤单%d\n', entrustNo, iter_wait, entrustAmount, deal_q, withdraw_q);
%                     e.cancelVolume = withdraw_q;
%                     e.cancelTime = now;
                    flag_this_entrust_close = 1; 
                    continue;
                end
                
                % 否则，显示状态，等一轮，再来
                fprintf('[%d, %d]成交率：%0.0f%%(%d/%d)\n', entrustNo, iter_wait, 100*deal_q/entrustAmount, deal_q, entrustAmount);         
                
                % 如果等太久，就撤单
                if iter_wait > 3
                    [errorCode, errorMsg,cancelNo] = counter.entrustCancel( entrustNo);
                    fprintf('[%d, %d]发出撤单指令\n', entrustNo, iter_wait);
                end
                
                iter_wait = iter_wait + 1;
                pause(1);
            end
        end
        
        
        e.fill_entrust_query_packet_HSO32(packet);        
        book.update_finished_entrust(e);

        
    else
        disp(['下单失败。错误信息为:',errorMsg]);
        return;
    end
    
    
    % 更新资金
    self.update_cash;
    
    % 更新成交数量
    self.update_holding_q;
    
    % 更新仍未完成的单子，准备进行下一次下单
    entrustAmount = withdraw_q;
    
    
    
    %更新并记录
    % TODO: 记录应该每个回合都做，而不仅仅是下单才做
    % TODO：即使下单才做记录，也要等单子完全了结后
    % TODO：记录这一个订单的状态

%     self.past_delta = self.current_delta;
%     
%     fee = entrustPrice*entrustAmount*self.trading_cost;
%     self.bs_option_price();
%     temp_rec = [now,entrustPrice,entrustAmount,fee,self.theoretical_price];
%     self.trading_record = [self.trading_record;temp_rec];
    
end

end

%% 子函数
function [entrustDirection] = getDirection( entrustAmount)
if entrustAmount > 0
    entrustDirection = '1';
elseif entrustAmount < 0
    entrustDirection = '2';
else
    entrustDirection = '0';
end

end


function [] = record_entrust(self, entrustNo, entrustDirection, entrustAmount, entrustPrice )
fee = entrustPrice*entrustAmount*self.trading_cost;
self.bs_option_price();
temp_rec = [now,entrustPrice,entrustAmount,fee,self.theoretical_price, self.current_delta, self.current_underling_price, self.current_holding_q];
self.trading_record = [self.trading_record;temp_rec];
end
