classdef CounterRH  < handle
    %CounterRH RH�Ĺ�̨����½����Ϣ
    % ----------------------------------------------
    % �콭��20160621����̨�������ܣ�login��logout��printInfo
    % �콭��20160201�����°�װUFX_MATLAB����غ�����ʹ֮��Ϊ��̨����ķ���
    % �̸գ�20161223������ö�ٹ�̨jianjia
    % �̸գ�20170118������ö�ٹ�̨montecarlo��wangzhe
    % �콭��20170718����������ί����Ϣ����[entrustinfoArray, ret] = loadEntrusts(self);
    
    %% ��̨���ӳɹ���ĺ��ģ������ⲿ����
    properties(SetAccess = 'private', Hidden = true , GetAccess = 'public')      
        counterId = 0;       % ��̨���
        counterType = []     % ��̨���ͣ���Ȩ��ETF����ƷΪ��ͬ����
    end
    
    %% ��̨���ӵ�����
    properties(SetAccess = 'private', Hidden = false , GetAccess = 'public') 
        % ��¼��Ҫ���õ�Ip��Portֵ
        serverAddr@char       = 'tcp://125.64.36.26:52205';   % ��ַ
        
        % broker:
        broker = '2001';

        % �˻�������
        investor = '8880000052';
        investorPassword = '123456';
        
        % У����Ϣ
        product_info = '';
        authentic_code = '';
        
        % �Ƿ��Ѿ���¼��̨
        is_Counter_Login = false;    
        
        % entrustId ����
        availableEntrustId = 1;
    end
    
    
    %% ���캯��
    methods
        function self = CounterRH( serverAddr , broker, investor, password, counter_type, product_info, authen_code)

            if exist('serverAddr', 'var') 
                self.serverAddr   = serverAddr;        % ��������ַ 
            end
            
            if exist('broker', 'var')
                self.broker = broker;    % ȯ��ID
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
    
    
    methods( Hidden = false , Access = 'public' , Static = false )
%% ------------���Ƚ������õ�¼----------------------------------
        % ���ӡ���½������   
        [ ] = login( self );
        [ ] = logout( self );       
        % ��� 
        [txt] = printInfo(self);
    
        % ȡ�ÿ���ί�б��
        function [entrust_id] = GetAvailableEntrustId(self)
            entrust_id = self.availableEntrustId;
            self.availableEntrustId = self.availableEntrustId + 1;
        end
        
        function [] = SetAvailableEntrustId(self, startID)
            self.availableEntrustId = startID + 1;
        end
    end
    
    
    %% ��counter�����°�װ��غ���
    methods( Hidden = false , Access = 'public' , Static = false )
        %% �µ�
         [ret] = placeEntrust(self, entrust)
         %% ��ѯ
         [ret] = queryEntrust(self, entrust)
         %% ����
         [ret] = withdrawEntrust(self, entrust);
         [accountinfo, ret] = queryAccount(self);
         [positionArray, ret] = queryPositions(self, code);
         [tradeArray, ret] = queryTrades(self);
         [entrustinfoArray, ret] = loadEntrusts(self);
%         [errorCode,errorMsg,packet]     = queryAccount(self)
        %% ������㵥
         [] = querySettlementInfo(self, date_num, file_path);
    end
    
    
    %% static methods
    methods(Static = true )
        demo;
        demo2;
    end
    
    
    %% ö�ټ��������Ĺ�̨����
    enumeration 
        HuaXiOptTest('tcp://125.64.36.26:52205', '2001', '8880000052', '123456', 'Option');
		RHTest('tcp://120.136.134.132:10001', 'RohonDemo', 'xhrf01', '888888', 'Future');
        rh_demo_tf( 'tcp://192.168.41.194:10001','RohonDemo','yy01','123456','Future');
    end

    
    
    
    
    
    
end