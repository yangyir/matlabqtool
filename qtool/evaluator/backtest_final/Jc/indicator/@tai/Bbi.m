function [sig_long,sig_short, sig_rs] = Bbi(close, lag1, lag2, lag3, lag4,type)
% bbi ���ָ��
% ����
% �����ݡ� ���̼�
% �������� 4��n�վ���
% ���
% ����ͷ�� sig_long: �۸�ͻ��bbi
% ����ͷ�� sig_short�� �۸����bbi
% ��ǿ���� sig_rs�� �۸���bbi�Ϸ�Ϊǿ�ƣ��۸���bbi�·�Ϊ����
% 2013/3/21 daniel

% ���㹫ʽ
% �££ɣ�(���վ��ۣ����վ��ۣ������վ��ۣ������վ���)�£��Ӷ��ָ���ļ��㹫ʽ���Կ��������ָ������ֵ�ֱ�����˲�ͬ�����ƶ�ƽ���ߵĲ���Ȩֵ������һ�ֽ���ͬ�������ƶ�ƽ��ֵ��ƽ������ֵ���Ӷ��ֱ�����˸���ƽ���ߵġ����桱����ʵ�ϣ����ָ�����ƶ�ƽ��ԭ������������˶�շ�ˮ������á�
% Ӧ�÷���
% ����һ
% 1. �ɼ�λ��BBI �Ϸ�����Ϊ��ͷ�г���
% 2. �ɼ�λ��BBI �·�����Ϊ��ͷ�г���
% �����
% �����ɼ��ڸ߼��������м����µ��ƶ����Ϊ�����źš�
% �����ɼ��ڵͼ��������м�����ͻ�ƶ����Ϊ�����źš�
% �������ָ���������ϵ������ɼ��ڶ�����Ϸ���������ͷ��ǿ�����Լ����ֹɡ�
% �������ָ���������µݼ����ɼ��ڶ�����·���������ͷ��ǿ��һ�㲻�����롣

%% ����Ԥ����
[nPeriod, nAsset] = size(close);
if ~exist('lag4', 'var') || isempty(lag4), lag4 = 24; end
if ~exist('lag3', 'var') || isempty(lag3), lag3 = 12; end
if ~exist('lag2', 'var') || isempty(lag2), lag2 = 6; end
if ~exist('lag1', 'var') || isempty(lag1), lag1 = 3; end
if ~exist('type', 'var') || isempty(type), type = 1; end
%% ���㲽


[bbiVal] = ind.bbi(close, lag1, lag2, lag3, lag4);

%% �ź����
if type==1
sig_long = zeros(nPeriod, nAsset);
sig_long(crossOver(close, bbiVal) & close>[nan(1,nAsset);close(1:end-1,:)]) = 1;

sig_short = zeros(nPeriod, nAsset);
sig_short(crossOver(bbiVal,close) & close<[nan(1,nAsset);close(1:end-1,:)]) = -1;

sig_rs = zeros(nPeriod, nAsset);
sig_rs( close > bbiVal ) =  1;
sig_rs( close < bbiVal ) = -1;
else
;
end
end %EOF