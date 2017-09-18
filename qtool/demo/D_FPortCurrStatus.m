clear;clc;
pause('off');
%%  A demonstration for FPortCurrStatus class.
% The strategy is simple: go short if price breaks 20 min low; go long if
% breaks 20 min high. Stop loss is set to 0.5% below(long) or above(short)
% enter price. Exit when break 10 min low(long position), or 10 min
% high(short position).
% We buy or sell short 1 contract to open a position, if price fluctuation
% is favorable and larger than 0.5%, we add 1 position(1 contract). We can
% hold as many as 5 position units.
% If price touches stop loss or exit level, close all position.

% Qichao Pan 2013/4/13 12:37 GMT+8
%% Initialize
% 60s close price of IF0Y00 in 2013/04/09
tic
price = importdata('sPrice.mat');

% Strategy parameters
enterRange = 20;
exitRange = 10;
stopLossLevel = 0.001;
addPosLevel = 0.005;
maxUnit = 5;
maxFundEmploymentRate = 0.90;
initValue = 2000000;
bankruptcy = 0;

% Instantiate a FPortCurrStatus class.
% parameter list is [market code, multiplier, margin rate,tick size,...
% commission rate, maximum price fluctuation rate, maximum fund employment rate]
indexF = FPortCurrStatus('IF',300,0.12,0.2,0.0001,0.1,0.9);
% set maximum position unit;
indexF.set_pos(maxUnit);

% initialize recording containers.
span = length(price);
account = initValue*ones(span,1);
position = zeros(span,1);
margin = zeros(span,1);
commission = zeros(span,1);

%% trade
for i = enterRange+1:span
    position(i) = position(i-1);
    currUnit = abs(indexF.currUnit);
    currP = price(i);
    if indexF.currUnit == 0
        % empty position
        if currP>max(price(i-enterRange:i-1))
            % go long
            demoPlot(price,i,enterRange,'OpenHigh');
            [position(i),~,commission(i)] = indexF.add_pos(currP,10);
            indexF.set_stopLoss(currP*(1-stopLossLevel));
            pause;
        elseif currP<min(price(i-enterRange:i-1))
            % go short
            demoPlot(price,i,enterRange,'OpenLow');
            [position(i),~,commission(i)] = indexF.add_pos(currP,-10);
            indexF.set_stopLoss(currP*(1+stopLossLevel));
            pause;
        end
    elseif indexF.currUnit >0
        % long position
        if currP<min(price(i-enterRange:i-1))
            % flop 
            demoPlot(price,i,enterRange,'FlopLow');
            [position(i),~,commission(i)] = indexF.cut_pos(currP,5);
            pause;
        else
            if currP<min(price(i-exitRange:i-1))
                % exit
                demoPlot(price,i,exitRange,'CloseLow');
                [position(i),~,commission(i)] = indexF.close_pos(currP);
                pause;
            elseif indexF.touch_stopLoss(currP)
                % stop loss
                demoPlot(price,i,exitRange,indexF.stopLoss(currUnit),indexF.enterPrice(currUnit));
                [position(i),~,commission(i)] = indexF.close_pos(currP);
                pause;
            elseif currP>indexF.enterPrice(currUnit)*(1+addPosLevel)
                % add
                demoPlot(price,i,enterRange,'AddLong',indexF.enterPrice(currUnit));
                [position(i),~,commission(i)] = indexF.add_pos(currP,10);
                indexF.set_stopLoss(currP*(1-stopLossLevel));
                pause;
            end
        end
    else
        if currP>max(price(i-enterRange:i-1))
            demoPlot(price,i,enterRange,'FlopHigh');
            [position(i),~,commission(i)] = indexF.flop_pos(currP,5);
            indexF.set_stopLoss(currP*(1-stopLossLevel));
            pause;
        else
            if currP>max(price(i-exitRange:i-1))
                demoPlot(price,i,exitRange,'CloseHigh');
                [position(i),~,commission(i)] = indexF.close_pos(currP);
                pause;
            elseif indexF.touch_stopLoss(currP)
                demoPlot(price,i,enterRange,indexF.stopLoss(currUnit),indexF.enterPrice(currUnit));
                [position(i),~,commission(i)] = indexF.close_pos(currP);
                pause;
            elseif currP<indexF.enterPrice(currUnit)*(1-addPosLevel)
                demoPlot(price,i,enterRange,'AddShort',indexF.enterPrice(currUnit));
                [position(i),~,commission(i)] = indexF.add_pos(currP,-10);
                indexF.set_stopLoss(currP*(1+stopLossLevel));
                pause;
            end
        end
    end
    
    margin(i) = abs(currP*position(i)*indexF.multiplier*indexF.marginRate);
    account(i) = account(i-1)+(currP-price(i-1))*position(i-1)*indexF.multiplier-commission(i);
    indexF.account = account(i);
    indexF.fundEmploymentRate = margin(i)/account(i);
    if indexF.fundEmploymentRate>1
        bankruptcy = 1;
        break;
    end
end
toc
plotyy(1:span, price, 1:span,account);
figure(2)
plotyy(1:span, account, 1:span, position);