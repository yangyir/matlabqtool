function [ out_long, out_short ] = sigStopLoss( price, sig_long, sig_short, bp, pct )
% ��ԭ�������������ź��в���ֹ���
% ������ֻ�������������ƽ���źţ������ܲ�λ���
% @input    price:  �۸����У�ʵ�ʹ����У������۸�Ӧ�Գɽ����۸����á�
% @input    sig_long:   ��ͷ�������źţ�{1, 0, -1}�ֱ����{���뿪�֣���������������ƽ��}
% @input    sig_short:  ��ͷ�������źţ�{1, 0��-1}�ֱ����{����ƽ�֣��������������տ���}
% @param    bp��    ��������䶯��������ָ�ڻ��У�bp����0.2��������
% @param    pct��   ��������䶯�ٷֱȡ�
% @explain  ���ͬʱ����bp��pct�����ڼ���ֹ���λʱ�ýϱ��ص�ֹ����
% @author   daniel  20130508

% Ԥ����

if nargin<=3
    error('input data is not enough')
end

if nnz(size(price)~=size(sig_long)) || nnz(size(price) ~= size(sig_short))
    error('input data must be same size');
end

if isempty(bp) && isempty(pct), error('must set one of bp and pct'); end 
if ~exist('bp','var'),  bp  = 3000; end
if ~exist('pct','var'), pct = 1 ; end 

[ nPeriod , nAsset ] = size(sig_long);
out_long  = sig_long;
out_short = sig_short;

% ����ֹ��λ��
for jAsset = 1:nAsset
    rs_long  = 0;
    rs_short = 0;
    for iPeriod = 1:nPeriod
        tradeLong   = sig_long(iPeriod, jAsset);
        tradeShort  = sig_short(iPeriod, jAsset);
        nowPrice = price(iPeriod, jAsset);
        % ��ͷ
        if rs_long == 0
            if tradeLong ==1
                rs_long = 1;
                priceLong = nowPrice;
                longStopLossPrice = max(priceLong - bp, priceLong*(1-pct));
            end
           
        elseif rs_long == 1
            if tradeLong == -1
                rs_long = 0;
                priceLong = 0;
            elseif nowPrice <= longStopLossPrice
                rs_long = 0;
                priceLong = 0;
                out_long(iPeriod, jAsset) = -1;
            end
        end
        
        % ��ͷ
        if rs_short ==0
            if tradeShort == -1;
                rs_short = -1;
                priceShort = nowPrice;
                shortStopLossPrice = min (priceShort + bp, priceShort*(1+pct));
            end
        elseif rs_short ==1
            if tradeShort == 1
                rs_short = 0;
                priceShort = 0;
            elseif nowPrice >= shortStopLossPrice
                rs_short = 0;
                priceShort = 0;
                out_short(iPeriod, jAsset) = 1;
            end
        end            
    end
end



end

