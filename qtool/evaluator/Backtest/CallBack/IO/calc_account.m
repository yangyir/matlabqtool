%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于期货每天成交量、持有量和资产总值。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [volume,account,tradingCost,accountNoCost,position] = calc_account(bars,signal,configure)
%% resolve input parameter.

multiplier = configure.multiplier;
leverage = configure.leverage;
cost = configure.cost;
lag = configure.lag;
style = configure.orderStyle;

if lag<1
    error('Lag must be a positive integer.');
end
signal = [zeros(lag,1);signal(1:end-lag)];
len = length(bars.time);
volume = zeros(len,2);
account = configure.initValue*ones(len,1);
cash = account;
tradingCost = zeros(len,1);
position = zeros(len,1);

%%
oprnSignal = [0;diff(signal)];
for i = lag+1:len
    if oprnSignal(i)~=0 
       if lag == 1
            airOrder = 0;
        else
            airOrder = sum(volume(i-lag+1:i-1,2));
        end
        if style == 1
            if position(i-lag)+airOrder == 0
                if oprnSignal(i)>0
                    volume(i,2) = 1;
                else
                    volume(i,2) = -1;
                end
            elseif position(i-lag)+airOrder>0
                if oprnSignal(i)>0
                    volume(i,2) = 0;
                elseif oprnSignal(i)<-1
                    volume(i,2) = -2;
                else
                    volume(i,2) = -1;
                end
            else
                if oprnSignal(i)<0
                    volume(i,2) = 0;
                elseif oprnSignal(i)>1
                    volume(i,2) = 2;
                else
                    volume(i,2) = 1;
                end           
            end
        else
            if position(i-lag)+airOrder==0
                volume(i,2) = fix(account(i-lag)*oprnSignal(i)/bars.close(i-lag)/multiplier*leverage);
            elseif position(i-lag)+airOrder>0
                if oprnSignal(i)>0
                    volume(i,2) = fix(account(i-lag)*oprnSignal(i)/bars.close(i-lag)/multiplier*leverage);
                else
                    volume(i,2) = round(position(i-lag)*oprnSignal(i));
                end
            else
                if oprnSignal(i)<0
                    volume(i,2) = fix(account(i-lag)*oprnSignal(i)/bars.close(i-lag)/multiplier*leverage);
                else
                    volume(i,2) = -round(position(i-lag)*oprnSignal(i));
                end
            end
        end
        
        volume(i,1) = volume(i,2)*bars.open(i)*multiplier;
        position(i) = position(i-1)+volume(i,2);
        tradingCost(i) = abs(volume(i,1)*cost);
        cash(i) = cash(i-1)-volume(i,1)-tradingCost(i);
        account(i) = cash(i)+bars.close(i)*position(i)*multiplier;
    else
        volume(i,2)=0;
        volume(i,1)=0;
        position(i) = position(i-1);
        tradingCost(i) = 0;
        cash(i) = cash(i-1);
        account(i) = cash(i)+bars.close(i)*position(i)*multiplier;
    end
    
end
accountNoCost = account+cumsum(tradingCost);
end