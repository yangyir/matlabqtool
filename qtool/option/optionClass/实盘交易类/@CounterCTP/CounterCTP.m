classdef CounterCTP  < handle
    %COUNTERCTP CTP�Ĺ�̨����½����Ϣ
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
        function self = CounterCTP( serverAddr , broker, investor, password, counter_type, product_info, authen_code)

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
        %% ר����Թ�Ʊ��
%         [errorCode,errorMsg,packet]     = queryCombiStock(self,marketNo,stockCode)
%         [errorCode,errorMsg,entrustNo]  = entrust(self, marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount)
%         [errorCode,errorMsg,packet]     = queryEntrusts(self, entrustNo);
%         [errorCode,errorMsg,cancelNo]   = entrustCancel(self, entrustNo);
%         [errorCode,errorMsg,packet]     = queryDeals(self, entrustNo);
        
%         [cash] = queryCash(self);
        
        %% Ҫ�����Ȩר��������
%          [errorCode,errorMsg,entrustNo]  = optPlaceEntrust(self, marketNo, optCode, entrustDirection, futuresDirection, entrustPrice, entrustAmount, coveredFlag)
%          [errorCode,errorMsg,packet]     = queryOptEntrusts(self, entrustNo);
%          [errorCode,errorMsg,cancelNo]   = optEntrustCancel(self, entrustNo);
%          [errorCode,errorMsg,packet]     = queryOptDeals(self, entrustNo);
        
        %% ��Թ�ָ�ڻ���
%         [errorCode,errorMsg,packet]     = queryCombiFuture(self,marketNo,stockCode)
%         [errorCode,errorMsg,entrustNo]  = futPlaceEntrust(self, marketNo,stockCode,entrustDirection,futuresDirection,entrustPrice,entrustAmount)
%         [errorCode,errorMsg,packet]     = queryFutEntrusts(self, entrustNo);
%         [errorCode,errorMsg,cancelNo]   = futEntrustCancel(self, entrustNo);
%         [errorCode,errorMsg,packet]     = queryFutDeals(self, entrustNo);
        
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
        % ��Ʒ��Ȩ
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