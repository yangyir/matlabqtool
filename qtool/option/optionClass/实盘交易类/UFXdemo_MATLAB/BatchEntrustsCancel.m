function [errorCode, errorMsg,cancelNo] = BatchEntrustsCancel(connection,token, batchNo)
% EntrustCancel 通过Type来指定不同标的：
%[errorCode, errorMsg,cancelNo] = BatchEntrustsCancel(connection,token, batchNo)

    import com.hundsun.esb.*  com.hundsun.esb.data.*; 

    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,batchNo)); 
    cancelNo = -1;
    if errorCode == 0
        cancelNo = GetEntrustNo(packet);    
    end  
end

%type :   1 证券
%         2 期货
%         3 期权
function [message] = MakeRequestPacket(token,batchNo)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    functionID = '91102';

    message.prepare(Tagdef.REQUEST_PACKET, functionID);
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    %非必传字段，如无特殊说明，可以不打包。如股东代码，交易席位等    
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('batch_no',FieldType.DATATYPE_STRING,20,0);    %组合编号
    ds.addStr(token);
    ds.addStr(batchNo);
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end

function [entrustNo] = GetEntrustNo(packet)
    entrustNo = packet.getInt('entrust_no');
end