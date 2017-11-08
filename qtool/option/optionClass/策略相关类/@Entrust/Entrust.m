classdef Entrust < handle
    %ENTRUST �µ���
    %   �˴���ʾ��ϸ˵��
    % -----------------------------
    % �̸գ�20160216,
    % �̸գ�20160217��Լ��������code������char���Ա������
    % �̸գ�20160401������instrumentName��Ϊ�˿��ŷ��㣬�޸�println
    % �콭��20160621��ΪCTP����������entrustId �� assetType
    % �콭��20161221��Ϊ�ڻ���Լ��������multiplier��
    % �콭��20170607, �����µ�ʱ������ѹ�ʱ������ɽ�ʱ���
    % �콭��20170607��������ϵ�ID��
    % �콭��20170608������deals��
    % �̸գ�20170708��������rankBE, rankWE 
    % �ο���20170912��������deal_to_position��ƽ��feeCostΪ����bug
    % �̸գ�20171020��println()���뿪ƽ����Ϣ
    
    properties
        % ������Ϣ 
        marketNo = '1';             %��@char, setter���ƣ��г���ţ�'1'�Ͻ�����'2'����� ���Ǳ���
        instrumentCode = '000000';  % ��@char,setter���ƣ���Լ����,
        instrumentName = '����';    % Ϊ�˷���
        instrumentNo;   % ��Լ���
        volume;         % ������ TODO: ��Ϊ��ֵ��( ����ί�е����� )
        price;          % �۸�
        direction;      % ��@double��setter���ƣ���������buy = 1; sell = -1;
        offsetFlag = 1; % ��@double��setter���ƣ���ƽ����, open = 1; close = -1;
        closetodayFlag = 0; %% ��@double��setter���ƣ�������ר�ã�ƽ��ƽ��, ƽ�� = 1; ƽ�� = 2��Ĭ�ϲ�����Ϊ0;
                
        entrustNo;            % ί�б��
        entrustType;          % ί������, market, limit, stop, fok etc.
        entrustStatus = 0;    % ί��״̬, 0��ʾ�¶���
                              % 1��ʾ����˵��µ���TODO�������Ч����
                              % 2��ʾ���µ������entrsutNo��
                              % 3��4��...δ�˽ᣬÿ��һ�μ�1
                              % -1��ʾ�˽��ˡ�
        %ΪCTPʹ������������
        entrustId = 0;        %��̨�ڲ�ί�б��
        assetType = 'Option'; %������ͣ�'ETF'/'Option'/'Future'
        
        %����
        date@double = today;  % ���ڣ� matlab ��ʽ�� ��735773
        date2;                % ���ڣ�double��char������'20140623'
        time@double = now;    % ʱ�䣬matlab��ʽ����735773.324
        time2;                % double��char�� ʱ�� 'HHMMSSFFF'
        
        % �ɽ�
        dealVolume@double = 0; % �ɽ���Ŀ
        dealAmount@double = 0; % �ɽ����
        dealPrice;             % �ɽ�����
        dealNum@double = 0;    % �ɽ�����


        % ������Ϣ
        cancelVolume@double = 0;   % ��������
        cancelTime;                % ����ʱ��
        cancelNo;                  % ������
        
        recvTime;   % ��̨ϵͳ����ʱ��
        updateTime; % ����޸�ʱ��
        
        
        % �����Ϣ
        tick;       % ʱ���Ӧ��tick��
        strategyNo; % ���Ա�ţ�����
        orderRef;   % �������
        combNo;     % ��ϱ��
        roundNo;    % �غϱ��
        
        % ������Ϣ
        fee@double = 0; % ������
        % ��֤��
        
        % ��Լ����
        multiplier = 10000;
        
        % �ҵ����򣨹���ֵ���� ���ڸ�Ƶ����
        rankBE = -1;  % best estimation
        rankWE = -1;  % worst estimation
    end
    
    properties(SetAccess = 'private', Hidden = true)
        isCompleted;
    end
    
    properties
        % ����ί�У��ҳ����ɽ�ʱ���
        issue_time_;
        accept_time_;
        complete_time_;
        
        % ������ϵ�ID, Ĭ�ϼ򵥵��˴�ֵΪ-1;
        combi_no_ = -1;
        
        % ����trades�����ڷ��������С�
        deals_@DealArray;
    end

    methods
        % ����������constructor�� copy constructor�� display
        [newobj] = getCopy(obj);
        
        % ǿ������ת��������code����char
        function [obj] = set.instrumentCode(obj, vin)
            % ǿ������ת��������code����char
            if iscell(vin), vin = vin{1}; end
            cl = class(vin);                        
            switch cl
                case {'double' }
                    disp('ǿ������ת����codeӦΪchar');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('��ֵʧ�ܣ�codeӦΪchar');
                    return;
            end
            obj.instrumentCode = vout;
        end
        
        
        function [obj] = set.direction(obj, vin)     
            % direction�Ĵ���ȽϷ�������ͬ�ĵط���ز�ͬ
            % HSO32���1���� ��2����(����1����-1)
            if isa(vin, 'char')
                switch vin
                    case {'1', 'buy', 'b'}                
                        vout = 1;
                    case {'2', 'sell', 's'}
                        vout = -1;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else  % ���������룬��nan
                vout = 0;
            end                
            obj.direction = vout;            
        end
        
        function [obj] = set.entrustNo(obj, vin)
            if isa(vin, 'char')
                obj.entrustNo = str2double(vin);
            elseif isa(vin, 'double')
                obj.entrustNo = vin;
            end
        end
        
        function [obj] = set.offsetFlag(obj, vin)
            % ��ƽ�ֵĹ�ز�ͬ��Entrust��ȡ��ֵ -1�� 1
            % HSO32�����'1'�� ƽ��'2'(1�ǿ���-1��ƽ��)
            if isa(vin, 'char')
                switch vin
                    case {'1', 'open', 'o'}  % ����
                        vout = 1;
                    case {'2', 'close', 'c'}  % ƽ��
                        vout = -1;
                    otherwise
                        vout = 0;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else
                vout = 0;
            end
            obj.offsetFlag = vout;
        end    

        function [obj] = set.closetodayFlag(obj, vin)
            % ƽ��ƽ��Ĺ�ز�ͬ��Entrust��ȡ��ֵ ƽ��1�� ƽ��2
            if isa(vin, 'char')
                switch vin
                    case {'1', 'today', 't'}  % ƽ��
                        vout = 1;
                    case {'2', 'yesterday', 'y'}  % ƽ��
                        vout = 2;
                    otherwise
                        vout = 0;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else
                vout = 0;
            end
            obj.closetodayFlag = vout;
        end
        
        % volume�Ǹ�(��Ӧ����ί�е�����)
        function [obj] = set.volume(obj, value)
            % volume�Ǹ�
            if isnan(value), value = 0; end
            if isa(value, 'double') && (value>=0)
                obj.volume = value;
            else
                obj.volume = value;
                warning('entrust.volume��ֵʧ�ܣ���Ϊ�Ǹ�����');
            end
        end
        
        % marketNo��char
        function [obj] = set.marketNo(obj, vin)
            % marketNo��char            
            if isa(vin, 'cell'), vin = vin{1}; end
            cl = class(vin);
            switch cl
                case {'double'}
                     vout = num2str(vin);
                case {'char'}
                    vout = vin;
                otherwise
                    warning('��ֵʧ�ܣ�entrust.marketNo��Ҫ��char');
                    return
            end
            obj.marketNo = vout;
        end
        
        function [obj] = set.assetType(obj, vin)
            if isa(vin, 'cell'), vin = vin{1}; end
            if isa(vin, 'char')
                obj.assetType = vin;
            else
                warning('��ֵʧ�ܣ� entrust.assetType ����Ϊchar��ETF Option Future');
            end
            switch obj.assetType
                case 'ETF'
                    obj.multiplier = 100;
                case 'Option'
                    obj.multiplier = 10000;
            end
        end
        
        function [obj] = set.multiplier(obj, value)
            if isa(value, 'double')
                obj.multiplier = value;
            else
                warning('��ֵʧ�ܣ�entrust.multiplier ����Ϊdouble');
            end
        end
        
        % ί�е��Ĵ�ӡ(����Ҫ�Լ�����һ����ӡ������)
        function [txt] = println(obj)
            txt = sprintf('[%d:%s,%s,%d,%d] v=%d=%d+%d, px=(%0.4f, %0.4f, %d)\n', ...
                obj.entrustNo, obj.instrumentName, obj.instrumentCode, obj.direction, obj.offsetFlag, ...
                obj.volume, obj.dealVolume, obj.cancelVolume, ...
                obj.price, obj.dealPrice, obj.dealAmount);
            if nargout == 0 
                disp(txt);
            end
        end 
        
        function [deal_summary_struct] = deal_summary(obj)
            % function [evaluate_struct] = evaluate(obj)
            % ί����ص����ۣ����㻬ʱ
            % TODO: evaluate Entrust implementation.
            if obj.deals_.isempty
                deal_summary_struct = [];
                % ���㣺���޳ɽ���¼������£��ɽ����� - ί�м�
                % ��ʱ���ɽ�ʱ�� - �ɽ�
            else
                L = obj.deals_.count;
                % ����: �ɽ����� - ���ųɽ���
                
                % ��ʱ��
            end
        end
        
        function [valid] = is_valid(obj)
            valid = true;
            if strcmp(obj.instrumentCode, '000000')
                valid = false;
            end
        end
        
        function [iscombi] = is_combi(obj)
            iscombi = (obj.combi_no_ ~= -1);
        end
        
        function [entrust_time] = entrustTime(obj)
            entrust_time = obj.issue_time_;
        end
        
        % ������Ŀǰֻ����Ȩ��Fee,Ŀǰ��û���漰���ڻ��ļ������(�����Ҫ��������)
        function [fee] = calcFee(obj, volume)
            if ~exist('volume', 'var')
                volume = obj.volume;
            end
            fee = 0;
            % ��Ȩ�����ѷ�Ϊ�����֣� ���ַ� + Ӷ��
            % Ӷ��Ϊÿ����Ȩ0.3 Ԫ
            % ���ַ�Ϊÿ����Ȩ2Ԫ������ ���վ��ַ�
            % һ����ȨΪ10000�ɡ�       
            % ��@double��setter���ƣ���������buy = 1; sell = -1;
            % ��@double��setter���ƣ���ƽ����, open = 1; close = -1;
            if(obj.direction == -1 && obj.offsetFlag == 1)
                brokerage = 0;%���ַ�
            else
                brokerage = 2;
            end
            commission = 0.3; %Ӷ��
            fee = (brokerage + commission) * volume; % ���׷���      
            obj.fee = fee;
        end
        
        % ��һ������׼���µĵ�
        function fillEntrust(obj, marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount, offsetFlag, instrumentName)
            % ��һ������׼���µĵ�            
            % fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount, offsetFlag, instrumentName)
            if ~exist('offsetFlag', 'var'), offsetFlag = 1; end
            if ~exist('instrumentName', 'var'), instrumentName = '����'; end
            obj.marketNo        = marketNo;         % �г�
            obj.instrumentCode  = stockCode;        % ����
            obj.volume          = entrustAmount;    % ί������
            obj.price           = entrustPrice;     % ί�м۸�
            obj.direction       = entrustDirection; % ί�з���(����)
            obj.offsetFlag      = offsetFlag;       % ��ƽ����
            obj.instrumentName  = instrumentName;
            obj.calcFee();
        end
        
        function clearEntrust(e)
            e.updateTime = now;
            e.cancelVolume = e.volume - e.dealVolume;
            e.entrustStatus = -1;
        end
            
        % ����һ��O32��packet, queryEntrust��packet
        function fill_entrust_query_packet_HSO32(e, packet)
            e.updateTime    = now;
            e.dealVolume    = packet.getInt('deal_amount');      % �ɽ���Ŀ
            e.dealAmount    = packet.getDouble('deal_balance');     % �ɽ����
            e.dealPrice     = packet.getDouble('deal_price');      % �ɽ�����
            e.dealNum       = packet.getInt('deal_times');        % �ɽ�����
            e.cancelVolume  = packet.getInt('withdraw_amount');     % ��������
            e.calcFee(e.dealVolume);
            %                     e.cancelTime = now;          
        end
        
        function [position] = deal_to_position(e)
            % һ���������µ����position��������Ӱ�죿
            % 
