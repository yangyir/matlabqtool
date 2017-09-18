function [errorCode, errorMsg,entrustNoList, batchNo] = Order(connection,token,orderList)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    [errorCode, errorMsg, packet] = CallService(connection,MakeRequestPacket(token,orderList)); 
    entrustNoList = -1;
    if errorCode == 0
        [batchNo, entrustNoList] = GetEntrustBatNo(packet);    
    end  
end


function [message] = MakeRequestPacket(token,orderList)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %批量委托功能号：91090
    message.prepare(Tagdef.REQUEST_PACKET,'91090');
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    %非必传字段，如无特殊说明，可以不打包。如股东代码，交易席位等    
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,32,0);    %组合编号
    ds.addField('market_no',FieldType.DATATYPE_STRING,3,0);
    ds.addField('stock_code',FieldType.DATATYPE_STRING,16,0);
    ds.addField('entrust_direction',FieldType.DATATYPE_STRING,1,0);
    ds.addField('price_type',FieldType.DATATYPE_STRING,1,0);
    ds.addField('entrust_price',FieldType.DATATYPE_DOUBLE,9,3);
    ds.addField('entrust_amount',FieldType.DATATYPE_DOUBLE,16,0);
    ds.addField('extsystem_id',FieldType.DATATYPE_INT,16,0);
    ds.addField('stockholder_id',FieldType.DATATYPE_STRING,32,0);
    ds.addField('futures_direction',FieldType.DATATYPE_STRING,1,0);
    ds.addField('covered_flag',FieldType.DATATYPE_STRING,1,0);
    ds.addField('limit_entrust_ratio',FieldType.DATATYPE_DOUBLE,16,0);
    
    
    % 一次填充所有的订单
    for k = 1:orderList.maxOrderNum
        ds.addStr(token);
        ds.addStr(orderList.combiNo{k});
        ds.addStr(num2str(orderList.marketNo(k)));
        ds.addStr(orderList.stockCode{k});
        ds.addStr(num2str(orderList.entrustDirection(k)));
        ds.addStr(num2str(orderList.priceType(k)));  
        ds.addDouble(orderList.entrustPrice(k));
        ds.addDouble(orderList.entrustAmount(k));
        ds.addInt(orderList.extsystemId(k));
        if ~isempty(orderList.stockholderID{k})
            ds.addStr(orderList.stockholderID{k});
        else
            ds.addStr('');
        end
        if orderList.futuresDirection(k) ~= -1
            ds.addStr(num2str(orderList.futuresDirection(k)));
        else
            ds.addStr('');
        end
        ds.addStr(num2str(orderList.coveredFlag(k)));
        ds.addDouble(orderList.limitEntrustRatio);
    end
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end

function [batNo, entrustNoList] = GetEntrustBatNo(packet)
batNo = packet.getInt('batch_no');
entrustNoList = zeros(packet.getRow(),2);
for k = 1:packet.getRow()
    packet.setCurrRow(k-1);
    entrustNoList(k,1) = packet.getInt('extsystem_id');
    entrustNoList(k,2) = packet.getInt('entrust_no');
end
end