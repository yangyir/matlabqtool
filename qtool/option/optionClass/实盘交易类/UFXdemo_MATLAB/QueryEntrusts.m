function [errorCode, errorMsg,packet] = QueryEntrusts(connection,token,accountCode,combiNo,entrustNo,type)
% QueryEntrusts 通过Type来指定不同标的：
%[errorCode, errorMsg,packet] = QueryEntrusts(connection,token,accountCode,combiNo,entrustNo,type)
%type :   1 证券
%         2 期货
%         3 期权
% --------------------------
% 朱江，20160215

    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    if ~exist('type','var')
        type = 1;
    end
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,accountCode,combiNo,entrustNo,type)); 
end


function [message] = MakeRequestPacket(token,accountCode,combiNo,entrustNo,type)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %委托查询功能号：证券：32001；期货：32003；期权：32004；
    if type == 2
        functionID = '32003';
    elseif type == 3
        functionID = '32004';
    else 
        functionID = '32001';
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