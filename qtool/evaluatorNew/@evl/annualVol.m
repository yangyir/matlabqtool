function [ aVol ]    = annualVol( nav, period)
% ����nav����������period���͸����ļ��ʽcalendar������껯������vol
% [ aVol ]    = AnnualVol( nav, period)
%   nav:  ��ֵ���У���һ��Ԫ��Ϊ1
%   period��ȡ����ֵ�� d365, d360, d245, w, m, q, y,Ĭ��Ϊd365
%   aVol�� �겨����
% ע�⣬������ͨ��nav����yield��ʱ��ͳһ��������ɢ�����ļ��㷽��
% Ҳ����˵��r=x(t+1)/x(t) - 1
% ------------------
% ��һ�Σ�20150510
% �̸գ�20150529������ periodֵ 'w'


%% Ԥ����
if ~exist('period','var')
    period='d365';
end


%% Main
% N = length(nav);
yield   = evl.nav2yield(nav,'compound');
sigma   = std(yield);

% �껯ʱ��ֻ�����ݼ���йأ������ݳ����޹�
if strcmp(period,'d365')
    aVol = sigma*sqrt(365);
elseif strcmp(period,'d360')
    aVol = sigma*sqrt(360);
elseif strcmp(period,'d245')
    aVol = sigma*sqrt(245);
elseif strcmp(period,'w')
    aVol = sigma * sqrt( 50 );
elseif strcmp(period,'m')
    aVol = sigma*sqrt(12);
elseif strcmp(period,'q')
    aVol = sigma*sqrt(4);
elseif strcmp(period,'y')
    aVol = sigma*sqrt(1);
end

end

