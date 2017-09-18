function [errorCode, errorMsg,packet] = QueryDeals(connection,token,accountCode,combiNo,entrustNo,type)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,accountCode,combiNo,entrustNo,type)); 
end


function [message] = MakeRequestPacket(token,accountCode,combiNo,entrustNo,type)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %成交查询功能号：33001
    if type == 2
        functionID = '33003';
    elseif type == 3
        functionID = '33004';
    else 
        functionID = '33001';
    end
    message.prepare(Tagdef.REQUEST_PACKET,functionID);
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('account_code',FieldType.DATATYPE_STRING,32,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,20,0);    %组合编号
    ds.addField('entrust_no',FieldType.DATATYPE_INT,0,0);
    ds.addStr(token);
    ds.addStr(accountCode);
    ds.addStr(combiNo);
    ds.addInt(entrustNo);    
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end