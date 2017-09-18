% [comp_closeprices,comp_closeprices1,residual]= PCA(closeprices,0.9);
function [princomp_closeprices,princomp_closeprices1,residual]= PCA(closeprices,threshold)

% ��closeprices��׼��
mean_closeprices =  mean(closeprices,1);
std_closeprices = std(closeprices,0,1);
standard_closeprices = (closeprices-repmat(mean_closeprices,size(closeprices,1),1))./repmat(std_closeprices,size(closeprices,1),1);
% % ����ֱ����zscore
% standard_closeprices = zscore(closeprices);

[n,p] = size(standard_closeprices);
cov_standard_closeprices = standard_closeprices'* standard_closeprices/(n-1);
[eigvectors,eigvalues] = eig(cov_standard_closeprices);
eigvalues = diag(eigvalues);
[latent,subindex] = sort(eigvalues,'descend');
coeff = eigvectors(:,subindex);

% ���ɷ�
princomp_closeprices = standard_closeprices*coeff;
% ÿ�����ɷֵĹ���
percent = latent./sum(latent);
% ���ɷ��ۼƹ���
cumpercent = cumsum(latent)./sum(latent);
a = find( cumpercent < threshold);
m = a(end)+1;

% ȡǰm�����ɷ�
princomp_closeprices1 = princomp_closeprices(:,1:m);

% �в�
reconstructed = repmat(mean_closeprices,n,1) + repmat(std_closeprices,n,1).*(princomp_closeprices(:,1:m)*coeff(:,1:m)');
residual = closeprices-reconstructed;
end