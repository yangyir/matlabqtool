function [sig_rs] = Cmf ( HighPrice, LowPrice, ClosePrice, Volume, nDay,threshold,type)
% Chaikin Money Flow ����ǿ���ź�
% daniel 2013/4/2

%% Ԥ����

[nPeriod, nAsset] = size(ClosePrice);
sig_rs = zeros(nPeriod,nAsset);

if ~exist('threshold', 'var') || isempty(threshold), threshold = 0.05; end
if ~exist('nDay', 'var') || isempty(nDay), nDay = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end
threshold = abs(threshold);
%% ���㲽

cmfVal = ind.cmf ( HighPrice, LowPrice, ClosePrice, Volume, nDay);


%% �źŲ�
% cfm������ֵʱ����ʾ����Ԥʾ�����г��µ�
% �෴��С����ֵʱ����ʾ������Ԥʾ��������
if type==1
sig_rs(cmfVal<-threshold) =  1;
sig_rs(cmfVal>threshold)  =  -1;
else
;
end
end %EOF
