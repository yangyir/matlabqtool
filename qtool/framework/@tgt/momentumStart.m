function [ score ] = momentumStart( seq,window_param )
%MOMENTUMSTART gives high score to momentum starting points
% score           ȡֵ[ -4 : +4 ], pos: up trend; neg: down trend
% seq             ���������
% window_param    ȡֵ(0,1),Ĭ��0.01, ������ƽ�봰�� = window_param * length(seq) 
% ver1.0; Cheng,Gang; 20130409
% ver1.1; Cheng,Gang; 20130416; ����window_param����



%% pre-process
if ~exist('window_param', 'var') 
    window_param = 0.01;
end

%% CMA(Centric Mov. Avg.������ƽ) as trend
len = length(seq);
semi_window = ceil(len * window_param);
cma = tai.Cma( seq, semi_window);


%% cma ��б��(�ȵ���ƽ����, kһ�ף�kk����
[k, kk ] = calck(cma);


%% �ֲ㣬��ɢ���
score = nan(len,1);

pct = [0;30;45;55;70;100];
pctl = prctile(k, pct);

% ������һ�׵� 
score( k<pctl(2)                ) = -2;
score( pctl(2)<=k & k<pctl(3)   ) = -1;
score( pctl(3)<=k & k<pctl(4)   ) = 0;
score( pctl(4)<=k & k<pctl(5)   ) = 1;
score( k>=pctl(5)               ) = 2;

% Ҳ���ݶ��׵�
dscore = zeros(len,1);
dscore( k<pctl(2) & kk<0        ) = -2;
score = score + dscore;

dscore = zeros(len,1);
dscore( k>=pctl(5) & kk>0       ) = 2;
score = score + dscore;



end

