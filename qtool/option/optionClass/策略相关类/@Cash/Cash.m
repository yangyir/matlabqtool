classdef Cash < handle
    % Cash 类将账户中钱相关的属性归集到一个类中管理
    % 考虑在Cash类中提供对柜台的灵活性，从不同的柜台源载入信息
    properties
        stockAvailableCashT0@double = 0;
        stockAvaliableCashT1@double = 0;
        stockCurrencyCash@double = 0;
        futAvailableCash@double = 0;
        futOccupiedMargin@double = 0;
        optAvailableCash@double = 0;
        optOccupiedMargin@double = 0;
    end
    
    methods       
        function [rate] = OptMarginRate(obj)
            %function [rate] = OptMarginRate(obj)
            if obj.optAvailableCash ~= 0
                rate = obj.optOccupiedMargin / (obj.optAvailableCash + obj.optOccupiedMargin);
            else
                rate = 0;
            end
        end
        
        function [fut_rate] = FutMarginRate(obj)
            %function [fut_rate] = FutMarginRate(obj)
            if obj.futOccupiedMargin ~= 0
                fut_rate = obj.futOccupiedMargin / (obj.optOccupiedMargin + obj.futAvailableCash);
            else
                fut_rate = 0;
            end
        end

        function [obj] = loadStkCash(obj, counter)
            %function [] = loadStkCash(obj, counter)
            %适配所有可支持的柜台类型
            switch (class(counter))
                case 'CounterHSO32'
                    obj.loadStkCashFromHSO32(counter);
                case 'CounterCTP'
                    obj.loadStkCashFromCTP(counter);
                case 'CounterXSpeed'
                    obj.loadStkCashFromXSpeed(counter);
                otherwise
                    warning(['不支持的柜台类型 : ', class(counter)]);
            end
        end        
        
        
        function [obj] = loadFutCash(obj, counter)
            %function [] = loadFutCash(obj, counter)
            %适配所有可支持的柜台类型
            switch (class(counter))
                case 'CounterHSO32'
                    obj.loadFutCashFromHSO32(counter);
                case 'CounterCTP'
                    obj.loadFutCashFromCTP(counter);
                case 'CounterXSpeed'
                    obj.loadFutCashFromXSpeed(counter);
                otherwise
                    warning(['不支持的柜台类型 : ', class(counter)]);
            end
        end        
        
        
        function [obj] = loadOptCash(obj, counter)
            %function [] = loadOptCash(obj, counter)
            %适配所有可支持的柜台类型
            switch (class(counter))
                case 'CounterHSO32'
                    obj.loadOptCashFromHSO32(counter);
                case 'CounterCTP'
                    obj.loadOptCashFromCTP(counter);
                case 'CounterXSpeed'
                    obj.loadOptCashFromXSpeed(counter);
                otherwise
                    warning(['不支持的柜台类型 : ', class(counter)]);
            end
        end        
    end
    
    methods 
        function [obj] = loadStkCashFromHSO32(obj, counter_hso32)
            %function [] = loadCashFromHSO32(obj, counter_hso32)
            if(~counter_hso32.is_Counter_Login)
                warning('柜台未登录');
            end
            obj.HSLoadStkCash(counter_hso32);
        end
        
        function [obj] = loadFutCashFromHSO32(obj, counter_hso32)
            %function [] = loadCashFromHSO32(obj, counter_hso32)
            if(~counter_hso32.is_Counter_Login)
                warning('柜台未登录');
            end
            obj.HSLoadFutCash(counter_hso32);
        end
        
        function [obj] = loadOptCashFromHSO32(obj, counter_hso32)
            %function [] = loadCashFromHSO32(obj, counter_hso32)
            if(~counter_hso32.is_Counter_Login)
                warning('柜台未登录');
            end
            obj.HSLoadOptCash(counter_hso32);
        end
        
        function [obj] = loadCashFromCTP(obj, counter_ctp)
            %function [] = loadCashFromCTP(obj, counter_ctp)
            if(~counter_ctp.is_Counter_Login)
                warning('柜台未登录');
            end
        end
        
        function [obj] = loadCashFromXSpeed(obj, counter_xspeed)
            %function [] = loadCashFromXSpeed(obj, counter_xspeed)
            if(~counter_xspeed.is_Counter_Login)
                warning('柜台未登录');
            end
        end
        
        function [obj] = HSLoadOptCash(obj, counter_hso32)
            [errorCode, errorMsg, packet] = counter_hso32.queryOptMargin;
            if errorCode == 0
                % PrintPacket2(packet2)
                % [0]account_code	[0]2016
                % [1]asset_no	[1]82002004
                % [2]occupy_deposit_balance	[2]37358.000000
                % [3]enable_deposit_balance	[3]203926098.400000
                obj.optOccupiedMargin = packet.getDouble('occupy_deposit_balance');
                obj.optAvailableCash = packet.getDouble('enable_deposit_balance');
            else
                warning(errorMsg);
                obj.optOccupiedMargin = 0;
                obj.optAvailableCash = 0;
            end
        end
        
        function [obj] = HSLoadStkCash(obj, counter_hso32)
            [errorCode, errorMsg, packet] = counter_hso32.queryAccount;
            if errorCode == 0
                % PrintPacket2(packet2)
                % [0]account_code	[0]2016
                % [1]asset_no	[1]82002004
                % [2]enable_balance_t0	[2]203963456.400000
                % [3]enable_balance_t1	[3]203963456.400000
                % [4]current_balance	[4]204019585.200000
                obj.stockAvailableCashT0 = packet.getDouble('enable_balance_t0');
                obj.stockAvaliableCashT1 = packet.getDouble('enable_balance_t1');
                obj.stockCurrencyCash = packet.getDouble('current_balance');
            else
                warning(errorMsg);
                obj.stockAvailableCashT0 = 0;
                obj.stockAvaliableCashT1 = 0;
                obj.stockCurrencyCash = 0;
            end
        end
        
        function [obj] = HSLoadFutCash(obj, counter_hso32)
            [errorCode, errorMsg, packet] = counter_hso32.queryFutMargin;
            % [0]account_code	[0]2016
            % [1]asset_no	[1]82002004
            % [2]occupy_deposit_balance	[2]0.000000
            % [3]enable_deposit_balance	[3]0.000000
            % [4]futu_deposit_balance	[4]0.000000
            % [5]futu_temp_occupy_deposit	[5]0.000000
            if errorCode == 0
                obj.futOccupiedMargin = packet.getDouble('occupy_deposit_balance');
                obj.futAvailableCash = packet.getDouble('enable_deposit_balance');
            else
                warning(errorMsg);
                obj.futOccupiedMargin = 0;
                obj.futAvailableCash = 0;
            end
        end
    end
end