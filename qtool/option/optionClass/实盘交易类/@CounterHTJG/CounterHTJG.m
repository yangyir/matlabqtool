classdef CounterHTJG  < handle
    %COUNTERHTGJ ��ſƼ��Ĺ�̨����½����Ϣ
    % ----------------------------------------------
    % �콭��20170322����̨�������ܣ�login��logout��printInfo

    
    %% ��̨���ӳɹ���ĺ��ģ������ⲿ����
    properties(SetAccess = 'private', Hidden = true , GetAccess = 'public')      
        counterId = 0;       % ��̨���
        counterType = []     % ��̨���ͣ���Ȩ��ETF����ƷΪ��ͬ����
    end
    
    %% ��̨���ӵ�����
    properties(SetAccess = 'private', Hidden = false , GetAccess = 'public') 
        % ��¼��Ҫ���õ�Ip��Portֵ
        serverAddr@char       = '125.64.36.26';   % ��ַ
        
        % broker:
        port = '2001';

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
        function self = CounterHTJG( serverAddr , port, investor, password)

            if exist('serverAddr', 'var') 
                self.serverAddr   = serverAddr;        % ��������ַ 
            end
            
            if exist('port', 'var')
                self.port = port;    % ȯ��ID
            end
            
            if exist('investor', 'var')                
                self.investor = investor;    % �˻�
            end
            
            if exist('password', 'var')
                self.investorPassword   = password;        % �˻�������
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
         %[tradeArray, ret] = queryTrades(self);
%         [errorCode,errorMsg,packet]     = queryAccount(self)
        %% ������㵥
         %[] = querySettlementInfo(self, date_num, file_path);
                
        %% ������
        
        %% ��һͳ�������Ͳ���
    end
    
    
    %% static methods
    methods(Static = true )
        %demo;
        %demo2;
    end
    
    
    %% ö�ټ��������Ĺ�̨����
    enumeration 
        JGopttest('seefar.3322.org', '5918', '000500000032', '123456');
        HTopttest('180.166.179.196', '5901', '9095000567', '147258');
        
        
        % Hod4
        HToptreal('180.166.179.215', '8203', '9168050014', '123321');
        
        % HodProp
        HodProp_opt('180.166.179.215', '8203', '9168050015', '147258');
             
 
        NiHuang_opt('180.166.179.215', '8203', '9168050016', '123321');
        
        
        % Hod7
        % ��ͨ�˺�9168050017������123321����ԭ���ڣ�
        Hod7_opt('180.166.179.215', '8203', '9168050017', '123321');

    end    
    
end