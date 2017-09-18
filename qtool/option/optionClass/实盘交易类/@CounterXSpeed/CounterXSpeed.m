classdef CounterXSpeed  < handle
    %COUNTERXSPEED XSpeed的柜台，登陆的信息
    % ----------------------------------------------
    % 朱江，20160621，柜台基本功能：login，logout，printInfo
    % 朱江，20160201，重新包装UFX_MATLAB的相关函数，使之成为柜台对象的方法
    % 程刚，20170620，添加枚举GuangDaOpt2
    
    %% 柜台连接成功后的核心，无须外部看到
    properties(SetAccess = 'private', Hidden = true , GetAccess = 'public')      
        counterId = 0;       % 柜台编号
        counterType = []     % 柜台类型：期权，ETF，商品为不同类型
    end
    
    %% 柜台连接的属性
    properties(SetAccess = 'private', Hidden = false , GetAccess = 'public') 
        % 登录需要利用的Ip和Port值
        serverAddr@char       = 'tcp://101.226.253.121:20915';   % 地址
        % 日志文件
        logfile = 'xspeed_counter.log';
        % 账户和密码
        investor = '200100000060';
        investorPassword = '808552';
        
        % 是否已经登录柜台
        is_Counter_Login = false;    
        
        % entrustId 计数
        availableEntrustId = 1;
    end
    
    
    %% 构造函数
    methods
        function self = CounterXSpeed( serverAddr , investor, password, counter_type, logfile)

            if exist('serverAddr', 'var') 
                self.serverAddr   = serverAddr;        % 服务器地址 
            end
            
            if exist('logfile', 'var')
                self.logfile = logfile;    % 日志
            end
            
            if exist('investor', 'var')                
                self.investor = investor;    % 账户
            end
            
            if exist('password', 'var')
                self.investorPassword   = password;        % 账户的密码
            end            
            
            if exist('counter_type', 'var')
                self.counterType   = counter_type;        % 账户的类型
            end            
            
        end
        
    end
    
    
    methods( Hidden = false , Access = 'public' , Static = false )
%% ------------首先进行设置登录----------------------------------
        % 连接、登陆、心跳   
        [ ] = login( self );
        [ ] = logout( self );       
        % 输出 
        [txt] = printInfo(self);
    
        % 取得可用委托编号
        function [entrust_id] = GetAvailableEntrustId(self)
            entrust_id = self.availableEntrustId;
            self.availableEntrustId = self.availableEntrustId + 1;
        end
    end
    
    
    %% 在counter里重新包装相关函数
    methods( Hidden = false , Access = 'public' , Static = false )
        %% 下单
         [ret] = placeEntrust(self, entrust)
         %% 查询
         [ret] = queryEntrust(self, entrust)
         %% 撤单
         [ret] = withdrawEntrust(self, entrust);
         [accountinfo, ret] = queryAccount(self);
         [positionArray, ret] = queryPositions(self, code);
%         [errorCode,errorMsg,packet]     = queryAccount(self)
        
        
        %% 批量单
        
        %% 大一统，带类型参数
        % TODO： 朱江，不紧急
    end
    
    
    %% static methods
    methods(Static = true )
        demo;
        demo2;
    end
    
    
    %% 枚举几个常见的柜台设置
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


