classdef CRsiMC < handle
    % ��������rsi, C��ʾ��ʾָ��д������
    % Relative Strength Index ���ǿ��ָ��
    % ����rsi��rs����ֵ��[nPeriod] ���󣩣���ΪԪ������ֻ���㵥�ʲ�
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.22
    
    
    properties
        bars ;
        nDay ;
        latest ;
        rsi ;
        var0 ; 
        var1 ; 
        var4 ; 
        
        
    end
    
    %%
    methods
        %% ��ʼ��
        function obj = CRsiMC( bars, nDay)
            obj.bars = bars ;
            obj.nDay = nDay ;
            obj.latest = bars.time(end) ;
            [ obj.rsi, obj.var0, obj.var1, obj.var4 ] = ind.rsiMC( bars, nDay) ;
            
        end
        
        
        
        %% ������������
        function  rsiMCAdd(obj)
            
            if obj.bars.time(end) > obj.latest
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
                [nPeriod] = size(obj.bars.close, 1);
                nAdd = nPeriod - nStart ;
                
                vclose = obj.bars.close ;
                difclose = [nan ; diff(vclose) ] ;
                absDifClose = abs(difclose) ;
                
                obj.var0 = [ obj.var0; nan( nAdd, 1 ) ] ;
                obj.var1 = [ obj.var1; nan( nAdd, 1 ) ];
                obj.var4 = [ obj.var4; nan( nAdd, 1 ) ];
                obj.rsi  = [ obj.rsi ; nan( nAdd, 1 ) ] ;
                
                for i = nStart+1:nPeriod
                    obj.var0(i,1) = obj.var0(i-1,1) + ( difclose(i,1) - obj.var0(i-1,1))/obj.nDay ;
                    obj.var1(i,1) = obj.var1(i-1,1) + ( absDifClose(i,1) - obj.var1(i-1,1) )/obj.nDay ;
                    if obj.var1(i,1) ~= 0
                        obj.var4(i,1) = obj.var0(i,1)/obj.var1(i,1) ;
                    else
                        obj.var4(i,1) = 0 ;
                    end;
                end ;
                
                obj.rsi(nStart+1:nPeriod) =  50 * ( obj.var4(nStart+1:nPeriod) + 1 ) ;
                
                obj.latest = obj.bars.time(end) ;
            end ;
            
            
        end;
        
    end
end


