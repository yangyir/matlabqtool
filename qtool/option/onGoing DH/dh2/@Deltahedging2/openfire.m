function self = openfire(self)
% �����µ�
% һ�ο��� = ����µ�
% һ���µ� = ���ִ�У�deal/withdraw )
% ---------------------
% hm
% cg���޸��µ������߼�
% cg, ΪDeltahedging2��ר�����޸ģ�����counter��book


%% ׼������
counter     = self.counter;
book        = self.book;
marketNo    = self.marketNo;
stockCode   = self.stockCode;

% �����ͷ���
entrustPrice    = self.current_underling_price;
aimHoldingQ     = self.current_delta * self.option_multiplier * self.num_option_lot;
entrustAmount   = aimHoldingQ - self.current_holding_q ;
entrustDirection= getDirection( entrustAmount);
entrustAmount   = round( abs(entrustAmount) / 100 ) * 100;

% ��һ������, (���뷽��+�ʽ����)
entrustValue  = entrustAmount * entrustPrice;
if entrustValue > self.cash && entrustDirection == '1'
    warning('����ʧ�ܣ��˻��ʽ������µ����');
    return;
end

% ��һ����ȯ, (��������+ȯ������)
% entrustValue  = entrustAmount * entrustPrice;
% if entrustAmount > self.enable_amount && entrustDirection == '2'
%     warning('����ʧ�ܣ��������������µ�����');
%     return;
% end

%% ֻҪentrustAmount��Ϊ0���ͷ����µ��� ��Ϊ�з���ѭ����������while
deal_q       = 0;
withdraw_q   = 0;
while entrustAmount >= 100
    
    %  �ж������Ƿ�Ϊ����ʱ�䣬���ǻ�δ���ǽ����۶ϻ���
%     if (datenum(now) < datenum([date,' 09:31:00'])) || ((datenum(now) > datenum([date,' 11:29:00'])) && (datenum(now) < datenum([date,' 13:01:00']) )) ||...
%             (datenum(now) > datenum([date,' 14:59:00']))
%         return
%     end

    %  �۸� /Ϊ�˱�֤�ɽ�����������ʱ���ã�������
    if entrustDirection == '1'
        % �ж�Ϊ���룬�ּۼӣ�������
%         entrustPrice  = self.get_current_price_h5() + 0.01;
        entrustPrice  = self.get_current_price() + 0.01;

    elseif entrustDirection == '2'
        % ���Ϊ�������ּۼ���������
%         entrustPrice  = self.get_current_price_h5() - 0.01;
        entrustPrice  = self.get_current_price() - 0.01;

    end
    
    % debug��
    entrustDirection = '1';
    entrustPrice = 0.1;
    
    % ���һ��entrust
    e = Entrust;
    e.price =  entrustPrice;
    e.volume = entrustAmount;
    e.instrumentCode = stockCode;
    e.direction = entrustDirection;
    e.date = today;     e.date2 = datestr(e.date);
    e.time = now;       e.time2 = datestr(e.time);
    
    % ��һ������
    [errorCode,errorMsg,entrustNo] = counter.entrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount);
    if errorCode == 0
        fprintf('[%d]ί�гɹ�{%s, %d, %0.4f}', entrustNo, entrustDirection, entrustAmount, entrustPrice);
        e.entrustNo = entrustNo;

        % ����ոշ�����һ��������ֱ��close���ɽ����/����+����/������ɣ�
        iter_wait = 1;
        flag_this_entrust_close = 0;
        while ~flag_this_entrust_close
            [errorCode,errorMsg,packet] = counter.queryEntrusts(entrustNo);
            if errorCode < 0
                disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);
                pause(1);
                break;
            else
%                 disp('-------------ί����Ϣ--------------');
%                 PrintPacket2(packet); %��ӡί����Ϣ                
                                
                e.fill_entrust_query_packet_HSO32(packet);

                e.updateTime = now;

                % ����ȫ�ɽ������˳�ѭ��
                deal_q = packet.getInt('deal_amount');
                if deal_q == entrustAmount
                    fprintf('[%d, %d]�ѳɽ���(%d/%d)\n', entrustNo,iter_wait, deal_q, entrustAmount);
%                     e.tradeVolume = deal_q;
                    flag_this_entrust_close = 1; 
                    continue;
                end
                
                % ��������ɣ�Ҳ�˳�ѭ��
                withdraw_q = packet.getInt('withdraw_amount');
                if deal_q + withdraw_q == entrustAmount
                    fprintf('[%d, %d]�ѳ������µ�%d = �ɽ�%d + ����%d\n', entrustNo, iter_wait, entrustAmount, deal_q, withdraw_q);
%                     e.cancelVolume = withdraw_q;
%                     e.cancelTime = now;
                    flag_this_entrust_close = 1; 
                    continue;
                end
                
                % ������ʾ״̬����һ�֣�����
                fprintf('[%d, %d]�ɽ��ʣ�%0.0f%%(%d/%d)\n', entrustNo, iter_wait, 100*deal_q/entrustAmount, deal_q, entrustAmount);         
                
                % �����̫�ã��ͳ���
                if iter_wait > 3
                    [errorCode, errorMsg,cancelNo] = counter.entrustCancel( entrustNo);
                    fprintf('[%d, %d]��������ָ��\n', entrustNo, iter_wait);
                end
                
                iter_wait = iter_wait + 1;
                pause(1);
            end
        end
        
        
        e.fill_entrust_query_packet_HSO32(packet);        
        book.update_finished_entrust(e);

        
    else
        disp(['�µ�ʧ�ܡ�������ϢΪ:',errorMsg]);
        return;
    end
    
    
    % �����ʽ�
    self.update_cash;
    
    % ���³ɽ�����
    self.update_holding_q;
    
    % ������δ��ɵĵ��ӣ�׼��������һ���µ�
    entrustAmount = withdraw_q;
    
    
    
    %���²���¼
    % TODO: ��¼Ӧ��ÿ���غ϶����������������µ�����
    % TODO����ʹ�µ�������¼��ҲҪ�ȵ�����ȫ�˽��
    % TODO����¼��һ��������״̬

%     self.past_delta = self.current_delta;
%     
%     fee = entrustPrice*entrustAmount*self.trading_cost;
%     self.bs_option_price();
%     temp_rec = [now,entrustPrice,entrustAmount,fee,self.theoretical_price];
%     self.trading_record = [self.trading_record;temp_rec];
    
end

end

%% �Ӻ���
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
