function [sig_long, sig_short, sig_rs] = Ma(price,lag,flag)
% �۸�Խ����, ���� sig_long, sig_short, sig_rs
% lag ���߻���bar���� Ĭ�� 10
% flag ���߼��㷽���� Ĭ�ϼ�ƽ��=0�� ������������ doc ind.ma
% @author Daniel 20130506

% Ԥ����
if ~exist('lag', 'var'), lag = 10; end
if ~exist('flag', 'var'), flag = 0; end

[ nPeriod, nAsset ] = size(price);
sig_long =  zeros( nPeriod, nAsset );
sig_short = zeros( nPeriod, nAsset );
sig_rs =    zeros( nPeriod, nAsset );

maVal = ind.ma(price, lag, flag);

% �źŲ�
sig_long(logical(crossOver(price,maVal))) = 1;
sig_short(logical(crossOver(maVal, price))) = -1;
sig_rs( price > maVal ) = 1;
sig_rs( price < maVal ) = -1;


end %EOF