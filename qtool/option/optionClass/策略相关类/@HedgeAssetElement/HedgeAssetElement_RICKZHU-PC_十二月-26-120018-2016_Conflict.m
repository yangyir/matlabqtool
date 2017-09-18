classdef HedgeAssetElement < handle
    % HedgeAssetElement ����һ��Asset Quote
    % ����һЩHedge�������Լ��
    % ����������ơ�
    % ÿ������
    % ����
    % ����Ĭ�ϵ��Զ����򡣸ù���Ϊ������ǰ���¼۹ҵ�����max(1, min(target_vol, min(10, 1/2�̿���)))�ҵ���
    properties
        asset_quote_ = [];
        max_size_ = 10;
        target_vol_ = 0;
        direction_ = 'buy';
        offset_ = 'open';
        auto_@logical = true;
    end
    
    methods
        function [obj] = initHedgeElement(obj, quote, max_size, target_vol, dir, offset, auto)
            % function [obj] = initHedgeElement(obj, quote, max_size, target_vol, dir, offset, auto)
            % quote, ����quote����
            % 
            obj.asset_quote_ = quote;
            obj.max_size_ = max_size;
            obj.target_vol_ = target_vol;
            obj.direction_ = dir;
            obj.offset_ = offset;
            obj.auto_ = auto;
        end
        
        function [ret, e] = generate_entrust(obj) 
            % [ret, e] = generate_entrust(obj) 
            % ���ݹ�����ί�е���
            if obj.target_vol_ > 0
                quote = obj.asset_quote_;
                quote.fillQuote;
                px = quote.last;
                fireline_vol = 0;
                if (abs(px - quote.bidP1) < 0.00001)
                    fireline_vol = quote.bidQ1;
                end
                
                if (abs(px - quote.askP1) < 0.00001)
                    fireline_vol = quote.askQ1;
                end
                
                vol = max(1, min(obj.target_vol_, min(10, fireline_vol / 2)));
                e = Entrust;
                mktNo = '1';
                e.fillEntrust(mktNo, quote.code, obj.direction_, px, vol, obj.offset_, quote.getName);
                ret = true;
                return;
            else
                e = Entrust;
                ret = false;
            end            
        end
        
        function [obj] = update_entrust(obj, e)
            obj.target_vol_ = obj.target_vol_ - e.dealVolume;
        end
        
        
    end
end