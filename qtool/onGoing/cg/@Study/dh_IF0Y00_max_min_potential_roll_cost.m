function [ifroll] = dh_IF0Y00_max_min_potential_roll_cost( )
%DH_IF0Y00_MAX_MIN_POTENTIAL_ROLL_COST 看IF0Y00最大最小的可能roll cost
% 历史情况
% 帮助解决问题：
%   if1的移仓损失是否可以改善？ 设定条件提前移仓
% chenggang; 140620; 完成


%% 日期数据
tdayStr     = datestr(today,'yyyy-mm-dd');
datesStr    = DH_D_TR_MarketTradingday(3,'2010-04-16',tdayStr);

% 当日17点前，还没有当日的数据，会出错
if hour(now) < 17
    datesStr       = datesStr(1:end-1,:);
end

ifroll.date        = datenum(datesStr);
ifroll.todayStr    = datesStr;


%% 找出settle dates对应的idxStl
code    = DH_E_FS_IF_ContiContr('IF0Y00',datesStr);
stlDate = datenum( DH_D_F_FLastDay(code) );
e       = stlDate == ifroll.date;
idxStl  = find(e==1);

% 若始终拿IF0Y02或IF0Y03,在1，4，7，10月换
% if iNearby == 3 || iNearby ==4
%     idxStl  = find(e==1 & mod(month(stlDate),3) == 1);
% end



%% 算最小可能移仓成本：取每日的分钟close，一个一个月来
% 算最大，最小，3rdThu
% 只看IF0Y00的移仓 
idxRoll = idxStl -1;

for imth = 2 : length(idxRoll)
sdt = ifroll.date(idxStl(imth-1) + 1);
edt = ifroll.date(idxRoll(imth));

% 月内， 一天一天来
clear tmp_min tmp_max;
for idt = (idxStl(imth-1)+1) : idxRoll(imth)
    k       = idt - idxStl(imth-1);
    thisdt  = ifroll.date(idt);
    
    curLast     = DH_Q_HF_FutureSlice('IF0Y00.CFE',thisdt,'ClosePrice',1);
    nextLast    = DH_Q_HF_FutureSlice('IF0Y01.CFE',thisdt,'ClosePrice',1);    
    sp          = nextLast - curLast;
    
    % 储存用
    ifroll.day_min(idt) = min(sp);
    ifroll.day_max(idt) = max(sp);
    
    % 暂时用
    tmp_min(k) =  min(sp);
    tmp_max(k) = max(sp);
    
    txt = sprintf('%s: IF1-IF0, max=%0.1f, min=%0.1f', ...
            datestr(thisdt,'yymmdd'), tmp_max(k), tmp_min(k));
    disp(txt);
    
%     
%     figure(622); hold off;
%     plot( sp );
%     title( txt );
    

end

eomRollCost(imth)       = sp(end);
[mth_min(imth), i_min]  = min(tmp_min);
[mth_max(imth), i_max]  = max(tmp_max);


txt_mth = sprintf('%s-%s: IF1-IF0, max=%0.1f, min=%0.1f, 3TRoll=%0.1f', ...
            datestr(sdt,'yymmdd'), datestr(edt,'yymmdd'), mth_max(imth), mth_min(imth), eomRollCost(imth) );
disp(txt_mth);

% 月度图
figure(620);hold off;
plot(tmp_min,'--');
hold on;
grid on;
plot(tmp_max);
plot(k, eomRollCost(imth), 'r*');
plot(i_min, mth_min(imth), 'ro');
plot(i_max, mth_max(imth), 'ro');
legend('day min', 'day max');
title(txt_mth); 

end



%% 总图
figure(621);hold off;
plot(eomRollCost);
hold on;
plot(mth_max,'r');
plot(mth_min, '--r');
title('Roll Cost: IF0Y00');
legend('3Thu rollCost', 'min possible', 'max possible');
grid on;


%% 结果返回
% 记录
ifroll.mth_min     = mth_min;
ifroll.mth_max     = mth_max;
ifroll.ttRollCost  = eomRollCost;
ifroll.idxStl      = idxStl;
ifroll.idxTTRoll   = idxRoll;


end

