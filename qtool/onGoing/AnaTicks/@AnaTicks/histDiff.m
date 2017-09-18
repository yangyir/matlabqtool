function histDiff( ticks )
% histDiff  通过hist的方式，hist last/ask/bid的一阶差分分布
% @luhuaibao
% 2014.6.3

if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end



if isempty(ticks.latest)
    n = length(ticks.last);
else
    n = ticks.latest ; 
end ; 


% figure()

subplot(3,1,1)
iplot.ihist( diff(ticks.last(1:n)) );
s1 = ['last一阶差分分布'];
title(s1,'fontsize',7);
 
 subplot(3,1,2)
iplot.ihist( diff(ticks.bidP(1:n,1)) );
s1 = ['bid一阶差分分布'];
title(s1,'fontsize',7);
 

 subplot(3,1,3)
iplot.ihist( diff(ticks.askP(1:n,1)) );
s1 = ['ask一阶差分分布'];
title(s1,'fontsize',7);
 






end

