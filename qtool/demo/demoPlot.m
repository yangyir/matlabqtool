function [  ] = demoPlot( price, currIndex, range, label, varargin )
%% Illustration for position operations.
%
if currIndex<=range
    error('current position should be larger than range');
end

if isa(label, 'char')
    if nargin ==4
        if strcmp(label,'OpenHigh')
            waterLine = max(price(currIndex-range:currIndex-1));
            Ftitle = 'break high water, open long position';
            Flegend = ([num2str(range) 'mins high']);
        elseif strcmp(label,'OpenLow')
            waterLine = min(price(currIndex-range:currIndex-1));
            Ftitle = 'break low water,  open short position';
            Flegend = ([num2str(range) 'mins low']);
        elseif strcmp(label,'CloseHigh')
            waterLine = max(price(currIndex-range:currIndex-1));
            Ftitle = 'break high water, close position';
            Flegend = ([num2str(range) 'mins high']);
        elseif strcmp(label,'CloseLow')
            waterLine = min(price(currIndex-range:currIndex-1));
            Ftitle = 'break low water, close position';
            Flegend = ([num2str(range) 'mins low']);
        elseif strcmp(label,'FlopHigh')
            waterLine = max(price(currIndex-range:currIndex-1));
            Ftitle = 'break high water, flop position';
            Flegend = ([num2str(range) 'mins high']);
        elseif strcmp(label,'FlopLow')
            waterLine = min(price(currIndex-range:currIndex-1));
            Ftitle = 'break low water, flop position';
            Flegend = ([num2str(range) 'mins low']);
        else
            error('label type error!');
        end
        
        plot(waterLine*ones(range+2,1),'r','LineWidth',2);
        hold on
        plot(price(currIndex-range:currIndex),'b','LineWidth',2);
        hold on
        plot(range+1,price(currIndex),'r*');
        title(Ftitle);
        legend(Flegend,'price','currPrice','Location','NorthWest');
        hold off
    elseif nargin == 5
        lastEnterPrice = varargin{1};
        if strcmp(label,'AddLong')
            Ftitle = 'Keep going up, add long position';
        elseif strcmp(label,'AddShort')
            Ftitle = 'Keep going down, add short position';
        end
        plot(price(currIndex-range:currIndex),'b','LineWidth',2);
        hold on
        plot(range+1,price(currIndex),'r*');
        hold on
        plot(range+1,lastEnterPrice,'b*');
        title(Ftitle);
        legend('price','currPrice','last enter price','Location','NorthWest');
        hold off
    end
else
    waterLine = label;
    Ftitle = 'touch stop loss, close position';
    Flegend = ('stoploss');
    plot(waterLine*ones(range+2,1),'r','LineWidth',2);
    hold on
    plot(price(currIndex-range:currIndex),'b','LineWidth',2);
    hold on
    plot(range+1,price(currIndex),'r*');
    hold on
    plot(range+1,varargin{1},'b*')
    title(Ftitle);
    legend(Flegend,'Price','currPrice','enterPrice', 'Location','NorthWest');
    hold off
end


end

