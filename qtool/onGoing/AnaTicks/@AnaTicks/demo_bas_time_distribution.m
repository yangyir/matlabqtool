function [ meanBas, stdBar, minBas ] = demo_bas_time_distribution( arrTicks )
%DEMO_BAS_TIME_DISTRIBUTION 算日内分时平均bas
% 有不准的地方：因为按tick#平均，可能时间没对齐
% 程刚；140601



%% default: 取日度tick数据

if ~exist('arrTicks', 'var')

t = 1;
% clear arrDate arrTicks;
tic
for yy = 2013:2013
for mm = 2:2
for dd = 1:31
    tday    = datenum(yy,mm,dd);
    sdt     = datestr(tday,'yyyymmdd');
    ticks   = Fetch.dmTicks('IFHot',sdt,sdt);
    p       = ticks.last;
    if isempty(p), continue; end    
    % 记录
    arrDate(t)  = tday;
    arrTicks(t) = ticks;
    t = t+1;
end
end
end
toc


end



%% 查一下bas的变化情况

% 算
arrBas = nan(32400, length(arrTicks));
for idt = 1:length(arrTicks)
    ticks = arrTicks(idt);
    bas = AnaTicks.bas(ticks);
    arrBas(1:ticks.latest,idt) = bas;
end

sdt_edt_str = [datestr(arrDate(1),'yyyymmdd'), ' - ', datestr(arrDate(end),'yyyymmdd')];


% 画
meanBas = mean(arrBas, 2);
figure; hold off;
plot(meanBas);
title(['mean BAS, ' sdt_edt_str])

stdBas = std(arrBas, 0, 2);
figure; hold off;
plot(stdBas);
title(['std BAS, ' sdt_edt_str]);

% 找出bas较大情况
tk_idx = find(meanBas>0.3)/120
nnz(meanBas>0.3)

% 分钟级meanBas
minBas = nan(270,1);
for i = 1:length(minBas)
    stk = 1+(i-1)*120;
    etk = i*120;
    minBas(i) = mean(meanBas(stk:etk));
end
figure; bar(minBas)
title(['按分钟BAS均值, ' sdt_edt_str]);

end

