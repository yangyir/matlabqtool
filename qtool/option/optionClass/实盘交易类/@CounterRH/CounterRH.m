classdef CounterRH  < handle
    %CounterRH RH的柜台，登陆的信息
    % ----------------------------------------------
    % 朱江，20160621，柜台基本功能：login，logout，printInfo
    % 朱江，20160201，重新包装UFX_MATLAB的相关函数，使之成为柜台对象的方法
    % 程刚，20161223，加入枚举柜台jianjia
    % 程刚，20170118，加入枚举柜台montecarlo，wangzhe
    % 朱江，20170718，加入载入委托信息功能[entrustinfoArray, ret] = loadEntrusts(self);
    
    %% 柜台连接成功后的核心，无须外部看到
    properties(SetAccess = 'private', Hidden = true , GetAccess = 'public')      
        counterId = 0;       % 柜台编号
        counterType = []     % 柜台类型：期权，ETF，商品为不同类型
    end
    
    %% 柜台连接的属性
    properties(SetAccess = 'private', Hidden = false , GetAccess = 'public') 
        % 登录需要利用的Ip和Port值
        serverAddr@char       = 'tcp://125.64.36.26:52205';   % 地址
        
        % broker:
        broker = '2001';

        % 账户和密码
        investor = '8880000052';
        investorPassword = '123456';
        
        % 校验信息
        product_info = '';
        authentic_code = '';
        
        % 是否已经登录柜台
        is_Counter_Login = false;    
        
        % entrustId 计数
        availableEntrustId = 1;
    end
    
    
    %% 构造函数
    methods
        function self = CounterRH( serverAddr , broker, investor, password, counter_type, product_info, authen_code)

            if exist('serverAddr', 'var') 
                self.serverAddr   = serverAddr;        % 服务器地址 
            end
            
            if exist('broker', 'var')
                self.broker = broker;    % 券商ID
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
            
            if exist('product_info', 'var')
                self.product_info = product_info;
            end
            
            if exist('authen_code', 'var')
                self.authentic_code = authen_code;
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
        
        function [] = SetAvailableEntrustId(self, startID)
            self.availableEntrustId = startID + 1;
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
         [tradeArray, ret] = queryTrades(self);
         [entrustinfoArray, ret] = loadEntrusts(self);
%         [errorCode,errorMsg,packet]     = queryAccount(self)
        %% 请求结算单
         [] = querySettlementInfo(self, date_num, file_path);
    end
    
    
    %% static methods
    methods(Static = true )
        demo;
        demo2;
    end
    
    
    %% 枚举几个常见的柜台设置
    enumeration 
        HuaXiOptTest('tcp://125.64.36.26:52205', '2001', '8880000052', '123456', 'Option');
		RHTest('tcp://120.136.134.132:10001', 'RohonDemo', 'xhrf01', '888888', 'Future');
        rh_demo_tf( 'tcp://192.168.41.194:10001','RohonDemo','yy01','123456','Future');
    end

    
    
    
    
    
    
end