function [extrema trendsig]=trendseries(pv,data,delay)
%  �����ݵ�ķ��ֵת��Ϊ��Ӧ������ͼ�����չ㷢֤ȯ-������̬ʶ��
%  pv �����ݵ�ķ��ֵ��data��ԭʼ��ʱ������
%  trend������ʱ������Ͷ�Ӧ������ͼ��ֵ
% -----------------------------------------------------
%  version 1.00 by zhangyan 2013-1-23
%  trendsig������ʱ����������һ��δ��һ��ʱ������ƣ�1Ϊ������-1Ϊ�½���0Ϊ��ȷ����  
%  delay�������źŵ���ʱ��
% 
% version 1.01 by zhangyan 2013-4-8
% thresh��1l��l2�������ڽ�����, l1�������Ǽ�ֵ��������Сֵ����l2�����������δ�����Ƶ����ݵ��������Щ���ݵ������l2����ֵ�㣬
% thresh�����ֱ��б���ж������½������õ�����ֵ
% 
% version 1.02 by zhangyan 2013-4-16
% l3 �������ƶλ���Ϊǰ�ڣ����ڣ����ڣ����費ͬ��Ȩ�أ�l3�����������ܺ͵���Сֵ��
%
% version 1.03 by daniel 2013-4-24
% �޸ģ���extremaֻ��1����ʱ����ĩ�Զ���������ĩβ�����ɰ���3�ַ������߶��ϵĵ���

thresh=3;
l1=3;
l2=15;
l3=6;


if nargin<=2
    delay=1;
end
extrema=zeros(length(data-1),2);
trendindex=1;
index=find(pv);
pv=pv(index);
if nnz(unique(pv))==1
     trendsig=zeros(length(data),1);
    return;
end
tdata=data(index);
sindex=find(pv~=0,1,'first');
eindex=find(pv(sindex:end)~=pv(sindex),1,'first')+sindex-2;
while(sindex<length(pv))
if pv(sindex)==1
    [a b]=max(tdata(sindex:eindex));
    extrema(trendindex,1)=index(b+sindex-1);
    extrema(trendindex,2)=tdata(b+sindex-1);
    trendindex=trendindex+1;
end
if pv(sindex)==-1
    [a b]=min(tdata(sindex:eindex));
    extrema(trendindex,1)=index(b+sindex-1);
    extrema(trendindex,2)=tdata(b+sindex-1);
    trendindex=trendindex+1;
end
sindex=eindex+1;
if sindex>=length(pv)
     break;
end
eindex=find(pv(sindex:end)~=pv(sindex),1,'first')+sindex-2;
if isempty(eindex)
    eindex=length(pv);
end
end
extrema=extrema(1:trendindex-1,:);
trendsig=zeros(size(data));
if extrema(1,2)-data(1)<0
    trendsig(1:extrema(1,1)-1)=-1;
else
     trendsig(1:extrema(1,1)-1)=1;
end
tstart=0;
tend=0;
i=0;

% �������1����ֵ������
if size(extrema,1) == 1
    tstart = max(extrema(1,1) - delay +1,1);
    tend   = length(data) - delay;
    tmiddle = extrema(1,1);
    if tend - extrema(1,1) < l1;
        if data(tend) > extrema(1,2)
            trendsig(tstart:tend) = 1;
        else 
            trendsig(tstart:tend) = - 1;
        end
    elseif data(tend) < extrema(1,2)
        interval = floor((tend-tmiddle)/3);
        trendsig((tmiddle+1):(tmiddle+interval))= -3;
        trendsig((tmiddle+interval+1):(tmiddle+2*interval))=-2;
        trendsig((tmiddle+2+2*interval):tend)=-1;
    elseif data(tend) > extrema(1,2)
        interval = floor((tend-tmiddle)/3);
        trendsig((tmiddle+1):(tmiddle+interval))= 3;
        trendsig((tmiddle+interval+1):(tmiddle+2*interval))=2;
        trendsig((tmiddle+2+2*interval):tend)=1;
    end
       
else
    
while (i<length(extrema)-1)
   i=i+1;
   tstart=max(extrema(i,1)-delay+1,1);
   tend=extrema(i+1,1)-delay;
   tmiddle=extrema(i,1);
       if extrema(i+1,1)-extrema(i,1)<l1;
           if i<length(extrema)-l2+1
               k=polyfit((extrema(i,1):extrema(i+l2-1,1))',data(extrema(i,1):extrema(i+l2-1,1)),1);
%                plot((trend(i,1):trend(i+l2-1,1))',data(trend(i,1):trend(i+l2-1,1)));
%                pause();
               k=k(1);
               if k>thresh
                    trendsig(tstart:tend)=1; %1
                    
               elseif k<-thresh
                   trendsig(tstart:tend)=-1;
               end
           end
       elseif extrema(i+1,2)-extrema(i,2)<0
              if tend-tmiddle>=l3
              interval=floor((tend-tmiddle)/3);
              trendsig((tmiddle+1):(tmiddle+interval))=-3;
              trendsig((tmiddle+interval+1):(tmiddle+1+2*interval))=-2;
              trendsig((tmiddle+2+2*interval):tend)=-1;
              else
              trendsig((tmiddle+1):tend)=-1;    
              end
              trendsig(tstart:tmiddle)=0;
       else
               if tend-tmiddle>=l3
               interval=floor((tend-tmiddle)/3);
              trendsig((tmiddle+1):(tmiddle+interval))=3;
              trendsig((tmiddle+interval+1):(tmiddle+1+2*interval))=2;
              trendsig((tmiddle+2+2*interval):tend)=1;
               else
              trendsig((tmiddle+1):tend)=1;    
               end
                   trendsig(tstart:tmiddle)=0;
           end
end
end
trendsig(extrema(end,1)-delay+1:extrema(end,1))=0;
if extrema(end,2)-data(end)<0
    trendsig(extrema(end,1)+1:end)=-1;
else
    trendsig(extrema(end,1)+1:end)=1;
end

