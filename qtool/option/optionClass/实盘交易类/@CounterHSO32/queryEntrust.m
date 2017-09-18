function [ret] = queryEntrust(obj, entrust)
%function [ret] = queryEntrust(obj, e)

ret = false;
if ~isa(entrust, 'Entrust')
    return;
end

switch entrust.assetType
    case 'Option'
        eNo =  entrust.entrustNo;
        if isempty(eNo)
            warning('订单号entrustNo不存在');
            return;
        end
        if isnan(eNo)
            warning('订单号entrustNo不存在');
            return;
        end
        
        try
            [errorCode,errorMsg,packet] = obj.queryOptEntrusts(eNo);
            if errorCode < 0
                disp(['查委托失败。错误信息为:',errorMsg]);
                return;
            else
                entrust.fill_entrust_query_packet_HSO32(packet);
                entrust.entrustStatus = entrust.entrustStatus + 1;
                ret = true;
            end
            
        catch
            disp('查询失败');
            
        end        
    case 'ETF'
        [errorCode,errorMsg,packet] = obj.queryEntrusts(entrust.entrustNo);
        if errorCode ~= 0
            disp(['查委托失败。错误信息为:',errorMsg]);
            return;
        else
            entrust.fill_entrust_query_packet_HSO32(packet);
            entrust.entrustStatus = entrust.entrustStatus + 1;
            ret = true;
        end        
    case 'Future'
        eNo =  entrust.entrustNo;
        if isempty(eNo)
            warning('订单号entrustNo不存在');
            return;
        end
        if isnan(eNo)
            warning('订单号entrustNo不存在');
            return;
        end
        
        try
            [errorCode,errorMsg,packet] = obj.queryFutEntrusts(eNo);
            if errorCode < 0
                disp(['查委托失败。错误信息为:',errorMsg]);
                return;
            else
                %                 disp('-------------委托信息--------------');
                %                 PrintPacket2(packet); %打印委托信息
                entrust.fill_entrust_query_packet_HSO32(packet);
                entrust.entrustStatus = entrust.entrustStatus + 1;
                ret = true;
            end            
        catch
            disp('查询失败');
        end        
end


end