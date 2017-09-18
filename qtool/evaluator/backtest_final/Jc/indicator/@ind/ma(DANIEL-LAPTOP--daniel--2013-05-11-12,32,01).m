function [maVal] = ma(price,lag,flag)
% Moving Average
% [maVal] = ma(price,lag,flag)
% price����������ʲ��۸�����
% lag��   �ͺ���� ��Ĭ�� 10��
% flag��  MA���㷽��
%         e = ָ���ƶ�ƽ��
%         0 = ���ƶ�ƽ��
%         0.5 = ƽ������Ȩƽ��
%         1 = ����ƽ��
%         2 = ƽ����Ȩƽ��

% ����Ԥ�����Լ����������С
[nPeriod, nAsset] = size(price);

if nargin<2 || isempty(lag)
    lag=10;
end
if nPeriod<lag
    error('data is too short');
end

if nargin<3 || isempty(flag)
    flag = 'e';
end

maVal = nan(nPeriod, nAsset);

% ��������ʲ��ƶ�ƽ��
if flag =='e'
    for iAsset = 1:nAsset
        param = 2/(lag+1);
        idxFirst = find(~isnan(price(:,iAsset)),1,'first');
        if isempty(idxFirst) || idxFirst==nPeriod
            continue
        else
            maVal(idxFirst,iAsset) = price(idxFirst,iAsset);
            for jPeriod = idxFirst+1:nPeriod
                maVal(jPeriod,iAsset) = maVal(jPeriod-1,iAsset)+param*(price(jPeriod,iAsset)-maVal(jPeriod-1,iAsset));
            end
        end
    end
else
        j = 1: lag;
        w = (lag-j+1).^flag./sum([1:lag].^flag);
        for iAsset = 1:nAsset
            idxFirst = find(~isnan(price(:,iAsset)),1,'first');
            if isempty(idxFirst) || idxFirst==nPeriod
                continue
            else
                maVal(idxFirst:end,iAsset) = filter(w,1,price(idxFirst:end,iAsset));
            end
        end
end
maVal(1:lag,:) = nan;
end