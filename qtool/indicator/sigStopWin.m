function [ out_long, out_short ] = sigStopWin( price, sig_long, sig_short, initBp, bp, pct )
% ��ԭ�������������ź��в���ֹӮ��
% ֹӯ�㰴����ˮ�����ã��������۸�����������䶯initBp����λ�󣬰��ջس�������س��ٷֱȷ���ֹӯ�ź�
% ������ֻ�������������ƽ���źţ�������ʵ�ʲ�λ���
% @input    price:  �۸����У�ʵ�ʹ����У������۸�Ӧ�Գɽ����۸����á�
% @input    sig_long:   ��ͷ�������źţ�{1, 0, -1}�ֱ����{���뿪�֣���������������ƽ��}
% @input    sig_short:  ��ͷ�������źţ�{1, 0��-1}�ֱ����{����ƽ�֣��������������տ���}
% @param    initBp: ��������䶯���������� Ĭ�ϴ��� 15
% @param    bp��    ��������䶯���㡣��ָ�ڻ��У�bp����0.2��������
% @param    pct��   ��������䶯�ٷֱȡ�
% @explain  ���ͬʱ����bp��pct�����ڼ���ֹ���λʱ�ýϱ��ص�ֹ����
% @author   daniel  20130508

% Ԥ����

if nargin<5
    error('input data is not enough')
end

if nnz(size(price)~=size(sig_long)) || nnz(size(price) ~= size(sig_short))
    error('input data must be same size');
end

if ~exist('initBp','var'), initBp = 15; end % Ĭ��15���㴥��ֹӯ����

if isempty(bp) && isempty(pct), error('must set one of bp and pct'); end 
if ~exist('bp','var'),  bp  = 3000; end
if ~exist('pct','var'), pct = 1 ; end 

[ nPeriod , nAsset ] = size(sig_long);
out_long  = sig_long;
out_short = sig_short;

% ����ֹӯλ��

for jAsset = 1:nAsset
    % ��ʼ��״̬�����ͼ۸�Ĵ���
    rs_long  = 0;
    monitorLongStopWin = 0;
    longWaterMarkPrice = 0;
    
    rs_short = 0;
    monitorShortStopWin = 0;
    shortWaterMarkPrice = 0;
    
    for iPeriod = 1:nPeriod
        tradeLong   = sig_long(iPeriod, jAsset);
        tradeShort  = sig_short(iPeriod, jAsset);
        nowPrice    = price(iPeriod, jAsset);
        % ��ͷ
        if rs_long == 0
            if tradeLong ==1
                rs_long = 1;
                priceLong = nowPrice;
             end
           
        elseif rs_long == 1
            if tradeLong == -1
                rs_long = 0;
                priceLong = 0;
            else
                if monitorLongStopWin == 0 %ӯ������initBp ��ʼ�۲�ֹӯ����
                    if nowPrice >= priceLong + initBp
                        monitorLongStopWin = 1;
                        longWaterMarkPrice = nowPrice;
                    end
                else  % �ڹ۲�ֹӯ�����£����۸����ˮ���·�bp��pct�ٷֱ�ʱƽ�֣�״̬�����ָ�����¼ƽ�ֵ�
                    if nowPrice <= max(longWaterMarkPrice-bp, longWaterMarkPrice*(1-pct))
                        rs_long = 0;
                        longWaterMarkPrice =0;
                        monitorLongStopWin = 0;
                        out_long(iPeriod, jAsset) = -1;
                    else % ���������ز֣����������ˮ��
                        longWaterMarkPrice = max(longWaterMarkPrice, nowPrice);
                    end
                end
            end
        end
        
        % ��ͷ
        if rs_short == 0
            if tradeShort == -1
                rs_short = -1;
                priceShort = nowPrice;
            end
        elseif rs_short == -1
            if tradeShort == 1
                rs_short = 0;
                priceLong = 0;
            else
                if monitorShortStopWin == 0
                    if nowPrice <= priceShort - initBp
                        monitorShortStopWin = 1;
                        shortWaterMarkPrice = nowPrice;
                    end
                else
                    if nowPrice >= max(shortWaterMarkPrice + bp, shortWaterMarkPrice*(1+pct))
                        rs_short = 0;
                        shortWaterMarkPrice = 0;
                        monitorShortStopWin = 0;
                        out_short(iPeriod,jAsset) = 1;
                    else
                        shortWaterMarkPrice = min(shortWaterMarkPrice, nowPrice);
                    end
                end
            end
        end
    end
end
 



end %EOF

