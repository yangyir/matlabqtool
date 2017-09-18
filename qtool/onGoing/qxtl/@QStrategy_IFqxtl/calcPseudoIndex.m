function [obj] = calcPseudoIndex(obj, tm)
% CALCPSEUDOINDEX ����ϳ�ָ����λ
% ���ǵ�ͣ�ɵĴ���Ҫ����


% �������⣺�и��ɷ���ͣ��û����������ô�죿
% ��ͣ��Ҳ�ҵ����ڴ���ɴ�

% ��ͣ���֣��۸������nan�����ٻز�ʱ������
sProf = obj.stockProfile;

idx_zhangting = isnan(sProf(:,3));
idx_dieting   = isnan( sProf(:,5));

% ask1�� ask2
sProf(idx_zhangting, [2,6]) = sProf(idx_zhangting,1);
sProf(idx_zhangting, [3,7]) = 0;

% bid1, bid2
sProf(idx_dieting, [4,8])   = sProf(idx_dieting, 1);
sProf(idx_dieting, [5,9])   = 0 ;


tmp = sProf' * obj.stockQ;

% ����last����򵥵���


% ��������򵥵ķ�������a1,a2,b1,b2


tks = obj.pseudoIndexTicks;
tks.latest = tks.latest + 1;
l = tks.latest;

tks.time(l,1)   = tm;
tks.last(l,1)   = tmp(1);
tks.askP(l,1)   = tmp(2);
tks.bidP(l,1)   = tmp(4);
tks.askP(l,2)   = tmp(6);
tks.bidP(l,2)   = tmp(8);

% ����volumeҪ�ѵ㾢


end
