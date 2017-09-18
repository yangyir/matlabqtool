function [sig_long, sig_short] = Alligator(HighPrice,LowPrice,ClosePrice, fast, mid, slow, delta,type)
%����alligator������Ӧ�Ľ����ź�(-1,0,1)
%���� 
%�����ݡ�ClosePrice,HighPrice
%�������� �о���Ըߵ͵���ֵdelta=0.01;
% ��� 
%pos �����źţ��Լ�alligator��������ֵ linegreen linered lineblue �ֱ�Ϊ 5�� 8�� 13��sma
%   Yan Zhang   version 1.0 2013/3/12
%
%��ʱС���߱���ʱ�������Ը߳�һ����ֵ��sig_long�ź�Ϊ1
%��ʱ����߱���ʱС������Եͳ�һ����ֵ, sig_short�ź�Ϊ-1
%Yan Zhang   version 1.1 2013/3/21

%% Ԥ����
if nargin <3
    error('not enough input');
end

if ~exist('delta','var') || isempty(delta), delta = 0.01; end
if ~exist('type','var') || isempty(type), type = 1; end
if ~exist('fast', 'var') || isempty(fast), fast = 3; end
if ~exist('mid', 'var') || isempty(mid), mid = 7; end
if ~exist('slow', 'var') || isempty(slow), slow = 15; end


%%  ����Alligator��ֵ

[nPeriod , nAsset] = size(LowPrice);
[line1 line2 line3]= ind.alligator(HighPrice,LowPrice, fast, mid, slow);
%%   �����ź�
sig_long=zeros(nPeriod,nAsset);
sig_short=zeros(nPeriod,nAsset);
if type==1
%      for jAsset=1:nAsset
%         sig_long(1:end-1, jAsset) = (line1(1:end-1,jAsset)<line2(1:end-1,jAsset) &  line1(2:end,jAsset)>line2(2:end,jAsset)) & (line2(1:end-1,jAsset)<line3(1:end-1,jAsset) &  line2(2:end,jAsset)>line3(2:end,jAsset)) 
%         sig_short(1:end-1, jAsset) = (line1(1:end-1,jAsset)>line2(1:end-1,jAsset) &  line1(2:end,jAsset)<line2(2:end,jAsset)) & (line2(1:end-1,jAsset)>line3(1:end-1,jAsset) &  line2(2:end,jAsset)<line3(2:end,jAsset)) 
%     end
    for j=1:nAsset
    for i=1:nPeriod
        if (ClosePrice(i,j)/line1(i,j)-1>delta) && (line1(i,j)/line2(i,j)-1>delta) && (line2(i,j)/line3(i,j)-1>delta)
            sig_long(i,j)=1;
        elseif (ClosePrice(i,j)/line1(i,j)-1<-delta) && (line1(i,j)/line2(i,j)-1<-delta) && (line2(i,j)/line3(i,j)-1<-delta)
            sig_short(i,j)=-1;
        end
    end
    end
else
    for j=1:nAsset
    for i=1:nPeriod
        if (ClosePrice(i,j)/line1(i,j)-1>delta) && (line1(i,j)/line2(i,j)-1>delta) && (line2(i,j)/line3(i,j)-1>delta)
            sig_long(i,j)=1;
        elseif (ClosePrice(i,j)/line1(i,j)-1<-delta) && (line1(i,j)/line2(i,j)-1<-delta) && (line2(i,j)/line3(i,j)-1<-delta)
            sig_short(i,j)=-1;
        end
    end
    end
end

