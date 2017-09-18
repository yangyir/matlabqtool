function [sig_long, sig_short] = Willr(ClosePrice,HighPrice,LowPrice,nday,thred1, thred2, type)
%����williamsֵ�Լ���Ӧ�Ľ����ź�(-1,0,1)
%����
%�����ݡ�ClosePrice,HighPrice,Lowprice
%�������� nday�ƶ�ƽ��������������Ȼ����
%��������ź�
%   Yan Zhang   version 1.0 2013/3/12

%willr>-20, ����״̬������������ź�Ϊ-1
%willr<-80, ����״̬��������ף��ź�Ϊ1 
%   Yan Zhang   version 1.1 2013/3/21

%% Ԥ����
if nargin <3
    error('not enough input');
end


if ~exist('nday', 'var') || isempty(nday), nday = 14; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ����willrֵ
willrval = -ind.willr( HighPrice, LowPrice, ClosePrice,nday);

%% �����ź�
if type==1
    sig_long = double(crossOver(willrval, thred1 * ones(size(willrval)), 1));
    sig_short = -crossOver(thred2*ones(size(willrval)), willrval, 1);
else

end