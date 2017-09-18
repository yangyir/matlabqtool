function [ bid_ask_spread ] = bas( ticks, asklevel, bidlevel )
%BAS ���������ҵ��ļ۲�
% asklevel���ڼ����̿�
% bidlevel���ڼ����̿�
% chenggang; 140602

%% Ԥ����

if ~isa(ticks, 'Ticks')
    disp('�����������ͱ�����Ticks');
    return;
end

if ~exist('asklevel','var'), asklevel = 1; end
if ~exist('bidlevel','var'), bidlevel = 1; end

ask = ticks.askP(1:ticks.latest, asklevel);
bid = ticks.bidP(1:ticks.latest, bidlevel);

%%
bid_ask_spread = ask - bid;

end

