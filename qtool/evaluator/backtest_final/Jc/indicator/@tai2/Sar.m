function [ sig_long,sig_short,sig_rs] = Sar( bar, step, maxStep, type)
%% �ú������ SAR �Ľ���Լ�����Ӧ�Ľ����źţ�ǿ���ź�
% sar ǿ���źŹ����ǵ� price �� sar ֮�ϵ�ʱ�򣬿���֣���֮�򿪿ղ֣�
% ���� high, low, price �ֱ���ÿ�յ���üۣ���ͼۣ����̼ۣ�
% ���� step Ϊ���� sar ʱ�������ٶȣ�Ĭ��ֵΪ 0.02��
% ���� max  Ϊ���� sar ʱ�����ƫ�벽����Ĭ��ֵΪ 0.2��
% ��� sig_long, sig_short �ֱ�Ϊ����֣����ղֵĽ����źţ�
% ��� sig_rs Ϊ sar ָ���µ�ǿ���źţ�״̬Ϊ1��-1��0��
% ��� sar Ϊ�������ֵ�����

%% ����Ԥ����
high = bar.high;
low = bar.low;
price = bar.close;

if ~exist('step', 'var') || isempty(step), step = 0.02; end
if ~exist('maxStep', 'var') || isempty(maxStep), maxStep = 0.2; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ����
[sig_long, sig_short, sig_rs] = tai.Sar(high, low, price, step, maxStep, type);

if nargout == 0
    sar.sar = ind.sar(high, low, step, maxStep, step);
    bar.plotind2(sig_long + sig_short, sar);
    title('sar long and short');
    bar.plotind2(sig_rs, sar);
    title('sar rs');
end

end