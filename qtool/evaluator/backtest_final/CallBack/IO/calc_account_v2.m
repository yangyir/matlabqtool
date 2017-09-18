%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����������ڻ�ÿ��ɽ��������������ʲ���ֵ��

% LXY, 2013/08/21 ��������Թ�ָ�ڻ��ĵ�����ģʽ
% ���ܣ����ݸ�����signal�͵�ʱ���ֽ���������
% �������µ�signal���Լ���Ӧ��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [volume,account,tradingCost,accountNoCost,position,signal_adj] =...
    calc_account_v2(bars,signal,configure)
%% resolve input parameter.

multiplier = configure.multiplier;
leverage = configure.leverage;
cost = configure.cost;
lag = configure.lag;
style = configure.orderStyle;
%safepos = configure.safepos;

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
    % product volume(:,2)

    if signal(i)~=signal(i-1) 
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
        elseif style == 2           
           % highest = fix(account(i-1)/safepos/multiplier/bars.close(i-1));
            %if highest<abs(signal(i))
               % num_last_adjust = find(abs(signal(i:len))<highest,1)+i-2;
               % signal(i:num_last_adjust) = signal(i:num_last_adjust) -...
                 %   signal(i) + highest*sign(signal(i));
            %end
            % ���ʲ������������
           %lowest = fix(account(i-1)/multiplier/bars.close(i-1));
            %signal_tmp = signal(i:end);
           % if min(abs(signal_tmp(signal_tmp~=0)))<lowest
               % add = lowest - min(abs(signal_tmp(signal_tmp~=0)));
               % signal_tmp(signal_tmp>0) = signal_tmp(signal_tmp>0) + add;
               % signal_tmp(signal_tmp<0) = signal_tmp(signal_tmp<0) - add;
               % signal(i:end) = signal_tmp;
               % signal = min(signal,configure.max_open);
               % signal = max(signal,-configure.max_open);
           % end
            
            volume(i,2) = signal(i) - signal(i-1);
            
        elseif style == 3
            if position(i-lag)+airOrder == 0
                vol_tmp = fix(account(i-1)*signal(i)/...
                    multiplier/bars.close(i-1));
                vol_tmp = sign(vol_tmp)*min(abs(vol_tmp),configure.max_open);
                volume(i,2) = vol_tmp;
            elseif position(i-lag)+airOrder>0
                if signal(i)>signal(i-1)
                    vol_tmp = fix(account(i-1)*signal(i)/...
                        multiplier/bars.close(i-1)) - position(i-1);
                    vol_tmp = min(vol_tmp,configure.max_open-position(i-1));
                    volume(i,2) = vol_tmp;
                elseif signal(i)<0
                    vol_tmp = fix(account(i-1)*signal(i)/...
                        multiplier/bars.close(i-1)) - position(i-1);
                    vol_tmp = max(vol_tmp,-configure.max_open-position(i-1));
                    volume(i,2) = vol_tmp;
                else
                    volume(i,2) = fix(account(i-1)*signal(i)/...
                        multiplier/bars.close(i-1)) - position(i-1);
                end
            else
                if signal(i)<signal(i-1)
                    vol_tmp = fix(account(i-1)*signal(i)/...
                        multiplier/bars.close(i-1)) - position(i-1);
                    vol_tmp = max(vol_tmp,-configure.max_open-position(i-1));
                    volume(i,2) = vol_tmp;
                elseif signal(i)>0
                    vol_tmp = fix(account(i-1)*signal(i)/...
                        multiplier/bars.close(i-1)) - position(i-1);
                    vol_tmp = min(vol_tmp,configure.max_open-position(i-1));
                    volume(i,2) = vol_tmp;
                else
                    volume(i,2) = fix(account(i-1)*signal(i)/...
                        multiplier/bars.close(i-1)) - position(i-1);
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
        
        % product other outputs
        volume(i,1) = volume(i,2)*bars.open(i)*multiplier;        %���һ����һ���ǿղ֣��������
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
signal_adj = signal;
end