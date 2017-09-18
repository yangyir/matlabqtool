function taovalue = tao( ticks0 , yields )
% ��r��ͬ��taoһ�μ���ticks0һ������µ��ɽ�ʱ�䣬������㣬����Բ�
% @luhuaibao
% 2014.5.29
% tao:
%       time-after-order, �µ���Ǳ�ڵȴ�ʱ�䣻
%       tao.labels,  ���ݾ����ǩ
%       tao.values,  ���ݾ���
% taoΪ�����µ���ʽ�£����鿴���ɽ���ȴ�ʱ��
% inputs:
%       ticks0��ΪAnaTicks�࣬ȡ����ticks���Լ���
%       yields, ���޼۵�ʱ�������Ĵ�С

if ~exist('yields','var')
    yields = 0 ;
end ;


%% ticks����

ticks.time = ticks0.time(1:ticks0.latest);
ticks.bidP = ticks0.bidP(1:ticks0.latest,1);
ticks.askP = ticks0.askP(1:ticks0.latest,1);
ticks.last = ticks0.last(1:ticks0.latest,1);
ticks.volume = [nan; diff(ticks0.volume(1:ticks0.latest,1))];

labels = cell(1,4) ;
values = nan(ticks0.latest,4);




%% �м���
labels{1} = 'buyAtMarket' ;

% ��last�µ���δ���ж�ʱ������last
w1 = findFirstEqual(-ticks.last,-ticks.last,ticks.time ) ;
% volumeС����ζ�ţ�û����ʵ�ɽ���ʱ����Ϊnan
w1(ticks.volume<=0) = nan ;
% �ȴ�ʱ����s��
r  = w1*24*60*60  ;
values(:,1) = r ;




%% �м���
labels{2} = 'sellAtMarket' ;
% ��last�µ���δ���ж�ʱ������last

w1 =  findFirstEqual(ticks.last,ticks.last,ticks.time ) ;
% volumeС����ζ�ţ�û����ʵ�ɽ���ʱ����Ϊnan
w1(ticks.volume<=0) = nan ;
% �ȴ�ʱ����s��
r = w1*24*60*60  ;
values(:,2) = r ;





%% �޼���
labels{3} = 'buyAtLimit' ;

% δ��������С���޼�
w2 =  findFirstEqual(-(ticks.bidP(:,1)+yields),-ticks.askP(:,1),ticks.time ) ;
% ����w1 = w2 , Ȼ���ٴ���volume�б仯�ĵط�
w1 = w2 ;
% δ��lastС���޼�
w0 =  findFirstEqual(-(ticks.bidP(:,1)+yields),-ticks.last,ticks.time ) ;
w0 = w0(ticks.volume>0);
w1(ticks.volume>0) = w0 ;
w = min(w1,w2) ;
% �ȴ�ʱ����s��
r = w*24*60*60  ;

values(:,3) = r ;





%% �޼���
labels{4} = 'sellAtLimit' ;

% δ�����򵥴����޼�
w2 =  findFirstEqual((ticks.askP(:,1)-yields),ticks.bidP(:,1),ticks.time ) ;
% ����w1 = w2 , Ȼ���ٴ���volume�б仯�ĵط�
w1 = w2 ;
% δ��last�����޼�
w0 =  findFirstEqual((ticks.askP(:,1)-yields),ticks.last,ticks.time ) ;
w0 = w0(ticks.volume>0);
w1(ticks.volume>0) = w0 ;
w = min(w1,w2) ;
% �ȴ�ʱ����s��
r = w*24*60*60  ;
values(:,4) = r ;




%%
taovalue.labels = labels ;
taovalue.values = values ;
taovalue.yields = yields ; 
taovalue.ticks = ticks0 ;  


end

