function [sig_long, sig_short] = Asi(open, high, low, close, mu_up, mu_down,type)
% ASI ������ָ��
% ���룺
%�����ݡ� ���̣���ߣ���ͣ�����
%�������� ����ǰ�ڸߵ͵��mu_up, mu_down
% �����sig_long, sig_short, asi
% daniel 2013/4/2

%% Ԥ����
if ~exist('mu_down', 'var') || isempty(mu_down), mu_down = 0.02; end
if ~exist('mu_up', 'var') || isempty(mu_up), mu_up = 0.02; end
if ~exist('type', 'var') || isempty(type), type = 1; end


sig_long = zeros(size(close));
sig_short = zeros(size(close));

% ASI��Ӌ�㹫ʽ
% 1.  A=������߃r-ǰһ���ձP�r
% ��  B=������̓r-ǰһ���ձP�r
% ����C=������߃r-ǰһ����̓r
% ����D=ǰһ���ձP�r-ǰһ���_�P�r
% ����A��B��C��D�Ԓ��ý^��ֵ
% 2.  E=�����ձP�r-ǰһ���ձP�r
% ����F=�����ձP�r-�����_�P�r
% ����G=ǰһ���ձP�r-ǰһ���_�P�r
% ����E��F��G������+����ֵ
% 3.  X��E��1��2F��G��
% 4.  K=���^A��B�ɔ�ֵ���x���������ֵ
% 5.  ���^A��B��C����ֵ��
% ����  ��A��󣬄tR��A�� 1��2B�� 1��4D
% ����  ��B��󣬄tR��B��1����Aʮ1��4D
% ����  ��C��󣬄tR= C��1/4D
% 6.  L��3
% 7.  SI= 50* X��R * K��L
% 8.  ASI=��Ӌÿ��֮SIֵ

%% ���㲽
[nPeriod, nAsset] = size(open);

[asiVal, siVal] = ind.asi(open, high, low, close);

%% �źŲ�
% 1.�ɼۺ�ASIָ��ͬ����������ASI���ȹɼ�ͻ��ǰ�ڸߵ�ʱ���������źš�
% 2.�ɼۺ�ASIָ��ͬ���½�����ASI���ȹɼ۵���ǰ�ڵ͵�ʱ���������źš�
% 3.�ɼ۴��¸ߡ��ͣ���ASIδ���¸ߡ��ͣ�����˸ߵ͵㲻ȷ�ϡ�
% 4.�ɼ���ͻ��ѹ����֧���ߣ�ASIȴδ���淢����Ϊ��ͻ�ơ�
% 5.ASIǰһ���γɵ������ߡ��͵㣬��ΪASIͣ��㣻��ͷʱ��ASI����ǰһ�ε͵㣬ͣ����������ͷʱ��ASI����ͻ��ǰһ�θߵ㣬ͣ��ز���
% 6.�ɼ۴��µͣ���ASIָ��δ���µ�ʱ��Ϊ�ױ��룻�ɼ۴��¸ߣ���ASIָ��δͬ���¸�ʱ��Ϊ�����롣

priceHigh = nan(size(close));
priceLow  = nan(size(close));
asiHigh   = nan(size(close));
asiLow    = nan(size(close));

for i= 1: nAsset
    [priceHigh(:,i), priceLow(:,i)] = LastExtrema(close(:,i), mu_up, mu_down);
    [asiHigh(:,i), asiLow(:,i)]     = LastExtrema(asiVal(:,i), mu_up, mu_down);
end

if type==1
sig_long(logical(crossOver(asiVal, asiHigh))) = 1;
sig_short(logical(crossOver(asiLow, asiVal))) = -1;
else
;
end    
end 











