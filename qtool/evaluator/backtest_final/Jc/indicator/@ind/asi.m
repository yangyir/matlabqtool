function  [asiVal, siVal] = asi(OpenPrice, HighPrice, LowPrice, ClosePrice)
% ASI accumulate swing index
% 返回 asi, si
%【数据】 开盘，最高，最低，收盘
% daniel 2013/4/16

% 预处理
[nPeriod, nAsset] = size(OpenPrice);
asiVal = zeros(nPeriod, nAsset);
siVal  = zeros(nPeriod, nAsset);

% 计算步
A = abs(HighPrice - [nan(1,nAsset);ClosePrice(1:end-1,:)]);
B = abs(LowPrice  - [nan(1,nAsset);ClosePrice(1:end-1,:)]);
C = abs(HighPrice - [nan(1,nAsset);  LowPrice(1:end-1,:)]);
D = abs([nan(1,nAsset);ClosePrice(1:end-1,:)] - [nan(1,nAsset);OpenPrice(1:end-1,:)]);
E = ClosePrice - [nan(1,nAsset);ClosePrice(1:end-1,:)];
F = ClosePrice - [nan(1,nAsset);OpenPrice(1:end-1,:)];
G = [nan(1,nAsset);ClosePrice(1:end-1,:)] - [nan(1,nAsset);OpenPrice(1:end-1,:)];
X = E + 0.5* F + G;
K = max(A , B);
idxA = find(A >= B & A >= C);
idxB = find(B > A  & B >= C);
idxC = find(C > A  & C >B  );

R1 = A + 0.5*B + 0.25*D;
R2 = B + 0.5*A + 0.25*D;
R3 = C + 0.25*D;

R = nan(nPeriod, nAsset);
R(idxA) = R1(idxA);
R(idxB) = R2(idxB);
R(idxC) = R3(idxC);

siVal= 50/3*X.*K./R;
siVal(isnan(siVal))=0;
asiVal = cumsum(siVal);

end 











