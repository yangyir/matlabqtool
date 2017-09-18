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
            warning('������entrustNo������');
            return;
        end
        if isnan(eNo)
            warning('������entrustNo������');
            return;
        end
        
        try
            [errorCode,errorMsg,packet] = obj.queryOptEntrusts(eNo);
            if errorCode < 0
                disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
                entrust.fill_entrust_query_packet_HSO32(packet);
                entrust.entrustStatus = entrust.entrustStatus + 1;
                ret = true;
            end
            
        catch
            disp('��ѯʧ��');
            
        end        
    case 'ETF'
        [errorCode,errorMsg,packet] = obj.queryEntrusts(entrust.entrustNo);
        if errorCode ~= 0
            disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);
            return;
        else
            entrust.fill_entrust_query_packet_HSO32(packet);
            entrust.entrustStatus = entrust.entrustStatus + 1;
            ret = true;
        end        
    case 'Future'
        eNo =  entrust.entrustNo;
        if isempty(eNo)
            warning('������entrustNo������');
            return;
        end
        if isnan(eNo)
            warning('������entrustNo������');
            return;
        end
        
        try
            [errorCode,errorMsg,packet] = obj.queryFutEntrusts(eNo);
            if errorCode < 0
                disp(['��ί��ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
                %                 disp('-------------ί����Ϣ--------------');
                %                 PrintPacket2(packet); %��ӡί����Ϣ
                entrust.fill_entrust_query_packet_HSO32(packet);
                entrust.entrustStatus = entrust.entrustStatus + 1;
                ret = true;
            end            
        catch
            disp('��ѯʧ��');
        end        
end


end