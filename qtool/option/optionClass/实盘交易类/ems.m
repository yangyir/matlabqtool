classdef ems
    %EMS 放一些下单的常见方法，供调用
    % 只有Static方法，没有prop
    % ----------------------------
    % cg, 20160211
    % 朱江， 20160621， 增加CTP柜台下单方法
    % 朱江， 20160621， 增加通用柜台下单接口。
    % 朱江， 20170323， 增加海通柜台的支持。
    
    properties
    end
    
    methods(Static = true)
        %% 期权的通用柜台方法
        % 下单
        function [success] = place_optEntrust_and_fill_entrustNo(entrust, counter)
            if isa(counter, 'CounterCTP')
                success = ems.flyweight_place_optEntrust_and_fill_entrustNo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                success = ems.HSO32_place_optEntrust_and_fill_entrustNo(entrust, counter);
            elseif isa(counter, 'CounterXSpeed')
                success = ems.flyweight_place_optEntrust_and_fill_entrustNo(entrust, counter);
            elseif isa(counter, 'CounterHTJG')
                success = ems.flyweight_place_optEntrust_and_fill_entrustNo(entrust, counter);
            else
                warning('下单失败，不支持的柜台类型')
                success = false;
            end
        end
        
        % 查询
        function [success] = query_optEntrust_once_and_fill_dealInfo(entrust, counter)
            if isa(counter, 'CounterCTP')
                success = ems.flyweight_query_optEntrust_once_and_fill_dealInfo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                success = ems.HSO32_query_optEntrust_once_and_fill_dealInfo(entrust, counter);
            elseif isa(counter, 'CounterXSpeed')
                success = ems.flyweight_query_optEntrust_once_and_fill_dealInfo(entrust, counter);
            elseif isa(counter, 'CounterHTJG')
                success = ems.flyweight_query_optEntrust_once_and_fill_dealInfo(entrust, counter);
            else
                warning('查询失败，不支持的柜台类型')
                success = false;
            end

        end
        % 撤单
        function [success] = cancel_optEntrust_and_fill_cancelNo(entrust, counter)
            if isa(counter, 'CounterCTP')
                success = ems.flyweight_cancel_optEntrust_and_fill_cancelNo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                success = ems.HSO32_cancel_optEntrust_and_fill_cancelNo(entrust, counter);
            elseif isa(counter, 'CounterXSpeed')
                success = ems.flyweight_cancel_optEntrust_and_fill_cancelNo(entrust, counter);
            elseif isa(counter, 'CounterHTJG')
                success = ems.flyweight_cancel_optEntrust_and_fill_cancelNo(entrust, counter);
            else
                warning('撤单失败，不支持的柜台类型')
                success = false;
            end
        end
        
        %% ETF的通用柜台方法
        % 下单
        function [success] = place_entrust_and_fill_entrustNo(entrust, counter)
            if isa(counter, 'CounterCTP')
                [success] = ems.CTP_place_optEntrust_and_fill_entrustNo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                [success] = ems.HSO32_place_entrust_and_fill_entrustNo(entrust, counter);
            else
                warning('下单失败，不支持的柜台类型')
                success = false;
            end
        end
        
        % 查询
        function [success] = query_entrust_once_and_fill_dealInfo(entrust, counter)
            if isa(counter, 'CounterCTP')
                [success] = ems.CTP_query_optEntrust_once_and_fill_dealInfo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                [success] = ems.HSO32_query_entrust_once_and_fill_dealInfo(entrust, counter);
            else
                warning('查询失败，不支持的柜台类型')
                success = false;
            end
        end
        
        % 撤单
        function [success] = cancel_entrust_and_fill_cancelNo(entrust, counter)
            if isa(counter, 'CounterCTP')
                [success] = ems.CTP_cancel_optEntrust_and_fill_cancelNo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                [success] = ems.HSO32_cancel_entrust_and_fill_cancelNo(entrust, counter);
            else
                warning('撤单失败，不支持的柜台类型')
                success = false;
            end
        end
        
        %% 期权用：下单
        function [success] = HSO32_place_optEntrust_and_fill_entrustNo(entrust, counterHSO32)
            % 下单，如成功，填入entrustNo
            
            success = 0;
            
            % 看数量是否为0，若是，直接退出
            if entrust.volume == 0
                warning('下单失败：数量为0');
                return
            end
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('下单失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('下单失败：柜台未登陆');
                return;
            end
            
            % 特殊处理一下direction和kp， HSO32里用 '1' , '2'
            d   = entrust.get_CounterHSO32_direction;
            kp  = entrust.get_CounterHSO32_offset;
            
            % 发一个订单，如成功，记录
            [errorCode,errorMsg,entrustNo] = counterHSO32.optPlaceEntrust( ...
                entrust.marketNo, ...
                entrust.instrumentCode, ...
                d, ...
                kp, ...
                entrust.price, ...
                entrust.volume);
            
            if errorCode == 0
                fprintf('[%d]委托成功{%s, %s, %d, %0.4f}\n', entrustNo, d, kp, entrust.volume, entrust.price);
                success = 1;
                entrust.entrustNo = entrustNo;
                entrust.entrustStatus = 2;
                entrust.date    = today;
                entrust.time    = now;
                entrust.is_entrust_closed;
            else
                disp(['下单失败。错误信息为:',errorMsg]);
                return;
            end
            
        end
        
        function [success] = flyweight_place_optEntrust_and_fill_entrustNo(entrust, counter)
            success = counter.placeEntrust(entrust);
        end
        
        function [success] = CTP_place_optEntrust_and_fill_entrustNo(entrust, counterCTP)
                success = counterCTP.placeEntrust(entrust);
        end

        function [success] = XSpeed_place_optEntrust_and_fill_entrustNo(entrust, counterXSpeed)
            success = counterXSpeed.placeEntrust(entrust);
        end
                
         %% 期权用：查询
        function [success] = HSO32_query_optEntrust_once_and_fill_dealInfo(entrust, counterHSO32)
            % 发出一次查询，并把结果填入entrust中，使用O32柜台
            success = 0;
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('查询失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('查询失败：柜台未登陆');
                return;
            end
            
            eNo =  entrust.entrustNo;
            if isempty(eNo)
                warning('订单号entrustNo不存在');
                return;
            end            
            if isnan(eNo)
                warning('订单号entrustNo不存在');
                return;
            end
            
            try                
                [errorCode,errorMsg,packet] = counterHSO32.queryOptEntrusts(eNo);
                if errorCode < 0
                    disp(['查委托失败。错误信息为:',errorMsg]);
                    return;
                else
                    %                 disp('-------------委托信息--------------');
                    %                 PrintPacket2(packet); %打印委托信息
                    
                    entrust.fill_entrust_query_packet_HSO32(packet);
                    entrust.entrustStatus = entrust.entrustStatus + 1;
                    success = 1;
                end
                
            catch
               disp('查询失败'); 
                
            end
        end
        
        function [success] = flyweight_query_optEntrust_once_and_fill_dealInfo(entrust, counter)
            success = counter.queryEntrust(entrust);
            if success
                entrust.entrustStatus = entrust.entrustStatus + 1;
            end            
        end
        
        function [success] = CTP_query_optEntrust_once_and_fill_dealInfo(entrust, counterCTP)
            success = counterCTP.queryEntrust(entrust);
            if success
                entrust.entrustStatus = entrust.entrustStatus + 1;
            end
        end

        function [success] = XSpeed_query_optEntrust_once_and_fill_dealInfo(entrust, counterXSpeed)
            success = counterXSpeed.queryEntrust(entrust);
            if success
                entrust.entrustStatus = entrust.entrustStatus + 1;
            end
        end
        
          %% 期权用：撤单
        function [success] = HSO32_cancel_optEntrust_and_fill_cancelNo(entrust, counterHSO32)
            % 撤单，如成功，填写cancelNo
            
            success = 0;
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('撤单失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('撤单失败：柜台未登陆');
                return;
            end
            
            eNo =  entrust.entrustNo;
            if isempty(eNo)
                warning('订单号entrustNo不存在');
                return;
            end            
            if isnan(eNo)
                warning('订单号entrustNo不存在');
                return;
            end
            
            [errorCode, errorMsg,cancelNo] = counterHSO32.optEntrustCancel( eNo);
            if errorCode ~= 0
                disp(['撤单失败。错误信息为:',errorMsg]);
                return;
            else                
                entrust.cancelNo = cancelNo;
                entrust.entrustStatus = entrust.entrustStatus + 1;
                success = 1;                
            end       
            
        end
        
        function [success] = flyweight_cancel_optEntrust_and_fill_cancelNo(entrust, counter)
            success = counter.withdrawEntrust(entrust);
            if success
                entrust.entrustStatus = entrust.entrustStatus + 1;
            else
                disp('撤单失败');
                return;
            end
        end
        
        function [success] = CTP_cancel_optEntrust_and_fill_cancelNo(entrust, counterCTP)
            success = counterCTP.withdrawEntrust(entrust);
            if success
                entrust.entrustStatus = entrust.entrustStatus + 1;
            else
                disp('撤单失败');
                return;
            end
        end

        function [success] = XSpeed_cancel_optEntrust_and_fill_cancelNo(entrust, counterXSpeed)
            success = counterXSpeed.withdrawEntrust(entrust);
            if success
                entrust.entrustStatus = entrust.entrustStatus + 1;
            else
                disp('撤单失败');
                return;
            end
        end
        
        
        %% 股票下单方法
        function [success] = HSO32_place_entrust_and_fill_entrustNo(entrust, counterHSO32)
            % 下单，如成功，填入entrustNo
            
            success = 0;
            
            % 看数量是否为0，若是，直接退出
            if entrust.volume == 0
                warning('下单失败：数量为0');
                return
            end
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('下单失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('下单失败：柜台未登陆');
                return;
            end
            
            % 特殊处理一下direction和kp， HSO32里用 '1' , '2'
            d = entrust.get_CounterHSO32_direction;
%             kp = entrust.get_CounterHSO32_offset;
            
            % 发一个订单
            [errorCode,errorMsg,entrustNo] = counterHSO32.entrust( ...
                entrust.marketNo, ...
                entrust.instrumentCode, ...
                d, ...
                entrust.price, ...
                entrust.volume);
            
            if errorCode == 0
                fprintf('[%d]委托成功{%s, %d, %0.4f}\n', entrustNo, d, entrust.volume, entrust.price);
                success = 1;
                entrust.entrustNo = entrustNo;
                entrust.entrustStatus = 2;
                entrust.is_entrust_closed;
            else
                disp(['下单失败。错误信息为:',errorMsg]);
                return;
            end
            
        end
        
        
        %% 股票查询方法
        function [success] = HSO32_query_entrust_once_and_fill_dealInfo(entrust, counterHSO32)
            % 发出一次查询，并把结果填入entrust中，使用O32柜台
            
            success = 0;
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('查询失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('查询失败：柜台未登陆');
                return;
            end
            
            
            [errorCode,errorMsg,packet] = counterHSO32.queryEntrusts(entrust.entrustNo);
            if errorCode ~= 0
                disp(['查委托失败。错误信息为:',errorMsg]);
%                 pause(1);
                return;
            else
%                 disp('-------------委托信息--------------');
%                 PrintPacket2(packet); %打印委托信息
                
                entrust.fill_entrust_query_packet_HSO32(packet);
                entrust.entrustStatus = entrust.entrustStatus + 1;
                success = 1;
                
            end            
            
        end
        
        %% 股票撤单方法
        function [success] = HSO32_cancel_entrust_and_fill_cancelNo(entrust, counterHSO32)
            % 撤单，如成功，填写cancelNo
            
            success = 0;
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('撤单失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('撤单失败：柜台未登陆');
                return;
            end
            
            [errorCode, errorMsg,cancelNo] = counterHSO32.entrustCancel( entrust.entrustNo);
            if errorCode ~= 0
                disp(['撤单失败。错误信息为:',errorMsg]);
                return;
            else                
                entrust.cancelNo = cancelNo;
                entrust.entrustStatus = entrust.entrustStatus + 1;
                success = 1;                
            end       
            
        end
        
        %% O32期货方法
        % 下单
        function [success] = HSO32_place_futEntrust_and_fill_entrustNo(entrust, counterHSO32)
            % 下单，如成功，填入entrustNo
            success = 0;
            
            % 看数量是否为0，若是，直接退出
            if entrust.volume == 0
                warning('下单失败：数量为0');
                return
            end
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('下单失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('下单失败：柜台未登陆');
                return;
            end
            
            % 特殊处理一下direction和kp， HSO32里用 '1' , '2'
            d   = entrust.get_CounterHSO32_direction;
            kp  = entrust.get_CounterHSO32_offset;
            
            % 发一个订单，如成功，记录
            [errorCode,errorMsg,entrustNo] = counterHSO32.futPlaceEntrust( ...
                entrust.marketNo, ...
                entrust.instrumentCode, ...
                d, ...
                kp, ...
                entrust.price, ...
                entrust.volume);
            
            if errorCode == 0
                fprintf('[%d]委托成功{%s, %s, %d, %0.4f}\n', entrustNo, d, kp, entrust.volume, entrust.price);
                success = 1;
                entrust.entrustNo = entrustNo;
                entrust.entrustStatus = 2;
                entrust.date    = today;
                entrust.time    = now;
                entrust.is_entrust_closed;
            else
                disp(['下单失败。错误信息为:',errorMsg]);
                return;
            end
        end
        
        % 查询
        function [success] = HSO32_query_futEntrust_once_and_fill_dealInfo(entrust, counterHSO32)
            % 发出一次查询，并把结果填入entrust中，使用O32柜台
            success = 0;
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('查询失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('查询失败：柜台未登陆');
                return;
            end
            
            eNo =  entrust.entrustNo;
            if isempty(eNo)
                warning('订单号entrustNo不存在');
                return;
            end            
            if isnan(eNo)
                warning('订单号entrustNo不存在');
                return;
            end
            
            try                
                [errorCode,errorMsg,packet] = counterHSO32.queryFutEntrusts(eNo);
                if errorCode < 0
                    disp(['查委托失败。错误信息为:',errorMsg]);
                    return;
                else
                    %                 disp('-------------委托信息--------------');
                    %                 PrintPacket2(packet); %打印委托信息
                    entrust.fill_entrust_query_packet_HSO32(packet);
                    entrust.entrustStatus = entrust.entrustStatus + 1;
                    success = 1;
                end
                
            catch
               disp('查询失败'); 
            end
        end
        
        % 撤单
        function [success] = HSO32_cancel_futEntrust_and_fill_cancelNo(entrust, counterHSO32)
            % 撤单，如成功，填写cancelNo
            success = 0;
            
            % 看counter是否是HSO32，是否连接
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('撤单失败：柜台须为CounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('撤单失败：柜台未登陆');
                return;
            end
            
            eNo =  entrust.entrustNo;
            if isempty(eNo)
                warning('订单号entrustNo不存在');
                return;
            end            
            if isnan(eNo)
                warning('订单号entrustNo不存在');
                return;
            end
            
            [errorCode, errorMsg,cancelNo] = counterHSO32.futEntrustCancel( eNo);
            if errorCode ~= 0
                disp(['撤单失败。错误信息为:',errorMsg]);
                return;
            else                
                entrust.cancelNo = cancelNo;
                entrust.entrustStatus = entrust.entrustStatus + 1;
                success = 1;                
            end       
            
        end
    end
    
    
    
    
end