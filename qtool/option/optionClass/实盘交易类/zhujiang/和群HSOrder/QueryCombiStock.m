function [errorCode, errorMsg,packet] = QueryCombiStock(connection,token,accountCode,combiNo,marketNo,stockCode)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,accountCode,combiNo,marketNo,stockCode)); 
end


function [message] = MakeRequestPacket(token,accountCode,combiNo,marketNo,stockCode)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %持仓查询功能号：31001
    message.prepare(Tagdef.REQUEST_PACKET,'31001');
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('account_code',FieldType.DATATYPE_STRING,32,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,20,0);
    ds.addField('market_no',FieldType.DATATYPE_STRING,3,0);
    ds.addField('stock_code',FieldType.DATATYPE_STRING,16,0);
    ds.addStr(token);
    ds.addStr(accountCode);
    ds.addStr(combiNo);
    ds.addStr(marketNo);
    ds.addStr(stockCode);
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end