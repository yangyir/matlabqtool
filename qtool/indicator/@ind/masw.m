function [ masw, indexmat ] = masw( price, mas )
%masw ����ǿ��ָ��
%   ����ǿ��ָ�����ö�����߸���ǰ�ʲ����
%   С�����о��ߵ�1�֣����ڵ�һС��С�ڵڶ�С��2�֣��Դ�����
%   inputs��
%       price: �����ʲ���
%       mas�����ھ��ߴ�ֵľ��ߣ�Ĭ�ϰ˾���[8, 13, 21, 34, 55, 89, 144, 233])
%   outputs:
%       masw: ���ʲ�����ǿ��ָ���ĺͣ�������(nan, 1*nasset, 2*nasset��)
%       indexmat: �����ʲ���ָ�����

if ~exist('mas', 'var') || isempty(mas)
    mas = [8, 13, 21, 34, 55, 89, 144, 233]; 
end

nma = length(mas);
[nperiod, nasset] = size(price);
pma = nan(nperiod, nasset, nma);
indexmat = nan(nperiod, nasset);
% masw = nan(nperiod, 1);
for iasset = 1:nasset
    for ima = 1: nma
        pma(:, iasset, ima) = ind.ma(price(:, iasset), mas(ima));
    end
    % ��pma����
    sort(pma(:, iasset, :), 2);
end

for iasset = 1:nasset
    for iperiod = 1:nperiod
        if sum(isnan( pma(iperiod, iasset, :))) > 0, continue; end
        % ���㵱ǰ�۸�����
        for ima = 1:nma
            if price(iperiod, iasset) < pma(iperiod, iasset, ima)
                indexmat(iperiod, iasset) = ima;
                break;
            end
        end
        if price(iperiod, iasset) > pma(iperiod, iasset, ima)
            indexmat(iperiod, iasset) = nma + 1;
        end
    end
end

masw = sum(indexmat, 2);