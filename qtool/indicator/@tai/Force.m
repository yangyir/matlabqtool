function [sig_rs] = Force(ClosePrice,TradeVol,nday,thresh, type)
%����forceindex
%����

%�����ݡ�ClosePrice,TradeVol
%�������� nday�ƶ�ƽ��������������Ȼ����,thresh ��ӳ����������ֵ
% ���Ϊforce�Ľ����ź� signal
%   Yan Zhang   version 1.0 2013/3/12
% Ĭ�ϵ�����Ϊ13

%force>thresh, ������ǿ���ź�Ϊ-1
%force<-thresh, �����������ź�Ϊ1
%   Yan Zhang   version 1.1 2013/3/21

%%  Ԥ����
if nargin <2
    error('not enough input');
end

if ~exist('type', 'var') || isempty(type), type = 1; end
if ~exist('nday', 'var') || isempty(nday), nday = 13; end
if ~exist('thresh', 'var') || isempty(thresh), thresh = 50; end

%% ����forceֵ
 forcevalue=ind.force(ClosePrice,TradeVol,nday);
%% �����ź�
if type==1
sig_rs=(forcevalue>thresh)*(-1)+((forcevalue<-thresh)*(1));
else
;
end
