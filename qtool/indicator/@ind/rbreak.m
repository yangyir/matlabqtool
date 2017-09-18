function [ rval ] = rbreak( bars,  pivottype)
%rbreak 计算当前bar和中枢的相对距离（相对于前一天振幅high-low）
%   inputs：
%       pivottype：'high' 中枢为前一天高点；
%                  'low'  中枢为前一天低点；
%                  'close'中枢为前一天收盘；
%                  'open' 中枢为当天开盘（默认）；
%   output：
%       rval：当前bar的(close-pivot)/range或(high-pivot)/range(中枢为high）

if ~exist('pivottype', 'var'), pivottype = 'open'; end;

nbars = length(bars.close);
pivot = nan(nbars, 1); range = nan(nbars, 1);
prehigh = bars.high(1); prelow = bars.low(1);  %初始化记录变量

for ibar = 2: nbars
    if floor(bars.time(ibar)) - floor(bars.time(ibar-1)) >= 1 % 进入新的一天
        switch pivottype
            case 'high'
                pivot(ibar) = prehigh;
            case 'low'
                pivot(ibar) = prelow;
            case 'close'
                pivot(ibar) = bars.close(ibar-1);
            case 'open'
                pivot(ibar) = bars.open(ibar);
        end
        
        range(ibar) = prehigh - prelow;
        prehigh = bars.high(ibar); prelow = bars.low(ibar);
    else
        pivot(ibar) = pivot(ibar - 1);
        range(ibar) = range(ibar - 1);
        prehigh = max(prehigh, bars.high(ibar));
        prelow  = min(prelow,  bars.low(ibar));
    end
    
end

switch pivottype
    case 'high'
        rval = (bars.high - pivot)./ range;
    case 'low'
        rval = (bars.low - pivot)./ range;
    case 'close'
        rval = (bars.close - pivot)./ range;
    case 'open'
        rval = (bars.close - pivot)./ range;
end
        
end

