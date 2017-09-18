function [pvtVal] = pvt(ClosePrice,Volume)
% Price Volume Trend ��������ָ��
% daniel 2013/4/16

% Ԥ����
[nPeriod, nAsset] = size(ClosePrice);
pvtVal = zeros(nPeriod, nAsset);

% ���㲽
% �����x��(�������̼ۡ��������̼�)���������̼ۡ����ճɽ�����
% ��ô����PVTָ��ֵ��Ϊ�ӵ�һ����������ÿ��Xֵ���ۼӡ�
pvtVal = [nan(1,nAsset); (ClosePrice(2:end,:)./ClosePrice(1:end-1,:)-1)].*Volume;
pvtVal(isnan(pvtVal)) = 0 ;
pvtVal = cumsum(pvtVal);

end %EOF



