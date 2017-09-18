function [  ] = animate_pankou(ticks, stk, etk, step, pauseSec)
%ANIMATE_PANKOU ����չʾ�̿�����
% stk, etk, step:     ����tk��step
% pauseSec:           ÿ֡��ͣ����
% �̸�; 140616


%% Ԥ����
if ~isa(ticks, 'Ticks')
    disp('�����������ͱ�����Ticks');
    return;
end


len = length(ticks.time) ; % = ticks.latest;
etk = min(len, etk);

if (stk >= etk )
    disp('������ʼstkӦ < ��ֹetk');
    return;
end


if ~exist('pauseSec', 'var'),   pauseSec = 0.5; end
if ~exist('step', 'var'),       step = 1; end


vo = ticks.volume;
dvo = [vo(1); diff(vo) ];



% ���tickValue, δ�ز����
dp = abs( diff(ticks.last) );
tickValue = min( dp(dp > 1e-6) ) ;


%% subplot �̿ڶ�ͼ
ylim = [min(min(ticks.bidP(stk:etk,:)))-tickValue, max(max(ticks.askP(stk:etk,:)))+tickValue];
xmax = max(max([ticks.askV(stk:etk,:),ticks.bidV(stk:etk,:)]));
xmax =  max( max(dvo(stk:etk)), xmax);
xlim = [ 0, xmax];


for tk = stk:step:etk
%     subplot(1,N,subplot_i); hold off;
    
    figure(616); hold off
    
    barh(ticks.askP(tk,:), ticks.askV(tk,:),'b');
    hold on;
    barh(ticks.bidP(tk,:), ticks.bidV(tk,:),'g');
    barh(ticks.last(tk), dvo(tk),0.5*tickValue, 'y');
    title(sprintf('tick%d*',tk) );
    
    set(gca, 'YLim', ylim, 'XLim', xlim);
    
    pause(pauseSec);
    
    % ������ʱ������һ�±�߱�� ylim(1):tickValue:ylim(2)
    
end

end

