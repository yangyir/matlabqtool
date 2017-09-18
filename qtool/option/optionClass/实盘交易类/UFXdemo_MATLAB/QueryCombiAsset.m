function [errorCode, errorMsg,packet] = QueryCombiAsset(connection,token,accountCode,combiNo,marketNo,stockCode,type)
% QueryCombiAsset 通过Type来指定不同标的：
%[errorCode, errorMsg,packet] = QueryCombiAsset(connection,token,accountCode,combiNo,marketNo,stockCode,type)
%type :   1 证券
%         2 期货
%         3 期权
import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    if ~exist('type', 'var')
        type = 1;
    end
    [errorCode, errorMsg,packet] = CallService(connection,MakeRequestPacket(token,accountCode,combiNo,marketNo,stockCode,type)); 
end

function [message] = MakeRequestPacket(token,accountCode,combiNo,marketNo,stockCode,type)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %持仓查询功能号：证券：31001；期货：31003；期权：31004
    if type == 1
        functionID = '31001';
    elseif type == 2
        functionID = '31003';
    elseif type == 3
        functionID = '31004';
    end
    message.prepare(Tagdef.REQUEST_PACKET,functionID);
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