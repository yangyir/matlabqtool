function beta = beta( nav, benchmark)
% ���������ڼ���betaϵ��
% beta = beta( nav, benchmark)
%   nav �ʲ���ֵ
%   benchmark �г�����ֵ
%---------------
%��һ�� 20150511 ��������д��������nav������rate,��ɾȥ��flag
% 2015.8.17,lu,ʹ��log��ǰ����navΪ�������navΪ������ô�����ʹ�ô�ͳ�����ʷ�ʽ




%% main
% 2015.8.17�޸���������
%  Rate       = log(nav(2:end,:)./nav(1:end-1,:));
%  benchmark  = log(benchmark(2:end,:)./benchmark(1:end-1,:));
 Rate       = diff(nav)./nav(1:end-1,:) ;
 benchmark  = diff(benchmark)./benchmark(1:end-1,:) ;
 
 nAsset = size(Rate, 2);
 beta   = zeros(1,nAsset);
 
 for iAsset      = 1:nAsset;
    covMatrix    = cov(Rate(:,iAsset), benchmark);     
    beta(iAsset) = covMatrix(1,2)/covMatrix(2,2);
 end
end
 




