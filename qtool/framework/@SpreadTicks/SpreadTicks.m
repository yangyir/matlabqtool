classdef SpreadTicks<Ticks
    %SPREADTICK ����Ticks�࣬��¼spread����ָ��A��B��ָ��
    % �涨Spread Ϊ ticksA - ticksB��
    % ���䳬��140801
    % �̸գ�140805������obj.askV, obj.bidV�ļ���
    
    properties
        ticksA;
        ticksB;
    end
    
    methods
        % constructor
        function [ obj ] = SpreadTicks( len, ticksA,ticksB )
            %SpreadTicks ��ʼ��
            
            % ���䳬��20140801��V1.0
            obj = obj@Ticks();
            
            % 
            if ~exist('len', 'var'), len = 32400; end
            if exist('ticksA', 'var') && exist('ticksB', 'var')
                obj.ticksA = ticksA;
                obj.ticksB = ticksB;
                obj.code = [ticksA.code '-' ticksB.code];
            end         

            

            obj.type = 'spread';
            obj.last = nan(len,1);
            obj.askP = nan(len,1);
            obj.bidP = nan(len,1);
            obj.askV = nan(len,1);
            obj.bidV = nan(len,1);
            obj.time = nan(len,1);
            obj.latest = 0;
        end
        
        % ����������ʹ�ã�ÿ����������
        function [] = update(obj)
            % ����ָ�룬Ϊ����
            a = obj.ticksA;
            b = obj.ticksB;
            
            al = a.latest;
            bl = b.latest;
            if al == 0||bl == 0,  return;  end
            
            obj.latest  = obj.latest + 1;
            ol          = obj.latest;
            
            obj.time(ol)    = max( a.time(al), b.time(bl) );
            obj.last(ol)    = a.last(al)     - b.last(bl);
            obj.askP(ol,1)  = a.askP(al,1)   - b.bidP(bl,1);
            obj.bidP(ol,1)  = a.bidP(al,1)   - b.askP(bl,1);
            
            % ��ʱ�������Ϊ�е�ʱ��û��Volume
            try
            obj.askV(ol,1)  = min(a.askV(al,1), b.bidV(bl,1));
            obj.bidV(ol,1)  = min(a.bidV(al,1), b.bidV(bl,1));
            catch e
                fprintf('����Spread����Volume����������\n');
            end           
        end
        
        
        % ����spread��ƽʱʹ��
        
        
    end
    
end

