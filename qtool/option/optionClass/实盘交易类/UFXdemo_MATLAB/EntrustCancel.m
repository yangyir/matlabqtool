function [errorCode, errorMsg,cancelNo] = EntrustCancel(connection,token,combiNo,entrustNo,type)
% EntrustCancel ͨ��Type��ָ����ͬ��ģ�
%[errorCode, errorMsg,packet] = EntrustCancel(connection,token,combiNo,entrustNo,type)
%type :   1 ֤ȯ
%         2 �ڻ�
%         3 ��Ȩ
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

%type :   1 ֤ȯ
%         2 �ڻ�
%         3 ��Ȩ
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
    %�Ǳش��ֶΣ���������˵�������Բ��������ɶ����룬����ϯλ��    
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);
    ds.addField('combi_no',FieldType.DATATYPE_STRING,20,0);    %��ϱ��
    ds.addField('entrust_no',FieldType.DATATYPE_INT,0,0);
    ds.addStr(token);
    ds.addStr(combiNo);
    ds.addInt(entrustNo);
    message.setMsgBodyTag(ds, PackService.VERSION_2)
end

function [entrustNo] = GetEntrustNo(packet)
    entrustNo = packet.getInt('entrust_no');
end