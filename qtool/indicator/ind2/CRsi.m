classdef CRsi < handle
    % ��������rsi, C��ʾ��ʾָ��д������
    % Relative Strength Index ���ǿ��ָ��
    % ����rsi��rs����ֵ��[nPeriod] ���󣩣���ΪԪ������ֻ���㵥�ʲ�
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.22
    
    
    properties
        bars ;
        nDay ;
        latest ;
        rsiVal ;
        rsVal ;
        
    end
    
    %%
    methods
        %% ��ʼ��
        function obj = CRsi( bars, nDay)
            obj.bars = bars ;
            obj.nDay = nDay ;
            obj.latest = bars.time(end) ;
            [ obj.rsiVal, obj.rsVal] = ind.rsi( bars.close, nDay) ;
            
        end
        
        
        
        %% ������������
        function  rsiNew(obj)
            
            if obj.bars.time(end) > obj.latest
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
                [nPeriod] = size(obj.bars.close, 1);
                nNew = nPeriod - nStart ;
                
                obj.rsiVal = [obj.rsiVal ; nan(nNew,1) ] ;
                obj.rsVal = [obj.rsVal ; nan(nNew,1) ] ;
                
                diffClose = [nan(1,1);  diff(obj.bars.close)];
                diffChg   = abs(diffClose);
                advances = diffChg;
                declines = diffChg;
                advances(diffClose < 0 ) = 0;
                declines(diffClose > 0 ) = 0;
                
                
                for jPeriod = nStart+1 : nPeriod
                    totalGain = sum(advances(jPeriod - obj.nDay+1:jPeriod,:));
                    totalLoss = sum(declines(jPeriod - obj.nDay+1:jPeriod,:));
                    obj.rsVal(jPeriod,1) = totalGain./totalLoss;
                    obj.rsiVal(jPeriod,1) = 100 - (100./(1+obj.rsVal(jPeriod,1)));
                end
                
                obj.latest = obj.bars.time(end) ;
            end ;
            
            
        end;
        
    end
end


