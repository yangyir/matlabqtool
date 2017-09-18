function  [sig_long, sig_short, sig_rs] = Leadlag(price, lead, lag, flag,type)
% �������ָ�꣬��2���ƶ�ƽ����Ԥ��۸����ƣ����������ź�
% daniel 2013/3/1
% price����������ʲ��۸�����
% lead�������ƶ�����
% lag�� �����ƶ�����
% flag���ƶ������㷨

%% ������ݼ�Ԥ������ռ�
if nargin <1 || isempty(price)
    error('no input found')
end
if ~exist('type', 'var') || isempty(type), type = 1; end
if ~exist('lead', 'var') || isempty(lead), lead = 10; end
if ~exist('lag', 'var') || isempty(lag), lag = 30; end
if ~exist('flag', 'var') || isempty(lag), flag = 'e'; end
[nPeriod, nAsset] = size(price);

%%
sig_long     = zeros(nPeriod, nAsset);
sig_short    = zeros(nPeriod, nAsset);
sig_rs       = zeros(nPeriod, nAsset);

%%
% ��������ߺ�������
[leadVal, lagVal]=ind.leadlag(price,lead,lag,flag);

%%
if type==1
% ���տ������ϴ��������Լ��������Ƿ�������Ϊ��������
sig_long(crossOver(leadVal, lagVal))  = 1;
sig_short(crossOver(lagVal, leadVal)) = -1;

% ����ǿ���ź�
sig_rs(leadVal >  lagVal)  =  1;
sig_rs(leadVal <= lagVal)  = -1;

else
    ;
end
end %[EOF]

