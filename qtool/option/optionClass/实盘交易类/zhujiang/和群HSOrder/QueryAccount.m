function [errorCode, errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,accountCode,combiNo)); 
end


function [message] = MakeRequestPacket(token,accountCode,combiNo)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %账户查询功能号：34001
    message.prepare(Tagdef.REQUEST_PACKET,'34001');  
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('account_code',FieldType.DATATYPE_STRING,32,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,20,0);
    ds.addStr(token);
    ds.addStr(accountCode);
    ds.addStr(combiNo);    
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end