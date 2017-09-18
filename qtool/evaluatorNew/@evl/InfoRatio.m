function[ infoRatio ] = InfoRatio( nav, benchmark)
%����������ڼ���Information raio
%[ infoRatio ] = infoRatio( nav, benchmark,)
%nav: ���ʲ�
% benchmark:��׼���ʲ�
% ��������������������
% ��һ�� 20150511


%% main
delta       = evl.nav2yield(nav)-evl.nav2yield(benchmark);
sigma       = std(delta)*sqrt(365);
infoRatio   = (evl.annualYield(nav)-evl.annualYield(benchmark))/sigma;

end

