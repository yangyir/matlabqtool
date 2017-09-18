function [] = mdd(nav1,Date1)
% plot mdd, areaÍ¼
% ---------------------
% ÌÆÒ»öÎ£¬20150730

prehigh = nan(length(nav1),1);
prehigh(1) = nav1(1);
mdd = nan(length(nav1),1);
mdd(1) = 0;
for i = 2:length(nav1)
    prehigh(i) = max(prehigh(i-1),nav1(i));
    mdd(i) = (nav1(i) - prehigh(i))/prehigh(i);
end
area(Date1,mdd)
grid on
datetick('x',29);
set(gca,'xlim',[Date1(1),Date1(end)]);


end


