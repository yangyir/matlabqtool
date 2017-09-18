
% Deal ��Ӧ�µ���ĵ����ɽ�
%    ��CTP�ĳɽ��ر�Ϊ����
%     uint64_t trade_id_;
%     char code_[64];
%     int direction_;
%     int open_close_;
%     double price_;
%     uint32_t  amount_;
%     char trade_time_[64];
%     char  order_sys_id_[64];
%     int  trade_type_;
%     int  hedge_flag_;
%     int  market_type_;
%     ��ʱû���ڽ�����ʹ�á�
classdef Deal < handle
    properties
        entrust_no_; % ��Ӧ��Entrust
        deal_no_;    % Trade No
        code_;       % ��Ĵ���
        name_;       % �������        
        instrument_ ; % ������
        settle_time_;% ������
        direction_;  % ί�з���
        offset_;     % ��ƽ����
        price_;     % �ɽ���
        volume_;   % �ɽ�����        
        amount_;    % �ɽ���
        time_;      % �ɽ�ʱ��
        is_passive_ = 1; % 0 - �����ɽ��� 1 - �����ɽ�
        fee_;        % ������
    end
    
    methods
        % set �����Է���,��Ҫ�Ƿ���Ϳ�ƽ
        function [obj] = set.direction_(obj, vin)
            if isa(vin, 'char')
                switch vin
                    case {'1', 'buy', 'b', '��'}                
                        vout = 1;
                    case {'2', 'sell', 's', '��'}
                        vout = -1;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else  % ���������룬��nan
                vout = 0;
            end                
            obj.direction_ = vout;                     
        end
        
        function [obj] = set.offset_(obj, vin)
            if isa(vin, 'char')
                switch vin
                    case {'1', 'open', 'o', '��', '����'}  % ����
                        vout = 1;
                    case {'2', 'close', 'c', 'ƽ', 'ƽ��'}  % ƽ��
                        vout = -1;
                    otherwise
                        vout = 0;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else
                vout = 0;
            end
            obj.offset_ = vout;            
        end
        function [deal_time] = dealTime(obj)
            deal_time = obj.time_;
        end
        
        function [position] = deal_to_position(deal)
            %function [position] = deal_to_position(deal)
            % ���Ѿ�������entrust��deal��Ϣת��һ��Position
            position = Position;
            position.instrumentCode = deal.code_;
            position.instrumentName = deal.name_;
            position.volume         = deal.volume_ * deal.offset_; % �����ƽ�֣���volumeΪ��
            position.longShortFlag  = deal.offset_ * deal.direction_; % ������directionͬlongshort���ز֣���direction��longshort�෴
            position.faceCost       = deal.amount_ * deal.direction_; % ��������ǳɱ�������������Ǹ��ɱ�
            position.avgCost        = position.faceCost / position.volume; % ƽ���ɱ�   
            position.feeCost        = deal.fee_;
        end
        
        function [newobj] = getCopy(obj)
            eval( ['newobj = ', class(obj), ';']  );
            flds    = fields( obj );
            
            for i = 1:length(flds)
                fd          = flds{i};
                if isa(newobj.(fd), 'handle')
                    try
                        newobj.(fd) = obj.(fd).getCopy;
                    catch e
                        newobj.(fd) = obj.(fd);
                    end
                else
                    newobj.(fd) = obj.(fd);
                end                
            end
            
        end
    end
end