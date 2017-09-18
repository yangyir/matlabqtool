% [comp_closeprices,comp_closeprices1,residual]= PCA(closeprices,0.9);
function [princomp_closeprices,princomp_closeprices1,residual]= PCA(closeprices,threshold)

% 将closeprices标准化
mean_closeprices =  mean(closeprices,1);
std_closeprices = std(closeprices,0,1);
standard_closeprices = (closeprices-repmat(mean_closeprices,size(closeprices,1),1))./repmat(std_closeprices,size(closeprices,1),1);
% % 或者直接用zscore
% standard_closeprices = zscore(closeprices);

[n,p] = size(standard_closeprices);
cov_standard_closeprices = standard_closeprices'* standard_closeprices/(n-1);
[eigvectors,eigvalues] = eig(cov_standard_closeprices);
eigvalues = diag(eigvalues);
[latent,subindex] = sort(eigvalues,'descend');
coeff = eigvectors(:,subindex);

% 主成分
princomp_closeprices = standard_closeprices*coeff;
% 每个主成分的贡献
percent = latent./sum(latent);
% 主成分累计贡献
cumpercent = cumsum(latent)./sum(latent);
a = find( cumpercent < threshold);
m = a(end)+1;

% 取前m个主成分
princomp_closeprices1 = princomp_closeprices(:,1:m);

% 残差
reconstructed = repmat(mean_closeprices,n,1) + repmat(std_closeprices,n,1).*(princomp_closeprices(:,1:m)*coeff(:,1:m)');
residual = closeprices-reconstructed;
end