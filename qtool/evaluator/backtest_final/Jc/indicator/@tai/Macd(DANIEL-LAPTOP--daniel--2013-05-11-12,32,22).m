function [ sig_long, sig_short, sig_rs] = Macd( price, short, long, compare,type)
%% MACD ��� sig_long, sig_short, sig_rs
% type = 1 (Ĭ�ϣ�ʱ�� barVal>0 ���֣� barVal<0 �ز�
% type = 2ʱ�� barVal, diffVal, daeVal ͬΪ�������֣�ͬΪ�����ز�
% barVal, diffVal, daeVal ������� ind.macd
% Ĭ�ϲ����� short = 12�� long = 26�� compare = 9�� ����ind.macd;
% @author Daniel 20130506


% ����Ԥ����

if ~exist('short', 'var') || isempty(short), short = 12; end
if ~exist('long', 'var') || isempty(long), long = 26; end
if ~exist('compare', 'var') || isempty(compare), compare = 9; end
if ~exist('type', 'var') || isempty(type), type = 1; end
if short>long
    temp = short;
    short = long;
    long = temp;
    clear temp;
end

[nPeriod, nAsset] = size(price);
sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);
sig_rs = zeros(nPeriod, nAsset);

[diffVal daeVal barVal]=ind.macd(price,long,short,compare);

% �źŲ�
if type ==1
    zeroline = zeros(nPeriod, nAsset);
    sig_long(logical(crossOver(barVal,zeroline))) = 1;
    sig_short(logical(crossOver(zeroline, barVal))) = -1;
    sig_rs(barVal > zeroline) = 1;
    sig_rs(barVal < zeroline) = -1;
elseif type ==2;
    zeroline = zeros(nPeriod, nAsset);
    sig_long(logical(crossOver(barVal,zeroline)) & logical(crossOver(diffVal,zeroline)) & logical(crossOver(daeVal,zeroline))) = 1;
    sig_short(logical(crossOver(zeroline,barVal)) & logical(crossOver(zeroline,diffVal)) & logical(crossOver(zeroline,daeVal))) = 1;
    sig_rs(barVal>0 & diffVal>0 & daeVal>0)  =  1;
    sig_rs(barVal<0 & diffVal<0 & daeVal<0)  = -1;
else
    ;
end
end %EOF
