function [errorCode,errorMsg] = Logout(connection,token)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg] = CallService(connection,MakeRequestPacket(token));    
end

function [message] = MakeRequestPacket(token)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %µÇ³ö¹¦ÄÜºÅ£º10002
    message.prepare(Tagdef.REQUEST_PACKET,'10002');
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);    
    ds.addStr(token);  
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end