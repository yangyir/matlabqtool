classdef ems
    %EMS ��һЩ�µ��ĳ���������������
    % ֻ��Static������û��prop
    % ----------------------------
    % cg, 20160211
    % �콭�� 20160621�� ����CTP��̨�µ�����
    % �콭�� 20160621�� ����ͨ�ù�̨�µ��ӿڡ�
    % �콭�� 20170323�� ���Ӻ�ͨ��̨��֧�֡�
    
    properties
    end
    
    methods(Static = true)
        %% ��Ȩ��ͨ�ù�̨����
        % �µ�
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
                warning('�µ�ʧ�ܣ���֧�ֵĹ�̨����')
                success = false;
            end
        end
        
        % ��ѯ
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
                warning('��ѯʧ�ܣ���֧�ֵĹ�̨����')
                success = false;
            end

        end
        % ����
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
                warning('����ʧ�ܣ���֧�ֵĹ�̨����')
                success = false;
            end
        end
        
        %% ETF��ͨ�ù�̨����
        % �µ�
        function [success] = place_entrust_and_fill_entrustNo(entrust, counter)
            if isa(counter, 'CounterCTP')
                [success] = ems.CTP_place_optEntrust_and_fill_entrustNo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                [success] = ems.HSO32_place_entrust_and_fill_entrustNo(entrust, counter);
            else
                warning('�µ�ʧ�ܣ���֧�ֵĹ�̨����')
                success = false;
            end
        end
        
        % ��ѯ
        function [success] = query_entrust_once_and_fill_dealInfo(entrust, counter)
            if isa(counter, 'CounterCTP')
                [success] = ems.CTP_query_optEntrust_once_and_fill_dealInfo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                [success] = ems.HSO32_query_entrust_once_and_fill_dealInfo(entrust, counter);
            else
                warning('��ѯʧ�ܣ���֧�ֵĹ�̨����')
                success = false;
            end
        end
        
        % ����
        function [success] = cancel_entrust_and_fill_cancelNo(entrust, counter)
            if isa(counter, 'CounterCTP')
                [success] = ems.CTP_cancel_optEntrust_and_fill_cancelNo(entrust, counter);
            elseif isa(counter, 'CounterHSO32')
                [success] = ems.HSO32_cancel_entrust_and_fill_cancelNo(entrust, counter);
            else
                warning('����ʧ�ܣ���֧�ֵĹ�̨����')
                success = false;
            end
        end
        
        %% ��Ȩ�ã��µ�
        function [success] = HSO32_place_optEntrust_and_fill_entrustNo(entrust, counterHSO32)
            % �µ�����ɹ�������entrustNo
            
            success = 0;
            
            % �������Ƿ�Ϊ0�����ǣ�ֱ���˳�
            if entrust.volume == 0
                warning('�µ�ʧ�ܣ�����Ϊ0');
                return
            end
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('�µ�ʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('�µ�ʧ�ܣ���̨δ��½');
                return;
            end
            
            % ���⴦��һ��direction��kp�� HSO32���� '1' , '2'
            d   = entrust.get_CounterHSO32_direction;
            kp  = entrust.get_CounterHSO32_offset;
            
            % ��һ����������ɹ�����¼
            [errorCode,errorMsg,entrustNo] = counterHSO32.optPlaceEntrust( ...
                entrust.marketNo, ...
                entrust.instrumentCode, ...
                d, ...
                kp, ...
                entrust.price, ...
                entrust.volume);
            
            if errorCode == 0
                fprintf('[%d]ί�гɹ�{%s, %s, %d, %0.4f}\n', entrustNo, d, kp, entrust.volume, entrust.price);
                success = 1;
                entrust.entrustNo = entrustNo;
                entrust.entrustStatus = 2;
                entrust.date    = today;
                entrust.time    = now;
                entrust.is_entrust_closed;
            else
                disp(['�µ�ʧ�ܡ�������ϢΪ:',errorMsg]);
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
                
         %% ��Ȩ�ã���ѯ
        function [success] = HSO32_query_optEntrust_once_and_fill_dealInfo(entrust, counterHSO32)
            % ����һ�β�ѯ�����ѽ������entrust�У�ʹ��O32��̨
            success = 0;
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('��ѯʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('��ѯʧ�ܣ���̨δ��½');
                return;
            end
            
            eNo =  entrust.entrustNo;
            if isempty(eNo)
                warning('������entrustNo������');
                return;
            end            
            if isnan(eNo)
                warning('������entrustNo������');
                return;
            end
            
            try                
                [errorCode,errorMsg,packet] = counterHSO32.queryOptEntrusts(eNo);
                if errorCode < 0
                    disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);
                    return;
                else
                    %                 disp('-------------ί����Ϣ--------------');
                    %                 PrintPacket2(packet); %��ӡί����Ϣ
                    
                    entrust.fill_entrust_query_packet_HSO32(packet);
                    entrust.entrustStatus = entrust.entrustStatus + 1;
                    success = 1;
                end
                
            catch
               disp('��ѯʧ��'); 
                
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
        
          %% ��Ȩ�ã�����
        function [success] = HSO32_cancel_optEntrust_and_fill_cancelNo(entrust, counterHSO32)
            % ��������ɹ�����дcancelNo
            
            success = 0;
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('����ʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('����ʧ�ܣ���̨δ��½');
                return;
            end
            
            eNo =  entrust.entrustNo;
            if isempty(eNo)
                warning('������entrustNo������');
                return;
            end            
            if isnan(eNo)
                warning('������entrustNo������');
                return;
            end
            
            [errorCode, errorMsg,cancelNo] = counterHSO32.optEntrustCancel( eNo);
            if errorCode ~= 0
                disp(['����ʧ�ܡ�������ϢΪ:',errorMsg]);
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
                disp('����ʧ��');
                return;
            end
        end
        
        function [success] = CTP_cancel_optEntrust_and_fill_cancelNo(entrust, counterCTP)
            success = counterCTP.withdrawEntrust(entrust);
            if success
                entrust.entrustStatus = entrust.entrustStatus + 1;
            else
                disp('����ʧ��');
                return;
            end
        end

        function [success] = XSpeed_cancel_optEntrust_and_fill_cancelNo(entrust, counterXSpeed)
            success = counterXSpeed.withdrawEntrust(entrust);
            if success
                entrust.entrustStatus = entrust.entrustStatus + 1;
            else
                disp('����ʧ��');
                return;
            end
        end
        
        
        %% ��Ʊ�µ�����
        function [success] = HSO32_place_entrust_and_fill_entrustNo(entrust, counterHSO32)
            % �µ�����ɹ�������entrustNo
            
            success = 0;
            
            % �������Ƿ�Ϊ0�����ǣ�ֱ���˳�
            if entrust.volume == 0
                warning('�µ�ʧ�ܣ�����Ϊ0');
                return
            end
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('�µ�ʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('�µ�ʧ�ܣ���̨δ��½');
                return;
            end
            
            % ���⴦��һ��direction��kp�� HSO32���� '1' , '2'
            d = entrust.get_CounterHSO32_direction;
%             kp = entrust.get_CounterHSO32_offset;
            
            % ��һ������
            [errorCode,errorMsg,entrustNo] = counterHSO32.entrust( ...
                entrust.marketNo, ...
                entrust.instrumentCode, ...
                d, ...
                entrust.price, ...
                entrust.volume);
            
            if errorCode == 0
                fprintf('[%d]ί�гɹ�{%s, %d, %0.4f}\n', entrustNo, d, entrust.volume, entrust.price);
                success = 1;
                entrust.entrustNo = entrustNo;
                entrust.entrustStatus = 2;
                entrust.is_entrust_closed;
            else
                disp(['�µ�ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            end
            
        end
        
        
        %% ��Ʊ��ѯ����
        function [success] = HSO32_query_entrust_once_and_fill_dealInfo(entrust, counterHSO32)
            % ����һ�β�ѯ�����ѽ������entrust�У�ʹ��O32��̨
            
            success = 0;
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('��ѯʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('��ѯʧ�ܣ���̨δ��½');
                return;
            end
            
            
            [errorCode,errorMsg,packet] = counterHSO32.queryEntrusts(entrust.entrustNo);
            if errorCode ~= 0
                disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);
%                 pause(1);
                return;
            else
%                 disp('-------------ί����Ϣ--------------');
%                 PrintPacket2(packet); %��ӡί����Ϣ
                
                entrust.fill_entrust_query_packet_HSO32(packet);
                entrust.entrustStatus = entrust.entrustStatus + 1;
                success = 1;
                
            end            
            
        end
        
        %% ��Ʊ��������
        function [success] = HSO32_cancel_entrust_and_fill_cancelNo(entrust, counterHSO32)
            % ��������ɹ�����дcancelNo
            
            success = 0;
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('����ʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('����ʧ�ܣ���̨δ��½');
                return;
            end
            
            [errorCode, errorMsg,cancelNo] = counterHSO32.entrustCancel( entrust.entrustNo);
            if errorCode ~= 0
                disp(['����ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else                
                entrust.cancelNo = cancelNo;
                entrust.entrustStatus = entrust.entrustStatus + 1;
                success = 1;                
            end       
            
        end
        
        %% O32�ڻ�����
        % �µ�
        function [success] = HSO32_place_futEntrust_and_fill_entrustNo(entrust, counterHSO32)
            % �µ�����ɹ�������entrustNo
            success = 0;
            
            % �������Ƿ�Ϊ0�����ǣ�ֱ���˳�
            if entrust.volume == 0
                warning('�µ�ʧ�ܣ�����Ϊ0');
                return
            end
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('�µ�ʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('�µ�ʧ�ܣ���̨δ��½');
                return;
            end
            
            % ���⴦��һ��direction��kp�� HSO32���� '1' , '2'
            d   = entrust.get_CounterHSO32_direction;
            kp  = entrust.get_CounterHSO32_offset;
            
            % ��һ����������ɹ�����¼
            [errorCode,errorMsg,entrustNo] = counterHSO32.futPlaceEntrust( ...
                entrust.marketNo, ...
                entrust.instrumentCode, ...
                d, ...
                kp, ...
                entrust.price, ...
                entrust.volume);
            
            if errorCode == 0
                fprintf('[%d]ί�гɹ�{%s, %s, %d, %0.4f}\n', entrustNo, d, kp, entrust.volume, entrust.price);
                success = 1;
                entrust.entrustNo = entrustNo;
                entrust.entrustStatus = 2;
                entrust.date    = today;
                entrust.time    = now;
                entrust.is_entrust_closed;
            else
                disp(['�µ�ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            end
        end
        
        % ��ѯ
        function [success] = HSO32_query_futEntrust_once_and_fill_dealInfo(entrust, counterHSO32)
            % ����һ�β�ѯ�����ѽ������entrust�У�ʹ��O32��̨
            success = 0;
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('��ѯʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('��ѯʧ�ܣ���̨δ��½');
                return;
            end
            
            eNo =  entrust.entrustNo;
            if isempty(eNo)
                warning('������entrustNo������');
                return;
            end            
            if isnan(eNo)
                warning('������entrustNo������');
                return;
            end
            
            try                
                [errorCode,errorMsg,packet] = counterHSO32.queryFutEntrusts(eNo);
                if errorCode < 0
                    disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);
                    return;
                else
                    %                 disp('-------------ί����Ϣ--------------');
                    %                 PrintPacket2(packet); %��ӡί����Ϣ
                    entrust.fill_entrust_query_packet_HSO32(packet);
                    entrust.entrustStatus = entrust.entrustStatus + 1;
                    success = 1;
                end
                
            catch
               disp('��ѯʧ��'); 
            end
        end
        
        % ����
        function [success] = HSO32_cancel_futEntrust_and_fill_cancelNo(entrust, counterHSO32)
            % ��������ɹ�����дcancelNo
            success = 0;
            
            % ��counter�Ƿ���HSO32���Ƿ�����
            if ~isa(counterHSO32, 'CounterHSO32')
                warning('����ʧ�ܣ���̨��ΪCounterHSO32');
                return;
            end
            if counterHSO32.is_Counter_Login == 0
                warning('����ʧ�ܣ���̨δ��½');
                return;
            end
            
            eNo =  entrust.entrustNo;
            if isempty(eNo)
                warning('������entrustNo������');
                return;
            end            
            if isnan(eNo)
                warning('������entrustNo������');
                return;
            end
            
            [errorCode, errorMsg,cancelNo] = counterHSO32.futEntrustCancel( eNo);
            if errorCode ~= 0
                disp(['����ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else                
                entrust.cancelNo = cancelNo;
                entrust.entrustStatus = entrust.entrustStatus + 1;
                success = 1;                
            end       
            
        end
    end
    
    
    
    
end