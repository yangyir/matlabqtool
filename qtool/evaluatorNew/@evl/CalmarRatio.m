function [ calmarR ] =CalmarRatio( nav, rf, period)
% ���������ڼ���calmarR
% [ calmarR ] =CalmarRatio( nav, rf)
% nav: �ʲ���ֵ
% rf: �޷��������ʣ�Ĭ��5%
% period: ��ȡ����ֵ�� d365, d360, d245, w, m, q, y,Ĭ��Ϊd365
% ------------------------------
% ��һ�Σ�20150510����д��main
% ��һ�Σ�201505511������������Ϊ�����ܲ���nav��������yield����ͬʱɾȥflag
% �̸�, 20150525, mdd�ñ���������value
% �̸գ�20150530���������period


%% ǰ����
if ~exist('rf','var')
    rf=0.05;
end

if ~exist('period','var')
    period='d365';
end

%% main
yield   = evl.annualYield(nav, period);
mdd     = evl.maxDrawDown(nav);
calmarR = ( yield - rf ) / mdd;

end

