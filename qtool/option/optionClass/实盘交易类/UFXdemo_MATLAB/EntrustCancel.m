function [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,combiNo,entrustNo,type)
% EntrustCancel 通过Type来指定不同标的：
%[errorCode, errorMsg,packet] = EntrustCancel(connection,token,combiNo,entrustNo,type)
%type :   1 证券
%         2 期货
%         3 期权
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    if ~exist('type', 'var')
        type = 1;
    end
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,combiNo,entrustNo,type)); 
    cancelNo = -1;
    if errorCode == 0
        cancelNo = GetEntrustNo(packet);    
    end  
end

%type :   1 证券
%         2 期货
%         3 期权
function [message] = MakeRequestPacket(token,combiNo,entrustNo,type)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    if type == 1
        functionID = '91101';
    elseif type == 2
        functionID = '91105';
    elseif type == 3
        functionID = '91106';
    end
    message.prepare(Tagdef.REQUEST_PACKET, functionID);
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