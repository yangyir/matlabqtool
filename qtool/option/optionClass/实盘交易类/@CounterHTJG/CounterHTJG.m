classdef CounterHTJG  < handle
    %COUNTERHTGJ 今古科技的柜台，登陆的信息
    % ----------------------------------------------
    % 朱江，20170322，柜台基本功能：login，logout，printInfo

    
    %% 柜台连接成功后的核心，无须外部看到
    properties(SetAccess = 'private', Hidden = true , GetAccess = 'public')      
        counterId = 0;       % 柜台编号
        counterType = []     % 柜台类型：期权，ETF，商品为不同类型
    end
    
    %% 柜台连接的属性
    properties(SetAccess = 'private', Hidden = false , GetAccess = 'public') 
        % 登录需要利用的Ip和Port值
        serverAddr@char       = '125.64.36.26';   % 地址
        
        % broker:
        port = '2001';

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
        function self = CounterHTJG( serverAddr , port, investor, password)

            if exist('serverAddr', 'var') 
                self.serverAddr   = serverAddr;        % 服务器地址 
            end
            
            if exist('port', 'var')
                self.port = port;    % 券商ID
            end
            
            if exist('investor', 'var')                
                self.investor = investor;    % 账户
            end
            
            if exist('password', 'var')
                self.investorPassword   = password;        % 账户的密码
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
         %[tradeArray, ret] = queryTrades(self);
%         [errorCode,errorMsg,packet]     = queryAccount(self)
        %% 请求结算单
         %[] = querySettlementInfo(self, date_num, file_path);
                
        %% 批量单
        
        %% 大一统，带类型参数
    end
    
    
    %% static methods
    methods(Static = true )
        %demo;
        %demo2;
    end
    
    
    %% 枚举几个常见的柜台设置
    enumeration 
        JGopttest('seefar.3322.org', '5918', '000500000032', '123456');
        HTopttest('180.166.179.196', '5901', '9095000567', '147258');
        
        
        % Hod4
        HToptreal('180.166.179.215', '8203', '9168050014', '123321');
        
        % HodProp
        HodProp_opt('180.166.179.215', '8203', '9168050015', '147258');
             
 
        NiHuang_opt('180.166.179.215', '8203', '9168050016', '123321');
        
        
        % Hod7
        % 海通账号9168050017，密码123321，（原光期）
        Hod7_opt('180.166.179.215', '8203', '9168050017', '123321');

    end    
    
end