%             if e.entrustStatus>=0
            if ~e.is_entrust_closed
                warning('ʧ�ܣ�entrustStatus = δ��ɣ���Ӧת��position');
                return;
            end
            
            % ���Ѿ�������entrust��deal��Ϣת��һ��Position
            position = Position;
            position.instrumentCode = e.instrumentCode;
            position.instrumentName = e.instrumentName;
            position.instrumentNo   = e.instrumentNo;
            position.volume         = e.dealVolume * e.offsetFlag; % �����ƽ�֣���volumeΪ��
            position.longShortFlag  = e.offsetFlag * e.direction; % ������directionͬlongshort���ز֣���direction��longshort�෴
            position.faceCost       = e.dealAmount * e.direction; % ��������ǳɱ�������������Ǹ��ɱ�
            position.avgCost        = position.faceCost / position.volume; % ƽ���ɱ�   
            position.feeCost        = e.calcFee(abs(position.volume));
        end
            
        function [position] = entrust_to_position(obj)
            % ��ĳ��Entrust����תΪPosition�ṹ
            position = Position;
            position.instrumentCode = obj.instrumentCode;
            position.instrumentName = obj.instrumentName;
            position.instrumentNo   = obj.instrumentNo;
            position.volume         = obj.volume * obj.offsetFlag; % �����ƽ�֣���volumeΪ��
            position.longShortFlag  = obj.offsetFlag * obj.direction; % ������directionͬlongshort���ز֣���direction��longshort�෴
            position.feeCost        = obj.calcFee();
        end
        
        % С����������ת�� -1�� 1  -->  '2', '1'
        function [entrustDirection] = get_CounterHSO32_direction( e )
            % �����̨��CounterHSO32���µ���directionҪ�� '1', '2'�����С�����������
            
            d = e.direction ;
            v = e.volume; % ���ֵӦ�ú�Ϊ����
            
            if d*v > 0
                entrustDirection = '1';
            elseif d*v < 0
                entrustDirection = '2';
            else
                entrustDirection = '0';
            end
        end
        
        
        % С����������ת�� -1�� 1  -->  '2', '1'
        function [kaiping] = get_CounterHSO32_offset( e )
            % �����̨��CounterHSO32���µ��Ŀ�ƽ��futureDirection��offsetFlag��Ҫ�� '1', '2'
            
            kp = e.offsetFlag;
            v = e.volume; % ���ֵӦ�ú�Ϊ����
            
            if kp*v > 0
                kaiping = '1';
            elseif kp*v < 0
                kaiping = '2';
            else
                kaiping = '0';
            end
        end
        
        function [flag] = is_entrust_filled(e)
            flag = (e.volume > 0) && (e.volume == e.dealVolume);
        end
        
        function [flag] = is_entrust_canceled(e)
            flag = (e.cancelVolume > 0);
        end
        
        % С�������жϱ�entrust�Ƿ��������status = -1
        function [ flag ] = is_entrust_closed(e)
            % �жϱ�entrust�Ƿ����
            % ����Ǹ���Ч���������Ѿ���ȫ�������ѳ�+�ѳ� == ���£�������status=-1
            % ί����Ϊ0�� ���Ƿϵ�����������������
            if e.volume == 0 
                flag = 1;
                e.entrustStatus = -1;
                return;
            end
            f1 = e.volume > 0; % �˵���Ч
            f2 = e.volume == e.dealVolume + e.cancelVolume; % �˵�����
            flag = f1&f2;
            if isempty(flag), flag = 0; end
            if flag 
                e.entrustStatus = -1; % ����ֹ
            end
        end
            
    
    end
    
    %% �ϲ�����
    methods
        function [obj] = merge_position(obj, other)
            % ��ͬƷ��ͬ����ί�еĲ�λ�ϲ�
            % �÷�������Ϊ������м䲽�裬���ڻ���Ķ������ԣ�ֻӦ������������ʱ�Ŀ�������
            % ��Ӧ��ֱ�Ӷ�ԭʼί�����˲���
            if( obj.offsetFlag == other.offsetFlag)                
                obj.volume = obj.volume + other.volume;                
            else
                vol = obj.volume - other.volume;
                if(vol < 0)
                    obj.offsetFlag = other.offsetFlag;
                end
                obj.volume = abs(vol);                 
            end
            obj.fee = obj.fee + other.fee;
            str = sprintf('entrust vol: %d, offset: %d \n', obj.volume, obj.offsetFlag);
            disp(str);            
        end
        
    end
    
    %%
    methods(Static = true)
        demo
        
        function [logical_ret] = is_same_asset(entrust_a, entrust_b)
           logical_ret = (strcmp(entrust_a.instrumentCode, entrust_b.instrumentCode) ...
                          && (entrust_a.direction == entrust_b.direction) ...
                          && strcmp(entrust_a.marketNo ,entrust_b.marketNo));
        end
    end
end

