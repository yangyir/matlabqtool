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
    %委托功能号：91001
    message.prepare(Tagdef.REQUEST_PACKET,'91101');
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    %非必传字段，如无特殊说明，可以不打包。如股东代码，交易席位等    
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,20,0);    %组合编号
    ds.addField('entrust_no',FieldType.DATATYPE_INT,0,0);
    ds.addStr(token);
    ds.addStr(combiNo);
    ds.addInt(entrustNo);
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end

function [entrustNo] = GetEntrustNo(packet)
    entrustNo = packet.getInt('entrust_no');
end