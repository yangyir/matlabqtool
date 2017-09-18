%% 两个资产，有相关性矩阵，有权重向量
% 看总指数的期权定价
% 看分别买各个资产期权的定价
% 看价格跟相关性矩阵的关系

%%
w = [0.3,  0.7];

cor = [1, -0.5; -0.5, 1];
sigma = [0.2, 0.4];
mu = [0.05, 0.05];

for i = 1:2
    for j = 1:2
        SIGMA(i,j) = sigma(i)*cor(i,j)*sigma(j);
    end
end

sigma_basket  = sigma * cor * sigma';
   

%% 生成两条路径

t = ( 1:20 ) /252;
MU = ( mu' * t  )';

%
S = mvnrnd( [0.05, 0.05], SIGMA, 100);


t = ones(100,2);
MU = t * mu'
S = mvnrnd( MU, SIGMA, 100);


S_basket = S * w';


figure(123);hold off
plot(S)
hold on; 
plot(S_basket, 'r')


%% 回过头算sigma和cov

cov2 = cov(S(:,1), S(:,2));
sigma2 = zeros( size(sigma) );
cor2 = zeros( size(cor) );

for i = 1:2
    sigma2(i) = sqrt(  cov2(i, i )  );
end

for i = 1:2
    for j = 1:2
        cor2(i,j) = cov2(i,j)/sigma2(i)/sigma2(j);
    end
end

cov2
sigma2
cor2

% cor2 = cov2 ./  sigma2 


%% 基础数学验证
% 
% B = rand(10,1);
% B2 = -B;
% sigma1 = std(B);
% sigma2 = std(B2);
% v1 = sigma1^2;
% v2 = sigma2^2;
% COV = cov( B, B2);
% COR = corrcoef(B, B2);
% % 验证：
% COV_theo == [sigma1, sigma2]' * [sigma1, sigma2] .* COR
% v = [sigma1, sigma2] * COR * [sigma1, sigma2]'
% 
% 

%% 验证期权
% MC生成10000条
