function  obvVal  = obv( ClosePrice, Volume )
% on-balance volume 
% ���� close, vol �ֱ�Ϊ���յ����̼��Լ���������
% daniel 2013/4/16

% Ԥ����
[nPeriod, nAsset]  =  size(ClosePrice);
obvVal  =  zeros(nPeriod, nAsset);

% ���㲽
for i = 1:nAsset
    obvVal(:,i)  =  onbalvol( ClosePrice(:,i), Volume(:,i) );
end

end

