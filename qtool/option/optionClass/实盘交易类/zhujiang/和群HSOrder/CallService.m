function [errorCode, errorMsg, packet] = CallService(connection,requestPacket)
    [requestId] = GetRequestID();    
    %requestId = '1';
    if ~connection.send(requestPacket,requestId , 30000)    
        errorCode = -1;
        errorMsg = '发送请求失败';
    end 
    response = connection.receive(requestId);
    [errorCode, errorMsg, packet] = CheckError(response);
end

function [requestId] = GetRequestID()
    %多线程环境下需要加锁
    persistent reqeustIdSeed;
    if isempty(reqeustIdSeed)
        reqeustIdSeed = 1;
    end
    reqeustIdSeed = reqeustIdSeed + 1;
    requestId = num2str(reqeustIdSeed);
end

function [errorCode,errorMsg,packet] = CheckError(response)
    import com.hundsun.esb.data.* com.hundsun.esb.impl.*;
    buff = response.getRawdataTag(Tagdef.TAG_MESSAGE_BODY);    
    if ~isempty(buff) 
        ds = PackService.getPacker(buff);
        %disp(['datasetCount:',num2str(ds.getDatasetCount())]);
        packet = ds.getResultSet(0);                
        packet.setCurrRow(0);
        %PrintPacket(packet);
        errorCode = packet.getInt('ErrorCode');
        errorMsg  = char(packet.getStr('ErrorMsg'));   
        if ds.getDatasetCount() > 1
            packet = ds.getResultSet(1);
            packet.setCurrRow(0);
            %PrintPacket(packet);
        end    
    else
        errorCode = -1;
        errorMsg = 'TAG_MESSAGE_BODY is empty!';      
    end    
end


