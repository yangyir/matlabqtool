function [errorCode, errorMsg,token] = Login(connection,operator,password)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg, packet] = CallService(connection,MakeRequestPacket(operator,password));   
    PrintPacket(packet);
    if errorCode >= 0
        token = GetToken(packet);
    end  
end

function [message] = MakeRequestPacket(operator,password)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %��¼���ܺţ�10001
    message.prepare(Tagdef.REQUEST_PACKET,'10001');
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    ds.addField('operator_no',FieldType.DATATYPE_STRING,16,0);
    ds.addField('password',FieldType.DATATYPE_STRING,32,0);
    ds.addField('mac_address',FieldType.DATATYPE_STRING,255,0);
    ds.addField('op_station',FieldType.DATATYPE_STRING,255,0);
    ds.addField('ip_address',FieldType.DATATYPE_STRING,32,0);
    ds.addField('authorization_id',FieldType.DATATYPE_STRING,64,0);
    ds.addStr(operator);
    ds.addStr(password);
    ds.addStr('5C-26-0A-2F-82-4F');
    ds.addStr('192.168.88.123|5C-26-0A-2F-82-4F');
    ds.addStr('192.168.88.123');
    ds.addStr('hd123456');    
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end

function [token] = GetToken(packet)
    token = packet.getStr('user_token');
end