function UFXdemo(serverIp,serverPort,operatorNo,password,accountCode,combiNo)
%Description
%
%   ��Matlab�е���UFX��Java�汾�ӿڵĳ���ʾ�������幦�ܰ��������ӡ���¼���ǳ����µ�����ѯί����ˮ����ѯ�ɽ���ˮ����ѯ�˻��ʽ𡢲�ѯ�˻��ֲ�
%
%Input Arguments
%
%    serverIp    UFX������IP
%	 serverPort  UFX�������˿�
%    operatorNo   ����Ա
%    password     ����
%    accountCode ���ڽ��׵��˻�������O32ϵͳ��˵����vc_fund_code
%    combiNo     ���ڽ��׵���ϣ�����O32ϵͳ��˵����vc_combi_no
%
%Examples
%   UFXdemo('192.168.41.72',9003,'2038','1','2016','82000016-J')
%   
    
    javaaddpath('ESBJavaAPI.jar');    
    
    marketNo = '1';         %�����г�
    stockCode = '600036';   %֤ȯ����
    entrustDirection = '1'; %ί�з�������
    entrustPrice = 17;   %ί�м۸�
    entrustAmount = 100;    %ί������
    
    %����
    [errorCode, errorMsg, connection] = Connect(serverIp,serverPort);
    if errorCode < 0             
        disp(['���ӷ�����ʧ�ܡ�������ϢΪ:',errorMsg]);
        return;
    else
        disp('���ӳɹ�');
    end
    
    
    %��¼
    [errorCode,errorMsg,token] = Login(connection,operatorNo,password);
    if errorCode < 0        
        disp(['��¼ʧ�ܡ�������ϢΪ:',errorMsg]);
        return;
    else
        disp('��¼�ɹ�');
    end
    
    % �˴��Ȳ���һ����������������
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
        disp('ί�гɹ�');
    else                        
        disp(['�µ�ʧ�ܡ�������ϢΪ:',errorMsg]);
        Logout(connection,token);
        return;
    end
    
    stkEntrustNo = entrustNo(1,2);
    optEntrustNo = entrustNo(2,2);
    futEntrustNo = entrustNo(3,2);
    
    % ���г���
    % ������Ʊ�ڻ���Ȩ����ͬһ���ܣ���Ҫ������ϱ��
    [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,'82000016-J',stkEntrustNo);
    if errorCode < 0
        disp(['�������󡣴�����ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------������Ϣ--------------');
        disp(['�����ɹ���������Ϊ:',num2str(cancelNo)]);   
    end   
     
    [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,'82002004',optEntrustNo);
    if errorCode < 0
        disp(['�������󡣴�����ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------������Ϣ--------------');
        disp(['�����ɹ���������Ϊ:',num2str(cancelNo)]);   
    end   
    
    [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,'82000016-J',futEntrustNo);
    if errorCode < 0
        disp(['�������󡣴�����ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------������Ϣ--------------');
        disp(['�����ɹ���������Ϊ:',num2str(cancelNo)]);   
    end   
     
    % ��ѯί��
    % ���Ʊ
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,'82000016-J',stkEntrustNo,1);
    if errorCode < 0
        disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------ί����Ϣ--------------');
        PrintPacket(packet); %��ӡί����Ϣ 
    end    
    % ����Ȩ
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,'82002004',optEntrustNo,3);
    if errorCode < 0
        disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------ί����Ϣ--------------');
        PrintPacket(packet); %��ӡί����Ϣ 
    end   
    % ���ڻ�
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,'82000016-J',futEntrustNo,2);
    if errorCode < 0
        disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------ί����Ϣ--------------');
        PrintPacket(packet); %��ӡί����Ϣ 
    end
    
    % ��ѯ�ɽ�
    % ���Ʊ
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,'82000016-J',stkEntrustNo,1);
    if errorCode < 0
        disp(['��ɽ�ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------�ɽ���Ϣ--------------');
        PrintPacket(packet); %��ӡ�ɽ���Ϣ 
    end    
    
    % ����Ȩ
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,'82002004',optEntrustNo,3);
    if errorCode < 0
        disp(['��ɽ�ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------�ɽ���Ϣ--------------');
        PrintPacket(packet); %��ӡ�ɽ���Ϣ 
    end
    
    % ���ڻ�
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,'82000016-J',futEntrustNo,2);
    if errorCode < 0
        disp(['��ɽ�ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------�ɽ���Ϣ--------------');
        PrintPacket(packet); %��ӡ�ɽ���Ϣ 
    end
    
    %����������tokenһֱ����
    [heartbeatTimer] = HeartBeat(connection,token);
    
    %ί�С�ע�⣺[combi_no]Ҫ����ʵ�ʵĵ���ϱ��
    [errorCode,errorMsg,entrustNo] = Entrust(connection,token,combiNo,marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount);
    if errorCode == 0
        disp('ί�гɹ�');
    else                        
        disp(['�µ�ʧ�ܡ�������ϢΪ:',errorMsg]);
        Logout(connection,token);
        return;
    end
    
    [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,combiNo,entrustNo);
    if errorCode < 0
        disp(['�������󡣴�����ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------������Ϣ--------------');
        disp(['�����ɹ���������Ϊ:',num2str(cancelNo)]);   
     end    
    
    %��ѯί��    
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,combiNo,entrustNo,1);
    if errorCode < 0
        disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------ί����Ϣ--------------');
        PrintPacket(packet); %��ӡί����Ϣ 
    end    
    
    %��ѯ�ɽ�    
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,combiNo,entrustNo,1);
    if errorCode < 0
        disp(['��ɽ�ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------�ɽ���Ϣ--------------');
        PrintPacket(packet); %��ӡ�ɽ���Ϣ 
    end       
    
    %��ѯ�ʽ�    
    [errorCode,errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo);
    if errorCode < 0
        disp(['���ʽ�ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------�ʽ���Ϣ--------------');
        PrintPacket(packet); %��ӡ�ʽ���Ϣ 
    end
    
    %��ѯ�ֲ�    
    [errorCode,errorMsg,packet] = QueryCombi(connection,token,accountCode,combiNo,marketNo,stockCode,1);
    if errorCode < 0
        disp(['��ֲ�ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------�ֲ���Ϣ--------------');
        PrintPacket(packet); %��ӡ�ֲ���Ϣ 
    end
            
    %�˳���¼
    Logout(connection,token);
    delete(heartbeatTimer);    
end

