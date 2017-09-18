function [sig_long,sig_short,sig_rs] = Kdj(ClosePrice,HighPrice,LowPrice,thred1, thred2, nday,m, l, type)
%����kdjֵ�Լ���Ӧ�Ľ����ź�(-1,0,1)
%����
%�����ݡ�ClosePrice,HighPrice,Lowprice
%�������� nday�ƶ�ƽ��������������Ȼ����,type  ��ʾma������̵�ϵ��ѡ��ʽ 
%type 1 [2/3 1/3] type 2 [(n-1)/n 1/n]
%��������ź�
%   Yan Zhang   version 1.0 2013/3/12 

%   sig_long  ��K�ϴ�30ʱ�����룬�ź�Ϊ1 ���ź�Ϊ1��K��thred2���£�K��D�������棬�źŸ�Ϊ-1 
%   sig_short ��K�´�thred2ʱ���������ź�Ϊ-1 ���ź�Ϊ-1��K��30���ϣ�K��D�������棬�źŸ�Ϊ-1 
%   sig_rs   K<30���������ź�Ϊ1��K��thred2�������ź�Ϊ-1
%   Yan Zhang   version 1.1 2013/3/12 
%   lu huaibao   version 1.2 2013/08/29,��30��70�޸ĳ�thred1��thred2��ע�͵�Ԥ�����µ�ǰ���У���ΪĬ�ϲ����ܶࡣ

%% Ԥ����
% if nargin <3
%     error('not enough input');
% end
if ~exist('nday', 'var') || isempty(nday), nday = 9; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ����kdjֵ 
[nPeriod , nAsset] = size(ClosePrice);
[k,d] = ind.kdj(ClosePrice,HighPrice,LowPrice,nday, m, l);
 %% �����ź�
 if type==1
    sig_long=zeros(size(ClosePrice));
    sig_short=sig_long;
    sig_long(2:end,:)=((k(2:end,:)>thred1) & (k(1:end-1,:)<thred1));
    sig_short(2:end,:)=((k(2:end,:)<thred2) & (k(1:end-1,:)>thred2))*(-1);
    sig_rs=k<thred1+(k>thred2)*(-1);
 else
     sig_long=zeros(size(ClosePrice));
     sig_short=sig_long;
     sig_long(2:end,:)=((k(2:end,:)>thred1) & (k(1:end-1,:)<thred1));
     sig_short(2:end,:)=((k(2:end,:)<thred2) & (k(1:end-1,:)>thred2))*(-1);

     for i=1:nAsset
        for j=2:nPeriod-1
            if sig_long(j-1,i)==1 && k(j,i)<thred2 && k(j-1,i)>d(j-1,i) && k(j+1,i)<d(j+1,i)
                 sig_long(j,i)=-1;
            elseif sig_short(j-1,i)==-1 && k(j,i)>thred1 && k(j-1,i)<d(j-1,i) && k(j+1,i)>d(j+1,i)
                 sig_short(j,i)=1;
            end;
        end
     end
    sig_rs=k<thred1+(k>thred2)*(-1);
end
