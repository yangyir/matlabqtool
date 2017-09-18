function [errorCode, errorMsg,cancelNo] = BatchEntrustsCancel(connection,token, batchNo)
% EntrustCancel ͨ��Type��ָ����ͬ��ģ�
%[errorCode, errorMsg,cancelNo] = BatchEntrustsCancel(connection,token, batchNo)

    import com.hundsun.esb.*  com.hundsun.esb.data.*; 

    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,batchNo)); 
    cancelNo = -1;
    if errorCode == 0
        cancelNo = GetEntrustNo(packet);    
    end  
end

%type :   1 ֤ȯ
%         2 �ڻ�
%         3 ��Ȩ
function [message] = MakeRequestPacket(token,batchNo)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    functionID = '91102';

    message.prepare(Tagdef.REQUEST_PACKET, functionID);
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    %�Ǳش��ֶΣ���������˵�������Բ��������ɶ����룬����ϯλ��    
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('batch_no',FieldType.DATATYPE_STRING,20,0);    %��ϱ��
    ds.addStr(token);
    ds.addStr(batchNo);
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end

function [entrustNo] = GetEntrustNo(packet)
    entrustNo = packet.getInt('entrust_no');
end