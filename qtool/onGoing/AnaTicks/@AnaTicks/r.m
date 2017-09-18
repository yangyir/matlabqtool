function [waiting, waiting_tk] = r( ticks,t,limitprice,direction, flag_strict, latency   )
% ���Ƹ����޼۵ĳɽ��ȴ�ʱ�䣨�ز��ã�
% inputs:
%       ticks0,         Ticks��
%       t,              �޼۵㣬matlab��ʽʱ��
%       price,          �޼�
%       direction,      ����1Ϊ��-1Ϊ��
%       flag_strict,    �Ƿ��ϸ��жϳɽ����� �� >  �� >= ������
% version 1.0, luhuaibao
% 2014.5.29


%% Ĭ��ֵ
if ~exist('flag_strict', 'var'), flag_strict = 0 ;  end
if ~exist('latency', 'var'), latency = 0.5/24/3600; end

% �������ȴ�Сʱ��������epsilon�����ı�a>b�Ľ��
% a>b    <=>   a>b+epsilon
% a<b    <=>   a<b-epsilon
% a>=b   <=>   a>=b-epsilon  <=>  a>b-epsilon
% a<=b   <=>   a<=b+epsilon  <=>  a<b+epsilon
epsilon = 1e-5;


%%
% disp('r����ʱ��Ĭ��volume�ǵ����ģ���ȷ��ticks��volume����');


% tic

%% ȡ�µ����ڵ�һ��tk
time = ticks.time(1:ticks.latest);
% �ϸ���ڣ����µ���Ҫ����ʱ��
order_tk = find(time > t+latency , 1, 'first');



%% ��order_tk��ʼȡ
time = ticks.time(order_tk:ticks.latest);
bidP = ticks.bidP(order_tk:ticks.latest,1);
askP = ticks.askP(order_tk:ticks.latest,1);
last = ticks.last(order_tk:ticks.latest);
volume = [ticks.volume(order_tk); diff(ticks.volume(order_tk:ticks.latest,1))];



%% �жϿ��Գɽ�
if flag_strict == 1
    if direction == 1  % ����bid
        idx =  ( last < limitprice-epsilon & volume>0 ) | askP <= limitprice+epsilon;
    elseif direction == -1  % ����ask
        idx =  ( last > limitprice+epsilon & volume>0 ) | bidP >= limitprice-epsilon;
    end
elseif flag_strict == 0
    if direction == 1  % ����bid
        idx =  ( last <= limitprice+epsilon & volume>0 ) | askP <= limitprice+epsilon;
    elseif direction == -1  % ����ask
        idx =  ( last >= limitprice-epsilon & volume>0 ) | bidP >= limitprice-epsilon;
    end
end


%% ����ȴ�ʱ��
waiting_tk = find( idx == 1, 1, 'first');

% δ�ܳɽ�����
if isempty(waiting_tk)
    waiting     = nan;
    waiting_tk  = nan;
%     toc;
    return;
end

success_t = time(waiting_tk);
waiting = success_t - t;

% ��ȥ����90����
if t-floor(t) <= 11.5/24
    if success_t - floor( success_t ) >= 13/24
        waiting = waiting - 1.5/24;
    end
end

waiting = waiting * 24 * 3600;    
% toc

end

