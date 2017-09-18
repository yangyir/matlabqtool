function [ret] = withdrawEntrust(obj, entrust)
%function [ret] = withdrawEntrust(obj, entrust)

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
        
        [errorCode, errorMsg,cancelNo] = obj.optEntrustCancel( eNo);
        if errorCode ~= 0
            disp(['����ʧ�ܡ�������ϢΪ:',errorMsg]);
            return;
        else
            entrust.cancelNo = cancelNo;
            entrust.entrustStatus = entrust.entrustStatus + 1;
            ret = true;
        end
        
    case 'ETF'
        
        [errorCode, errorMsg,cancelNo] = obj.entrustCancel( entrust.entrustNo);
        if errorCode ~= 0
            disp(['����ʧ�ܡ�������ϢΪ:',errorMsg]);
            return;
        else
            entrust.cancelNo = cancelNo;
            entrust.entrustStatus = entrust.entrustStatus + 1;
            ret = true;
        end
        
    case 'Future'
        [errorCode, errorMsg,cancelNo] = obj.futEntrustCancel( entrust.entrustNo);
        if errorCode ~= 0
            disp(['����ʧ�ܡ�������ϢΪ:',errorMsg]);
            return;
        else
            entrust.cancelNo = cancelNo;
            entrust.entrustStatus = entrust.entrustStatus + 1;
            ret = true;
        end
        
end

end