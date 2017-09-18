function [ ] = plotLocalALB( obj, stk, etk )
%PLOTLOCALALB ��ask-last-bid ͼ�� �ֲ�
% [ ] = plotLocalALB( obj, stk, etk )
% stk         ��ʼ��tk��ţ�Ĭ��1��
% etk         ������tk��ţ�Ĭ��latest��
% �̸գ�140731


%% Ԥ����

len = length(obj.time);

if ~exist('stk', 'var'), stk = 1; end
if ~exist('etk', 'var')
    if obj.latest > 1
        etk = obj.latest;
    else        
        etk = len;
    end
end

stk = max(stk,1);
etk = min(etk,len);

range = stk:etk;


%% ��ͼ
 
% hold off

l = obj.last(range);
plot(range, l, '.k');

hold on;
try
    a = obj.askP(range,1);
    b = obj.bidP(range,1);
    plot(range, a, 'b');
    plot(range, b, 'r');
catch e
    disp('ȡask��bidʱ����');
end

title( sprintf('Local ask-last-bid ͼ��%d - %d', stk, etk));





end

