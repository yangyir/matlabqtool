%Examples
%   UFXdemo('192.168.41.72',9003,'2038','1','2016','82000016-J')  
   serverIp    = '192.168.41.72';
   serverPort  = 9003;
   operatorNo   = '2038';
   password    = '1';
   accountCode = '2016';
   combiNo     = '82000016-J';



    javaaddpath('ESBJavaAPI.jar');    
    
    marketNo = '1';         %交易市场
    stockCode = '510050';   %证券代码
    entrustDirection = '1'; %委托方向：买入
    entrustPrice = 2.4;   %委托价格
    entrustAmount = 100;    %委托数量
    
    %连接
    [errorCode, errorMsg, connection] = Connect(serverIp,serverPort);
    if errorCode < 0             
        disp(['连接服务器失败。错误信息为:',errorMsg]);
        return;
    else
        disp('连接成功');
    end
    
    
    %登录
    [errorCode,errorMsg,token] = Login(connection,operatorNo,password);
    if errorCode < 0        
        disp(['登录失败。错误信息为:',errorMsg]);
        return;
    else
        disp('登录成功');
    end
    
    %心跳。保持token一直可用
    [heartbeatTimer] = HeartBeat(connection,token);
    
    %委托。注意：[combi_no]要换成实际的的组合编号
    [errorCode,errorMsg,entrustNo] = Entrust(connection,token,combiNo,marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount);
    if errorCode == 0
        disp('委托成功');
    else                        
        disp(['下单失败。错误信息为:',errorMsg]);
        Logout(connection,token);
        return;
    end
    
    %查询委托    
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,combiNo,entrustNo);
    if errorCode < 0
        disp(['查委托失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------委托信息--------------');
        PrintPacket(packet); %打印委托信息 
    end    
    
    %查询成交    
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,combiNo,entrustNo);
    if errorCode < 0
        disp(['查成交失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------成交信息--------------');
        PrintPacket(packet); %打印成交信息 
    end       
    
    %查询资金    
    [errorCode,errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo);
    if errorCode < 0
        disp(['查资金失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------资金信息--------------');
        PrintPacket(packet); %打印资金信息 
    end
    
    %查询持仓    
    stockCode = '510050';
    [errorCode,errorMsg,packet] = QueryCombiStock(connection,token,accountCode,combiNo,marketNo,stockCode);
    if errorCode < 0
        disp(['查持仓失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------持仓信息--------------');
        PrintPacket(packet); %打印持仓信息 
        packet.getDoubleByIndex(16)
    end
            
    %退出登录
    Logout(connection,token);
    delete(heartbeatTimer);    