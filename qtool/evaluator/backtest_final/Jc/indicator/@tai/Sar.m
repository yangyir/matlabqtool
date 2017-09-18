function [ sig_long,sig_short,sig_rs] = Sar( high, low, price, step, maxStep,type)
%% �ú������ SAR �Ľ���Լ�����Ӧ�Ľ����źţ�ǿ���ź�
% sar ǿ���źŹ����ǵ� price �� sar ֮�ϵ�ʱ�򣬿���֣���֮�򿪿ղ֣�
% ���� high, low, price �ֱ���ÿ�յ���üۣ���ͼۣ����̼ۣ�
% ���� step Ϊ���� sar ʱ�������ٶȣ�Ĭ��ֵΪ 0.02��
% ���� maxStep  Ϊ���� sar ʱ�����ƫ�벽����Ĭ��ֵΪ 0.2��
% ��� sig_long, sig_short �ֱ�Ϊ����֣����ղֵĽ����źţ�
% ��� sig_rs Ϊ sar ָ���µ�ǿ���źţ�״̬Ϊ1��-1��0��
% ��� sar Ϊ�������ֵ�����
% 
% �޸���sig_long��sig_short�������򣬸���crossOver����sig2trade�� �ź� 20130424

%% ����Ԥ����
if ~exist('step', 'var') || isempty(step), step = 0.02; end
if ~exist('maxStep', 'var') || isempty(maxStep), maxStep = 0.2; end
if ~exist('type', 'var') || isempty(type), type = 1; end
[nperiod,nasset] = size(price);
sig_rs  =  zeros(nperiod, nasset);
sig_long = sig_rs;
sig_short = sig_rs;
sar  =  zeros(nperiod, nasset);

%% ����ÿ���ʲ����ź��Լ� sar ��ֵ

for i=1:nasset
    sar(:,i) = ind.sar(high,low,step,maxStep,step);
end

if type==1
    sig_rs(price>sar)=1;
    sig_rs(price<sar)=-1;
    sig_long(logical(crossOver(price, sar, 1))) = 1;
    sig_short(logical(crossOver(sar, price, 1))) = -1;
else
    ;
end

