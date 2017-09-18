function burkeR  = BurkeRatio(nav, rf)
% 本函数用于计算burke ratio
% nav 资产净值
% rf 无风险年利率
% -----------------------
% pan qichao, 不详
% 程刚，20150510，小改
% 唐一鑫，20150511重写main, 将函数参数调整为仅含nav,并且修改了部分函数体


% if ~exist('flag', 'var') 
%     flag = 'pct';
% end

%% main
% if strcmp( flag, 'val');
%     navOrRate = log(navOrRate(2:end,:)./navOrRate(1:end-1,:));
% end
% 
% lrf = log(1+rf)/250;
% [nPeriod, nAsset]=size(navOrRate);
% 
% maxLret = navOrRate(1,:);
% maxDown =zeros(1,nAsset);
% 
% for iPeriod = 2:nPeriod-1
%     maxLret = max([maxLret;navOrRate(iPeriod,:)]);
%     maxDown(iPeriod,:)=navOrRate(iPeriod,:)-maxLret;
% end
% normMaxDown = zeros(1,nAsset);
% 
% for jAsset = 1:nAsset
%     normMaxDown(jAsset) = norm(maxDown(:,jAsset));
% end
% 
% burkeR = (mean(navOrRate)-lrf)./normMaxDown;
% 
% end

% %main
% previous version:
% function burkeR = burkeRatio( R,Rf )
% loc = isnan(R) | isnan(Rf);
% 
% R (loc) = [];
% Rf(loc) = [];
% md = MD(R);
% md(md==0) = [];
% burkeR = mean(R-Rf)/norm(md);
% % 这个子函数用于计算回撤
%     function md = MD(Data)
%         high = zeros(size(Data));
%         md = zeros(size(Data));
%         for t = 2:length(Data)
%             high(t)=max(high(t-1),Data(t));
%             md(t)=Data(t)-high(t);
%         end
%     end
% 
% end

%% 预处理
if ~exist('rf','var')
    rf = 0.05;
end


%% 重写main

Rate    = log(nav(2:end)./nav(1:end-1));
nPeriod = size(Rate,2);
maxLret = Rate(1);
maxDown = zeros(nPeriod-1,1);
for iPeriod=2:nPeriod       
    maxLret             = max(maxLret,Rate(iPeriod));
    maxDown(iPeriod-1)  = Rate(iPeriod)-maxLret;
end
normMaxDown = norm(maxDown);
burkeR      = (evl.annualYield(nav)-rf)/normMaxDown;
















