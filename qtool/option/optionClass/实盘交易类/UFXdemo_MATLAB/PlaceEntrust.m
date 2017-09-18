function [errorCode, errorMsg,entrustNo] = PlaceEntrust(connection,token,combiNo,marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,combiNo,marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount)); 
    entrustNo = -1;
    if errorCode == 0
        entrustNo = GetEntrustNo(packet);    
    end  
end


function [message] = MakeRequestPacket(token,combiNo,marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %委托功能号：91001
    message.prepare(Tagdef.REQUEST_PACKET,'91001');
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    %非必传字段，如无特殊说明，可以不打包。如股东代码，交易席位等    
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,20,0);    %组合编号
    ds.addField('market_no',FieldType.DATATYPE_STRING,3,0);
    ds.addField('stock_code',FieldType.DATATYPE_STRING,31,0);
    ds.addField('entrust_direction',FieldType.DATATYPE_STRING,1,0);
    ds.addField('price_type',FieldType.DATATYPE_STRING,1,0);
    ds.addField('entrust_price',FieldType.DATATYPE_DOUBLE,9,3);
    ds.addField('entrust_amount',FieldType.DATATYPE_DOUBLE,16,2);    
    ds.addStr(token);
    ds.addStr(combiNo);
    ds.addStr(marketNo);
    ds.addStr(stockCode);
    ds.addStr(entrustDirection);
    ds.addStr('0');             %限价，详见数据字典
    ds.addDouble(entrustPrice);
    ds.addDouble(entrustAmount);
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end

function [entrustNo] = GetEntrustNo(packet)
    entrustNo = packet.getInt('entrust_no');
end