function alpha = alpha( nav, benchmark, rfr,period)
% ���������ڼ���alphaϵ��
% alpha = Alpha( nav, benchmark, rf)
%   nav �ʲ���ֵ
%   benchmark �г�����ֵ
%   rfr �޷���������
%   period �������ڣ� 'w','m','q','y','d360','d365','d245'
% --------------------------------------
% panqichao������
% �̸գ�20150510���Ը�
% ��һ�Σ�20150511����������Ϊ������nav������rate�����Σ���ͬʱɾȥ����flag
% ��һ�Σ�20150729�������˼����е��껯����

%% Ԥ����
% �޷�������Ĭ�� 5%
if ~exist('rfr','var'), rfr = 0.05; end

if ~exist('period','var')
    period='d365';
end
%% main
% �Ծ�ֵ����ȡlog

beta = evl.beta(nav,benchmark);

yieldBmark = evl.annualYield(benchmark,period);

yieldNav = evl.annualYield(nav,period);

alpha = yieldNav - rfr - beta * (yieldBmark - rfr); 

end
