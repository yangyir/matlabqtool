classdef CounterCTP  < handle
    %COUNTERCTP CTP的柜台，登陆的信息
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
        function self = CounterCTP( serverAddr , broker, investor, password, counter_type, product_info, authen_code)

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
        %% 专门针对股票的
%         [errorCode,errorMsg,packet]     = queryCombiStock(self,marketNo,stockCode)
%         [errorCode,errorMsg,entrustNo]  = entrust(self, marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount)
%         [errorCode,errorMsg,packet]     = queryEntrusts(self, entrustNo);
%         [errorCode,errorMsg,cancelNo]   = entrustCancel(self, entrustNo);
%         [errorCode,errorMsg,packet]     = queryDeals(self, entrustNo);
        
%         [cash] = queryCash(self);
        
        %% 要针对期权专门做函数
%          [errorCode,errorMsg,entrustNo]  = optPlaceEntrust(self, marketNo, optCode, entrustDirection, futuresDirection, entrustPrice, entrustAmount, coveredFlag)
%          [errorCode,errorMsg,packet]     = queryOptEntrusts(self, entrustNo);
%          [errorCode,errorMsg,cancelNo]   = optEntrustCancel(self, entrustNo);
%          [errorCode,errorMsg,packet]     = queryOptDeals(self, entrustNo);
        
        %% 针对股指期货的
