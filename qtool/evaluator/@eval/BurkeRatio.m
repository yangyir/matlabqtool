function burkeR  = BurkeRatio(navOrRate, rf, flag)
% ���������ڼ���burke ratio
% navOrRate �ʲ���ֵ�����
% rf �޷���������
% flag 'val'��ʾ��ֵ��'pct'��ʾ�ٷֱȱ仯��Ĭ��Ϊ'pct'

if nargin < 3
    flag = 'pct';
end

if strcmp( flag, 'val');
    navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
end

lrf = log(1+rf)/250;
[nPeriod, nAsset]=size(navOrRate);

maxLret = navOrRate(1,:);
maxDown =zeros(1,nAsset);

for iPeriod = 2:nPeriod-1
    maxLret = max([maxLret;navOrRate(iPeriod,:)]);
    maxDown(iPeriod,:)=navOrRate(iPeriod,:)-maxLret;
end
normMaxDown = zeros(1,nAsset);

for jAsset = 1:nAsset
    normMaxDown(jAsset) = norm(maxDown(:,jAsset));
end

burkeR = (mean(navOrRate)-lrf)./normMaxDown;

end
%{
previous version:
function burkeR = burkeRatio( R,Rf )
loc = isnan(R) | isnan(Rf);

R (loc) = [];
Rf(loc) = [];
md = MD(R);
md(md==0) = [];
burkeR = mean(R-Rf)/norm(md);
% ����Ӻ������ڼ���س�
    function md = MD(Data)
        high = zeros(size(Data));
        md = zeros(size(Data));
        for t = 2:length(Data)
            high(t)=max(high(t-1),Data(t));
            md(t)=Data(t)-high(t);
        end
    end

end
%}
