classdef SpreadTicks<Ticks
    %SPREADTICK 基于Ticks类，记录spread，有指向A，B的指针
    % 规定Spread 为 ticksA - ticksB。
    % 潘其超，140801
    % 程刚，140805；加入obj.askV, obj.bidV的计算
    
    properties
        ticksA;
        ticksB;
    end
    
    methods
        % constructor
        function [ obj ] = SpreadTicks( len, ticksA,ticksB )
            %SpreadTicks 初始化
            
            % 潘其超，20140801，V1.0
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
        
        % 生产环境中使用，每个心跳调用
        function [] = update(obj)
            % 两个指针，为方便
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
            
            % 有时会出错，因为有的时候没有Volume
            try
            obj.askV(ol,1)  = min(a.askV(al,1), b.bidV(bl,1));
            obj.bidV(ol,1)  = min(a.bidV(al,1), b.bidV(bl,1));
            catch e
                fprintf('计算Spread出错：Volume数据有问题\n');
            end           
        end
        
        
        % 生成spread，平时使用
        
        
    end
    
end

