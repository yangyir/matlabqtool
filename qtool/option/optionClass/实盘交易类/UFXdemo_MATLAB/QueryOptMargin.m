function [errorCode, errorMsg,packet] = QueryOptMargin(connection,token,accountCode,combiNo,marketNo)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,accountCode,combiNo,marketNo)); 
end


function [message] = MakeRequestPacket(token, accountCode, combiNo, marketNo)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    % 功能号	34004
    % 功能名称	期权保证金账户查询
    functionID = '34004';
    message.prepare(Tagdef.REQUEST_PACKET, functionID);
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('account_code',FieldType.DATATYPE_STRING,32,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,20,0);
    ds.addField('market_no',FieldType.DATATYPE_STRING,3,0);
    ds.addStr(token);
    ds.addStr(accountCode);
    ds.addStr(combiNo);
    ds.addStr(marketNo);
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end