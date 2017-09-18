function histDiff( ticks )
% histDiff  ͨ��hist�ķ�ʽ��hist last/ask/bid��һ�ײ�ֲַ�
% @luhuaibao
% 2014.6.3

if ~isa(ticks, 'Ticks')
    disp('�����������ͱ�����Ticks');
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
s1 = ['lastһ�ײ�ֲַ�'];
title(s1,'fontsize',7);
 
 subplot(3,1,2)
iplot.ihist( diff(ticks.bidP(1:n,1)) );
s1 = ['bidһ�ײ�ֲַ�'];
title(s1,'fontsize',7);
 

 subplot(3,1,3)
iplot.ihist( diff(ticks.askP(1:n,1)) );
s1 = ['askһ�ײ�ֲַ�'];
title(s1,'fontsize',7);
 






end

