function [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,combiNo,entrustNo)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,combiNo,entrustNo)); 
    cancelNo = -1;
    if errorCode == 0
        cancelNo = GetEntrustNo(packet);    
    end  
end


function [message] = MakeRequestPacket(token,combiNo,entrustNo)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %ί�й��ܺţ�91001
    message.prepare(Tagdef.REQUEST_PACKET,'91101');
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    %�Ǳش��ֶΣ���������˵�������Բ��������ɶ����룬����ϯλ��    
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,20,0);    %��ϱ��
    ds.addField('entrust_no',FieldType.DATATYPE_INT,0,0);
    ds.addStr(token);
    ds.addStr(combiNo);
    ds.addInt(entrustNo);
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end

function [entrustNo] = GetEntrustNo(packet)
    entrustNo = packet.getInt('entrust_no');
end