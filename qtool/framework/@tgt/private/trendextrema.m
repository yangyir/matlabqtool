function [textrema]=trendextrema(data,mu1,mu2)
%dataΪ�����ʱ������
%mu1Ϊ��Ӧ�Ĺ�ֵ��ֵ�� mu2Ϊ��Ӧ�ķ�ֵ��ֵ
%dataΪ����
%���ص���ֵ trendsig 1,0,-1 �ֱ��ʾ�������񵴡��½�
%version 1.00 by zhangyan 2013-4-2
if nargin<3
    mu1=0.02;
    mu2=0.02;
end
pv=zeros(length(data-1),1);

for i=2:length(data-1)
    pv(i)=peakvalley(data,i,mu1,mu2);
end
if ~nnz(pv)
    textrema=zeros(length(data),1);
    return;
end
[textrema,~]=trendseries(pv,data,2);
end