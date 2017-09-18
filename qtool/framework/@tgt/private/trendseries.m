function [extrema trendsig]=trendseries(pv,data,delay)
%  将数据点的峰谷值转换为对应的折线图，按照广发证券-技术形态识别
%  pv 是数据点的峰谷值，data是原始的时间序列
%  trend包括了时间坐标和对应的折线图数值
% -----------------------------------------------------
%  version 1.00 by zhangyan 2013-1-23
%  trendsig给出了时间序列任意一点未来一段时间的趋势，1为上升，-1为下降，0为不确定。  
%  delay给出的信号的延时。
% 
% version 1.01 by zhangyan 2013-4-8
% thresh、1l、l2是三个内建参数, l1给出的是极值点间隔的最小值，，l2给出的是拟合未来趋势的数据点个数，这些数据点包括了l2个极值点，
% thresh是拟合直线斜率判断上升下降趋势用到的阈值
% 
% version 1.02 by zhangyan 2013-4-16
% l3 将长趋势段划分为前期，中期，后期，赋予不同的权重，l3是三段区间总和的最小值。
%
% version 1.03 by daniel 2013-4-24
% 修改：当extrema只有1个点时，期末自动跳到数据末尾，依旧按照3分法，给线段上的点打分

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

% 如果遇到1个极值点的情况
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

