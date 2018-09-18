classdef cCounterRH < handle
    %COUNTERRH 融航的柜台，登录的信息
    
    %% 柜台连接成功后的核心，无需外部看到
    properties ( SetAccess = private, Hidden = true, GetAccess = public )
        counterId = 0       % 柜台编号
        counterType = []    % 柜台类型
    end
    
    %% 柜台连接的属性
    properties ( SetAccess = private, Hidden = false, GetAccess = public )
        % 登录需要利用的IP和port值
        serverAddr@char = 'tcp://120.26.112.186:10001' %IP地址
        
        % broker
        broker = 'RohonDemo'
        
        % 账户和密码
        investor = 'jxly01'
        investorPassword = '888888';
        
        % 校验信息
        product_info = '';
        authentic_code = '';
        
        % 是否已经登录柜台
        is_Counter_Login = false
        
        % entrustId 计数
        availableEntrustId = 1;
    end
    
    %% 构造函数
    methods
        function self = cCounterRH( serverAddr , broker, investor, password, counter_type, product_info, authen_code)

            if exist('serverAddr', 'var') 
                self.serverAddr   = serverAddr;        % 服务器地址 
            end
            
            if exist('broker', 'var')
                self.broker = broker;    % 融航ID
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
    
    methods ( Hidden = false, Access = public, Static = false )
 %% ------------首先进行设置登录----------------------------------
        % 连接、登陆、心跳   
        [ ] = login(obj);
        [ ] = logout(obj);
        % 输出 
        [txt] = printInfo(obj);
    
        % 取得可用委托编号
        function [entrust_id] = GetAvailableEntrustId(obj)
            entrust_id = obj.availableEntrustId;
            obj.availableEntrustId = obj.availableEntrustId + 1;
        end
        
        function [] = SetAvailableEntrustId(obj, startID)
            obj.availableEntrustId = startID + 1;
        end       
    end
    
    %% 在counter里重新包装相关函数
    methods ( Hidden = false, Access = public, Static = false )
        %% 下单
        [ret] = placeEntrust(obj,entrust)
        %% 查询委托
        [ret] = queryEntrust(obj,entrust)
        %% 撤销委托
        [ret] = withdrawEntrust(obj,entrust)
        %% 查询账户资金
        [accountinfo, ret] = queryAccount(obj)
        %% 查询账户持仓信息
        [positionArray, ret] = queryPositions(obj, code)
        %% 查询账户成交信息
        [tradeArray, ret] = queryTrades(obj)
        %% 查询所有委托
        [entrustinfoArray, ret] = loadEntrusts(obj)
        %% 请求结算单
        [] = querySettlementInfo(obj, date_num, file_path)
        
    end
    
    %% 枚举常用的柜台设置
    enumeration
        rh_demo( 'tcp://120.26.112.186:10001','RohonDemo','jxly01','888888','Futures');
    end
    
    
    
        
end