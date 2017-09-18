%Examples
%   UFXdemo('192.168.41.72',9003,'2038','1','2016','82000016-J')  
   serverIp    = '192.168.41.72';
   serverPort  = 9003;
   operatorNo   = '2038';
   password    = '1';
   accountCode = '2016';
   combiNo     = '82000016-J';



    javaaddpath('ESBJavaAPI.jar');    
    
    marketNo = '1';         %�����г�
    stockCode = '510050';   %֤ȯ����
    entrustDirection = '1'; %ί�з�������
    entrustPrice = 2.4;   %ί�м۸�
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
    
    %��ѯί��    
    [errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,combiNo,entrustNo);
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
    [errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,combiNo,entrustNo);
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
    stockCode = '510050';
    [errorCode,errorMsg,packet] = QueryCombiStock(connection,token,accountCode,combiNo,marketNo,stockCode);
    if errorCode < 0
        disp(['��ֲ�ʧ�ܡ�������ϢΪ:',errorMsg]);    
        Logout(connection,token);
        delete(heartbeatTimer);
        return;         
    else
        disp('-------------�ֲ���Ϣ--------------');
        PrintPacket(packet); %��ӡ�ֲ���Ϣ 
        packet.getDoubleByIndex(16)
    end
            
    %�˳���¼
    Logout(connection,token);
    delete(heartbeatTimer);    