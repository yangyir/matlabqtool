function [ aYield ]  = annualYield( nav, period)
% ����һ��ʱ��Period��nav�������껯yield
% [ aYield ]  = AnnualYield( nav, period)
% nav:  ��ֵ���У���һ��Ԫ��Ϊ1
% period��ȡ����ֵ�� d365, d360, d245, w, m, q, y,Ĭ��Ϊd365
% ע�⣬������ͨ��nav����yield��ʱ��ͳһ��������ɢ�����ļ��㷽��
% Ҳ����˵��r=x(end)/x(1)-1
% ------------------
% ��һ�Σ�20150510
% �̸գ�20150529������ periodֵ 'w'

%% Ԥ����
if ~exist('period','var')
    period='d365';
end
%% Main
N = length(nav);

% ȫʱ������
yield = nav(end)/nav(1)-1;

% �껯
if strcmp(period,'d365')
    aYield = yield*365/N;
elseif strcmp(period,'d360')
    aYield = yield*360/N;
elseif strcmp(period,'d245')
    aYield = yield*245/N;
elseif strcmp(period,'w')
    aYield = yield * 50/N;
elseif strcmp(period,'m')
    aYield = yield*12/N;
elseif strcmp(period,'q')
    aYield = yield*4/N;
elseif strcmp(period,'y')
    aYield = yield*1/N;
end

end

