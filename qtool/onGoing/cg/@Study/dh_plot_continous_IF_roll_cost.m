function [ rollCost ] = dh_plot_continous_IF_roll_cost( iNearby )
%DH_PLOT_CONTINOUS_IF_ROLL_COST ����ʷ��ĳ������Լ��roll effect

%   Detailed explanation goes here

%% Ԥ����
if ~exist('iNearby', 'var'), iNearby  = 1; end
switch iNearby
    case{1}
        IFcode = 'IF0Y00';
    case{2}
        IFcode = 'IF0Y01';
    case{3}
        IFcode = 'IF0Y02';        
    case{4}
        IFcode = 'IF0Y03';
    otherwise
        disp('����iNearbyӦΪ1��2��3��4');
        return;       
end

%% ���̼�����
tdayStr     = datestr(today,'yyyy-mm-dd');
datesStr    = DH_D_TR_MarketTradingday(3,'2010-04-16',tdayStr);

% ����17��ǰ����û�е��յ����ݣ������
if hour(now) < 17
    datesStr    = datesStr(1:end-1,:);
end
ifDates         = datenum(datesStr);

% Close����
ifClose         = nan(size(datesStr,1), 4);
ifClose(:,1)    = DH_Q_DQ_Future('IF0Y00',datesStr,'Close');
ifClose(:,2)    = DH_Q_DQ_Future('IF0Y01',datesStr,'Close');
ifClose(:,3)    = DH_Q_DQ_Future('IF0Y02',datesStr,'Close');
ifClose(:,4)    = DH_Q_DQ_Future('IF0Y03',datesStr,'Close');


%% �ҳ�settle dates��Ӧ��idxStl
code    = DH_E_FS_IF_ContiContr('IF0Y00',datesStr);
stlDate = datenum( DH_D_F_FLastDay(code) );
e       = stlDate == ifDates;
idxStl  = find(e==1);

% ��ʼ����IF0Y02��IF0Y03,��1��4��7��10�»�
if iNearby == 3 || iNearby ==4
    idxStl  = find(e==1 & mod(month(stlDate),3) == 1);
end


%% �Ʋֳɱ����Զ�ּ��㣩, �ڵ�����ǰ��4��

rollCost = nan(length(idxStl), 5);
switch(iNearby)
    % ʼ����IF0Y00���ڽ������Ʋ֣�����ǰ
    case{1}        
        for adv = 0:4
            rollCost(:, adv+1) = ifClose(idxStl - adv,iNearby+1) - ifClose(idxStl - adv,iNearby);
        end       
    
    % ��ʼ����IF0Y01, IF0Y02, IF0Y03���ڽ����պ��һ���Ʋ֣����ӳ�
    case{2,3,4}
        adv = 0;
        try
            rollCost(:, adv+1) = ifClose(idxStl + adv,iNearby+1) - ifClose(idxStl + adv,iNearby);
        end
        
        for adv = 1:4
            try % idxStl(end) + adv ���ܻ���δ��ʱ��
                rollCost(:, adv+1) = ifClose(idxStl + adv,iNearby) - ifClose(idxStl + adv,iNearby-1);
            catch e
                rollCost(1:end-1, adv+1) = ifClose(idxStl(1:end-1) + adv,iNearby) - ifClose(idxStl(1:end-1) + adv,iNearby-1);
            end
        end        
end


%% ��ͼ
m = mean(rollCost(end-12:end,:));
s = std(rollCost(end-12:end,:),0, 1);


figure(617); hold off;
plot(rollCost)
legend('������', '+1', '+2', '+3','+4');
if iNearby == 1, legend('������', '-1', '-2', '-3','-4'); end 
title(sprintf('Roll Cost: %d Nearby', iNearby));        
grid on        


%% ����total IF
adjCost         = zeros(size(ifClose,1),1);
adjCost(idxStl) = rollCost(:,2);
cumAdjCost      = cumsum(adjCost);
ttlIF          = ifClose(:,iNearby) - cumAdjCost;


figure(616); hold off
plot(ttlIF);
hold on
plot(ifClose(:,iNearby),'r');
legend('total IF', 'IF');
title(sprintf('tradable total IF: %d Nearby', iNearby));         
grid on        

end
