function UFXdemo(serverIp,serverPort,operatorNo,password,accountCode,combiNo)
%Description
%
%   在Matlab中调用UFX的Java版本接口的程序示例。具体功能包括：连接、登录、登出、下单、查询委托流水、查询成交流水、查询账户资金、查询账户持仓
%
%Input Arguments
%
%    serverIp    UFX服务器IP
%	 serverPort  UFX服务器端口
%    operatorNo   操作员
%    password     密码
%    accountCode 用于交易的账户，对于O32系统来说就是vc_fund_code
%    combiNo     用于交易的组合，对于O32系统来说就是vc_combi_no
%
%Examples
%   UFXdemo('192.168.41.72',9003,'2038','1','2016','82000016-J')
%   
    
    javaaddpath('ESBJavaAPI.jar');    
    
    marketNo = '1';         %交易市场
    stockCode = '600036';   %证券代码
    entrustDirection = '1'; %委托方向：买入
    entrustPrice = 17;   %委托价格
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
    
    % 此处先测试一次批量订单的情形
    currentOrder = COrderList(3);
    currentOrder.setCurrentID(1);
    currentOrder.fillOrder('82000016-J', 1, '510050', 1,...
                2.5, 100, 1, [] , [],...
                [], []);
    currentOrder.setCurrentID(2);
    currentOrder.fillOrder('82002004', 1, '10000298', 1,...
                0.5168, 1, 2, 1 , [],...
                [], 'D890798510');
    currentOrder.setCurrentID(3);
    currentOrder.fillOrder('82000016-J', 7, 'IF1601', 1,...
                3500, 1, 3, 1 , [],...
                [], []);
    [errorCode,errorMsg,entrustNo, batchNo] = Order(connection,token,currentOrder);
    if errorCode == 0
        disp('委托成功');
    else                        
        disp(['下单失败。错误信息为:',errorMsg]);
        Logout(connection,token);
        return;
    end
    
    stkEntrustNo = entrustNo(1,2);
    optEntrustNo = entrustNo(2,2);
    futEntrustNo = entrustNo(3,2);
    
    % 进行撤单
    % 撤单股票期货期权都用同一功能，需要设置组合编号
    [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,'82000016-J',stkEntrustNo);
    if errorCode < 0
        disp(['撤单错误。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------撤单信息--------------');
        disp(['撤单成功。撤单号为:',num2str(cancelNo)]);   
    end   
     
    [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,'82002004',optEntrustNo);
    if errorCode < 0
        disp(['撤单错误。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------撤单信息--------------');
        disp(['撤单成功。撤单号为:',num2str(cancelNo)]);   
    end   
    
    [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,'82000016-J',futEntrustNo);
    if errorCode < 0
        disp(['撤单错误。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------撤单信息--------------');
        disp(['撤单成功。撤单号为:',num2str(cancelNo)]);   
    end   
     
    % 查询委托
    % 查股票
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,'82000016-J',stkEntrustNo,1);
    if errorCode < 0
        disp(['查委托失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------委托信息--------------');
        PrintPacket(packet); %打印委托信息 
    end    
    % 查期权
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,'82002004',optEntrustNo,3);
    if errorCode < 0
        disp(['查委托失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------委托信息--------------');
        PrintPacket(packet); %打印委托信息 
    end   
    % 查期货
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,'82000016-J',futEntrustNo,2);
    if errorCode < 0
        disp(['查委托失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------委托信息--------------');
        PrintPacket(packet); %打印委托信息 
    end
    
    % 查询成交
    % 查股票
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,'82000016-J',stkEntrustNo,1);
    if errorCode < 0
        disp(['查成交失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------成交信息--------------');
        PrintPacket(packet); %打印成交信息 
    end    
    
    % 查期权
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,'82002004',optEntrustNo,3);
    if errorCode < 0
        disp(['查成交失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------成交信息--------------');
        PrintPacket(packet); %打印成交信息 
    end
    
    % 查期货
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,'82000016-J',futEntrustNo,2);
    if errorCode < 0
        disp(['查成交失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------成交信息--------------');
        PrintPacket(packet); %打印成交信息 
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
    
    [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,combiNo,entrustNo);
    if errorCode < 0
        disp(['撤单错误。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------撤单信息--------------');
        disp(['撤单成功。撤单号为:',num2str(cancelNo)]);   
     end    
    
    %查询委托    
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,combiNo,entrustNo,1);
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
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,combiNo,entrustNo,1);
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
    [errorCode,errorMsg,packet] = QueryCombi(connection,token,accountCode,combiNo,marketNo,stockCode,1);
    if errorCode < 0
        disp(['查持仓失败。错误信息为:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------持仓信息--------------');
        PrintPacket(packet); %打印持仓信息 
    end
            
    %退出登录
    Logout(connection,token);
    delete(heartbeatTimer);    
end