%         [errorCode,errorMsg,packet]     = queryCombiFuture(self,marketNo,stockCode)
%         [errorCode,errorMsg,entrustNo]  = futPlaceEntrust(self, marketNo,stockCode,entrustDirection,futuresDirection,entrustPrice,entrustAmount)
%         [errorCode,errorMsg,packet]     = queryFutEntrusts(self, entrustNo);
%         [errorCode,errorMsg,cancelNo]   = futEntrustCancel(self, entrustNo);
%         [errorCode,errorMsg,packet]     = queryFutDeals(self, entrustNo);
        
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
        HuaXiOptTest('tcp://125.64.36.26:52205', '2001', '8880000052', '123456', 'Option');
        HuaXiETFTest('tcp://125.64.36.26:51205', '2001', '0000001052', '123456', 'ETF');
        HuaXiFutTest('tcp://180.168.146.187:10000', '9999', '079131', 'Sm09221016Simnow', 'Future');
        huaxi_opt('tcp://140.207.227.81:41205', '16337', '8880000022', '250348', 'Option');
        huaxi_opt2('tcp://101.226.253.81:41205', '16337', '8880000022', '250348', 'Option');
        huaxi_opt3('tcp://140.207.227.81:41205', '16337', '8880010013', '458230', 'Option');
        huaxi_opt4('tcp://140.207.227.81:41205', '16337', '8880010012', '458230', 'Option');
        huaxi_etf('tcp://140.207.227.83:41205', '16337', '0000000022', '123456', 'ETF');
        
        huaxi_fangdian_opt('tcp://140.207.227.81:41205', '16337', '8880010013', '458230', 'Option');
        huaxi_fangdian_etf('tcp://140.207.227.83:41205', '16337', '0010000013', '458230', 'ETF');
        huaxi_fangdian_fut('tcp://180.168.102.231:41205', '16333', '119520', '161107', 'Future');
        
        huaxi_jianjia_opt('tcp://140.207.227.81:41205', '16337', '8880010012', '458230', 'Option');
        huaxi_jianjia_etf('tcp://140.207.227.83:41205', '16337', '0010000012', '458230', 'ETF');
        huaxi_jianjia_fut('tcp://180.168.102.232:41205', '16333', '119611', '161107', 'Future');

        huaxi_huangshan_opt('tcp://140.207.227.81:41205', '16337', '8880010005', '458230', 'Option');
        huaxi_huangshan_etf('tcp://140.207.227.83:41205', '16337', '0010000005', '458230', 'ETF');
        
        huaxi_kunpeng_opt('tcp://140.207.227.81:41205', '16337', '8880010006', '458230', 'Option');
        huaxi_kunpeng_etf('tcp://140.207.227.83:41205', '16337', '0010000006', '458230', 'ETF');
        
        huaxi_guangkuo_opt('tcp://140.207.227.81:41205', '16337', '8880010009', '458230', 'Option');
        huaxi_guangkuo_etf('tcp://140.207.227.83:41205', '16337', '0010000009', '458230', 'ETF');        
        
        huaxi_hede3_opt('tcp://140.207.227.81:41205', '16337', '8880000028', '808552', 'Option');
        huaxi_hede3_etf('tcp://140.207.227.83:41205', '16337', '0000000028', '808552', 'ETF');     
        
        huaxi_wyf('tcp://140.207.227.81:41205', '16337', '8880000031', '458230', 'Option');
        huaxi_mianhuang('tcp://140.207.227.81:41205', '16337', '8880000030', '458230', 'Option');
        huaxi_mianhuangFut('tcp://180.168.102.231:41205', '16333', '119607', '458230', 'Future');
        
        huaxi_montecarlo_opt('tcp://140.207.227.81:41205', '16337', '8880000033', '458230', 'Option');
        huaxi_montecarlo_etf('tcp://140.207.227.83:41205', '16337', '0000000033', '458230', 'ETF'); 
        huaxi_montecarlo_fut('tcp://180.168.102.233:41205', '16333', '119605', '161107', 'Future');
        
        huaxi_wangzhe_opt('tcp://140.207.227.81:41205', '16337', '8880000035', '458230', 'Option');
        huaxi_wangzhe_etf('tcp://140.207.227.83:41205', '16337', '0000000035', '458230', 'ETF');        
        huaxi_wangzhe_fut('tcp://180.168.102.225:51205','16333','119603','458230','Future');
        
        xingzheng_test_opt('tcp://58.32.234.179:15656', '8200', '32200062', '32200062', 'Option', 'centuryprk', 'E13CC9YIHC0M6Z2N');
        xingzheng_opt('tcp://124.74.247.103:18686', '8200', '813200663', '458230', 'Option');
        % 商品期权
        zhongxin_test_opt('tcp://ctpfz1-front1.citicsf.com:51205', '66666', '898710', '654321', 'Option');
        zhongxin_test_env('tcp://203.110.179.217:31205', '1000', '100107777', '111111', 'Option', 'kh1', '7E65D4CMJOWDGPYC');
        
        xingzheng_opt_663('tcp://124.74.247.103:18686', '8200', '813200663', '458230', 'Option', 'axinganxin', '0CGCWRSQ10UM5AAK');
        xingzheng_opt_665('tcp://124.74.247.103:18686', '8200', '813200665', '458230', 'Option', 'axinganxin', '0CGCWRSQ10UM5AAK');
        xingzheng_opt_666('tcp://124.74.247.103:18686', '8200', '813200666', '458230', 'Option', 'axinganxin', '0CGCWRSQ10UM5AAK');
        
        chengxiang_guapian_opt  ('tcp://124.74.247.103:18686', '8200', '813200653', '183488', 'Option', 'chenxiang', '8S9MPXYRPEZZHIT6');
        chengxiang_huyue_opt    ('tcp://124.74.247.103:18686', '8200', '813200655', '183488', 'Option', 'chenxiang', '8S9MPXYRPEZZHIT6');
        chengxiang_jinshi_opt   ('tcp://124.74.247.103:18686', '8200', '813200656', '183488', 'Option', 'chenxiang', '8S9MPXYRPEZZHIT6');
        chengxiang_makeyueer_opt('tcp://124.74.247.103:18686', '8200', '813200657', '183488', 'Option', 'chenxiang', '8S9MPXYRPEZZHIT6');
        chengxiang_masaimala_opt('tcp://124.74.247.103:18686', '8200', '813200658', '183488', 'Option', 'chenxiang', '8S9MPXYRPEZZHIT6');
        chengxiang_nanshan_opt  ('tcp://124.74.247.103:18686', '8200', '813200659', '183488', 'Option', 'chenxiang', '8S9MPXYRPEZZHIT6');

        citic_kim_fut('tcp://180.169.101.177:41205','66666','101003196','770424','Future');
        
        huaxin_liyang_fut('tcp://180.169.70.179:41205','10001','930490003','204090','Future');

    end

    
    
    
    
    
    
end