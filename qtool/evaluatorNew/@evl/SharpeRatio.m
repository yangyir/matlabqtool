function sharpeR = SharpeRatio( nav, rf, period )
% ���������ڼ���sharpe ratio
% sharpeR = SharpeRatio( nav, rf)
% nav: �ʲ���ֵ
% rf: �޷��������ʣ�Ĭ��5%
% period: ��ȡ����ֵ�� d365, d360, d245, w, m, q, y,Ĭ��Ϊd365
% ------------------------------
% Pan, qichao
% �̸գ�20150510��С��
% ��һ�Σ�20150510����д��main
% ��һ�Σ�201505511������������Ϊ�����ܲ���nav��������yield����ͬʱɾȥflag
% �̸գ�20150529������ period


%% ǰ����
if ~exist('rf','var')
    rf=0.05;
end

if ~exist('period','var')
    period='d365';
end


%% main
yield   = evl.annualYield(nav, period);
sigma   = evl.annualVol(nav, period);
sharpeR = (yield-rf) / sigma;

end

