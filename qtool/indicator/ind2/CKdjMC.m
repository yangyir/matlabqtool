classdef CKdjMC < handle
    % ��������kdj, C��ʾ��ʾָ��д������
    %�봫ͳkdj��֮ͬ���ж���
    %               ���ԭ@ind�µ�ָ��kdj����Ӳ���maType��1Ϊ��ƽ����2Ϊָ��ƽ��;
    %               ͬʱ����ԭpara1,para2,para3,para4�����޸ġ�
    % ����kdjֵ
    % ����
    %�����ݡ�ClosePrice,HighPrice,Lowprice
    %�������� nday�ƶ�ƽ��������������Ȼ����
    %�����kdj �����kdjֵ
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.25
    
    
    properties
        bars ;
        latest ;
        k ;
        d ;
        j ;
        nday ;
        m ;
        l ;
        maType ;
        c_l ;
        h_l ;
        
        
        
        
    end
    
    %%
    methods
        %% ��ʼ��
        function obj = CKdjMC(bars, nday, m, l ,maType )
            obj.bars    = bars ;
            obj.latest  = bars.time(end) ;
            obj.nday    = nday ;
            obj.m       = m ;
            obj.l       = l ;
            obj.maType = maType ;
            
            [obj.k,obj.d,obj.j] = ind.kdjMC( bars.close, bars.high , bars.low,nday, m, l, maType ) ;
            
            
            llv         = llow( obj.bars.low, nday );
            hhv         = hhigh( obj.bars.high, nday );
            
            obj.c_l     = obj.bars.close - llv   ;
            obj.h_l     = hhv - llv ;
 
            
            
            
        end
        
        
        
        %% ������������
        function  kdjAdd(obj)
            
            if obj.bars.time(end) > obj.latest
                
                
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;

                [nPeriod] = size(obj.bars.close, 1);
                
                nAdd = nPeriod - nStart ;
                
                obj.k       = [ obj.k ; nan(nAdd,1) ] ;
                obj.d       = [ obj.d ; nan(nAdd,1) ] ;
                obj.j       = [ obj.j ; nan(nAdd,1) ] ;
                obj.c_l     = [ obj.c_l ; nan(nAdd,1) ] ;
                obj.h_l     = [ obj.h_l ; nan(nAdd,1) ] ;
                
                
                para1=(obj.m-1)/(obj.m+1);
                para2=2/(obj.m+1);
                para3 = (obj.l-1)/obj.l;
                para4 = 1/obj.l;
                
                
                
                for i = nStart+1:nPeriod
                    
                    obj.c_l(i)          = (obj.bars.close(i) - min(obj.bars.low(end-obj.nday+1:end,1) ));
                    obj.h_l(i)          = (max(obj.bars.high(end-obj.nday+1:end,1) ) -min(obj.bars.low(end-obj.nday+1:end,1) ) );
                    
                    switch obj.maType
                        case 1
                            obj.k(i)            = sum( obj.c_l( i - obj.m +1 : i ) )/sum( obj.h_l( i - obj.m +1 : i ) ) * 100 ;
                            obj.d(i)            = sum( obj.k( i - obj.l +1 : i ) )/obj.l ;
                        case 2
                            
                            
                            rsvi            = ( obj.c_l(i) )./( obj.h_l(i) ) * 100;
                            obj.k(i)        = para1*obj.k(i-1)+para2*rsvi;
                            obj.d(i)        = para3*obj.d(i-1)+para4*obj.k(i);
                            
                            
                    end ;
                    obj.j(i)=3*obj.d(i)-2*obj.k(i);
                    
                    
                    
                    
                end ;
                obj.latest = obj.bars.time(end) ;
                
            end;
            
        end
    end
    
end 
    
    
