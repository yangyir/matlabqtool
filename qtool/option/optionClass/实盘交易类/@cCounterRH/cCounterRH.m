classdef cCounterRH < handle
    %COUNTERRH �ں��Ĺ�̨����¼����Ϣ
    
    %% ��̨���ӳɹ���ĺ��ģ������ⲿ����
    properties ( SetAccess = private, Hidden = true, GetAccess = public )
        counterId = 0       % ��̨���
        counterType = []    % ��̨����
    end
    
    %% ��̨���ӵ�����
    properties ( SetAccess = private, Hidden = false, GetAccess = public )
        % ��¼��Ҫ���õ�IP��portֵ
        serverAddr@char = 'tcp://120.26.112.186:10001' %IP��ַ
        
        % broker
        broker = 'RohonDemo'
        
        % �˻�������
        investor = 'jxly01'
        investorPassword = '888888';
        
        % У����Ϣ
        product_info = '';
        authentic_code = '';
        
        % �Ƿ��Ѿ���¼��̨
        is_Counter_Login = false
        
        % entrustId ����
        availableEntrustId = 1;
    end
    
    %% ���캯��
    methods
        function self = cCounterRH( serverAddr , broker, investor, password, counter_type, product_info, authen_code)

            if exist('serverAddr', 'var') 
                self.serverAddr   = serverAddr;        % ��������ַ 
            end
            
            if exist('broker', 'var')
                self.broker = broker;    % �ں�ID
            end
            
            if exist('investor', 'var')                
                self.investor = investor;    % �˻�
            end
            
            if exist('password', 'var')
                self.investorPassword   = password;        % �˻�������
            end            
            
            if exist('counter_type', 'var')
                self.counterType   = counter_type;        % �˻�������
            end    
            
            if exist('product_info', 'var')
                self.product_info = product_info;
            end
            
            if exist('authen_code', 'var')
                self.authentic_code = authen_code;
            end
            
        end
    end
    
    methods ( Hidden = false, Access = public, Static = false )
 %% ------------���Ƚ������õ�¼----------------------------------
        % ���ӡ���½������   
        [ ] = login(obj);
        [ ] = logout(obj);
        % ��� 
        [txt] = printInfo(obj);
    
        % ȡ�ÿ���ί�б��
        function [entrust_id] = GetAvailableEntrustId(obj)
            entrust_id = obj.availableEntrustId;
            obj.availableEntrustId = obj.availableEntrustId + 1;
        end
        
        function [] = SetAvailableEntrustId(obj, startID)
            obj.availableEntrustId = startID + 1;
        end       
    end
    
    %% ��counter�����°�װ��غ���
    methods ( Hidden = false, Access = public, Static = false )
        %% �µ�
        [ret] = placeEntrust(obj,entrust)
        %% ��ѯί��
        [ret] = queryEntrust(obj,entrust)
        %% ����ί��
        [ret] = withdrawEntrust(obj,entrust)
        %% ��ѯ�˻��ʽ�
        [accountinfo, ret] = queryAccount(obj)
        %% ��ѯ�˻��ֲ���Ϣ
        [positionArray, ret] = queryPositions(obj, code)
        %% ��ѯ�˻��ɽ���Ϣ
        [tradeArray, ret] = queryTrades(obj)
        %% ��ѯ����ί��
        [entrustinfoArray, ret] = loadEntrusts(obj)
        %% ������㵥
        [] = querySettlementInfo(obj, date_num, file_path)
        
    end
    
    %% ö�ٳ��õĹ�̨����
    enumeration
        rh_demo( 'tcp://120.26.112.186:10001','RohonDemo','jxly01','888888','Futures');
    end
    
    
    
        
end