classdef CounterXSpeed  < handle
    %COUNTERXSPEED XSpeed�Ĺ�̨����½����Ϣ
    % ----------------------------------------------
    % �콭��20160621����̨�������ܣ�login��logout��printInfo
    % �콭��20160201�����°�װUFX_MATLAB����غ�����ʹ֮��Ϊ��̨����ķ���
    % �̸գ�20170620�����ö��GuangDaOpt2
    
    %% ��̨���ӳɹ���ĺ��ģ������ⲿ����
    properties(SetAccess = 'private', Hidden = true , GetAccess = 'public')      
        counterId = 0;       % ��̨���
        counterType = []     % ��̨���ͣ���Ȩ��ETF����ƷΪ��ͬ����
    end
    
    %% ��̨���ӵ�����
    properties(SetAccess = 'private', Hidden = false , GetAccess = 'public') 
        % ��¼��Ҫ���õ�Ip��Portֵ
        serverAddr@char       = 'tcp://101.226.253.121:20915';   % ��ַ
        % ��־�ļ�
        logfile = 'xspeed_counter.log';
        % �˻�������
        investor = '200100000060';
        investorPassword = '808552';
        
        % �Ƿ��Ѿ���¼��̨
        is_Counter_Login = false;    
        
        % entrustId ����
        availableEntrustId = 1;
    end
    
    
    %% ���캯��
    methods
        function self = CounterXSpeed( serverAddr , investor, password, counter_type, logfile)

            if exist('serverAddr', 'var') 
                self.serverAddr   = serverAddr;        % ��������ַ 
            end
            
            if exist('logfile', 'var')
                self.logfile = logfile;    % ��־
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
%         [errorCode,errorMsg,packet]     = queryAccount(self)
        
        
        %% ������
        
        %% ��һͳ�������Ͳ���
        % TODO�� �콭��������
    end
    
    
    %% static methods
    methods(Static = true )
        demo;
        demo2;
    end
    
    
    %% ö�ټ��������Ĺ�̨����
    enumeration 
        GuangDaOptTest('tcp://101.226.253.121:20910', '200100000060', '808552', 'Option', 'guangda_opt_test_counter.log');
        GuangDaOptTest2('tcp://101.226.253.121:20910', '110500000021', '808552', 'Option', 'guangda_opt_test2_counter.log');

        % Hod1
        GuangDaOpt('tcp://140.207.224.227:10910', '010130890103', '808552', 'Option', 'guangda_opt_counter.log');
        GuangDaETF('tcp://140.207.224.227:10910', '010130890103', '808552', 'ETF', 'guangda_opt_counter.log');
        
        % Hod7
        GuangDaOpt2('tcp://140.207.224.227:10910', '010108390008', '808552', 'Option', 'guangda_opt_counter_2.log');
        GuangDaETF2('tcp://140.207.224.227:10910', '010108390008', '808552', 'ETF', 'guangda_opt_counter_2.log');
    end
end


