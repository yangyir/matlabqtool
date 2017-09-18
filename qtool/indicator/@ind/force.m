function  forceVal = force(ClosePrice,Volume,nDay)
% force index
% ���� Close,volume,��ʾ���ڵ�nDay��Ĭ�� 13��

% Ԥ����
if ~exist('nDay','var') 
    nDay = 13;
end
[~, nAsset] = size(ClosePrice);

% ���㲽
% FORCE INDEX (i) = VOLUME (i) * ((MA (ApPRICE, N, i) - MA (ApPRICE, N, i-1))
MA = ind.ma(ClosePrice,nDay,'s');
diffMA = [nan(1:nAsset) ; diff(MA)];
forceVal = Volume.* diffMA;

end %EOF




 