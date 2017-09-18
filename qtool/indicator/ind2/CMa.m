classdef CMa < handle
    % ��������ma, C��ʾ��ʾָ��д������
    % Moving Average
    % [maVal] = ma(price,lag,flag)
    % price����������ʲ��۸�����
    % lag��   �ͺ���� ��Ĭ�� 10��
    % flag��  MA���㷽��
    %         e = ָ���ƶ�ƽ��
    %         0 = ���ƶ�ƽ��
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.23
    
    
    properties
        bars ;
        latest ;
        price ; 
        lag ;
        flag ; 
        maVal ;
 
        
    end
    
    %%
    methods
        %% ��ʼ��
        function obj = CMa( bars, price, lag, flag )
            
            obj.bars    = bars ;
            
            if isempty(bars.latest )
                obj.latest  = bars.time(end) ;
            else 
                obj.latest  = bars.time(bars.latest) ;
            end ;
            
            obj.price   = price ; 
            obj.lag     = lag ;
            obj.flag    = flag ; 
            
            obj.maVal = ind.ma( price, lag, flag ) ; 
            
        end
        
        
        
        %% ������������
        function  maAdd(obj)
            
            % ����Ҫ����
            if isempty(obj.bars.latest )
                timeNow = obj.bars.time(end) ;
            else 
                timeNow = obj.bars.time(obj.bars.latest) ;
            end ;
            
            % �¾�Ҫ����
            if timeNow > obj.latest
                
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
                % ���Ҫ����
                if isempty(obj.bars.latest )
                    [nPeriod] = size(obj.bars.close, 1);
                    obj.latest = obj.bars.time(end) ;
                else 
                    [nPeriod] = obj.bars.latest;
                    obj.latest = obj.bars.time(obj.bars.latest) ;
                end ;
            
                nNew = nPeriod - nStart ;
                
                obj.maVal = [obj.maVal ; nan(nNew,1) ] ;
                
                param = 2/( obj.lag+1 );
                
                for jPeriod = nStart+1 : nPeriod
                    if obj.flag == 'e'
                        obj.maVal(jPeriod,1) = obj.maVal(jPeriod-1,1) + param*(obj.price(jPeriod,1)- obj.maVal(jPeriod-1,1));
                    elseif obj.flag == 0
                        obj.maVal(jPeriod,1) = obj.maVal(jPeriod-1,1) + 1/obj.lag*( obj.price(jPeriod,1) - obj.price(jPeriod - obj.lag ,1 ) );
                    end ; 
                    
                end; 
 
                
                
            end ;
            
            
        end;
        
    end
end


