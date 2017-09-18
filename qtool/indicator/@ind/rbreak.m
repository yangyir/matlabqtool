function [ rval ] = rbreak( bars,  pivottype)
%rbreak ���㵱ǰbar���������Ծ��루�����ǰһ�����high-low��
%   inputs��
%       pivottype��'high' ����Ϊǰһ��ߵ㣻
%                  'low'  ����Ϊǰһ��͵㣻
%                  'close'����Ϊǰһ�����̣�
%                  'open' ����Ϊ���쿪�̣�Ĭ�ϣ���
%   output��
%       rval����ǰbar��(close-pivot)/range��(high-pivot)/range(����Ϊhigh��

if ~exist('pivottype', 'var'), pivottype = 'open'; end;

nbars = length(bars.close);
pivot = nan(nbars, 1); range = nan(nbars, 1);
prehigh = bars.high(1); prelow = bars.low(1);  %��ʼ����¼����

for ibar = 2: nbars
    if floor(bars.time(ibar)) - floor(bars.time(ibar-1)) >= 1 % �����µ�һ��
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

