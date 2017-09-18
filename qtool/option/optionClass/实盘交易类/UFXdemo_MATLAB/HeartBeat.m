function [heartbeatTimer] = HeartBeat(connection,token)  
  heartbeatTimer = timer('TimerFcn',@OnTimer,'Period',180,'ExecutionMode','fixedSpacing');
  ud = struct('a',connection,'b',token);
  set(heartbeatTimer,'UserData',ud);
  start(heartbeatTimer);
end

function OnTimer(obj,~)
    import com.hundsun.esb.*  com.hundsun.esb.data.*; 
    ud=obj.UserData;
    connection = ud.a;
    token      = ud.b;
    [errorCode, errorMsg] = CallService(connection,MakeRequestPacket(token));   
    if errorCode < 0        
        disp(['向服务器发送心跳包失败。错误信息为:',errorMsg]);
    end  
end

function [message] = MakeRequestPacket(token)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    message = javaObject('com.hundsun.esb.data.EsbMessage');
    %心跳功能号：10000
    message.prepare(Tagdef.REQUEST_PACKET,'10000');
    ds = javaObject('com.hundsun.esb.data.ResultSet');
    ds.addField('user_token',FieldType.DATATYPE_STRING,512,0);    
    ds.addStr(token);  
    message.setMsgBodyTag(ds, PackService.VERSION_2);
end