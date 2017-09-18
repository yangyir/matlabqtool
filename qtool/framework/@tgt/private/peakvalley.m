function [r] = peakvalley(ts,point,mu1,mu2)
%  �ж�r���Ƿ���ts�еľֲ��͵���߾ֲ��͵㣬���չ㷢֤ȯ-������̬ʶ��
%  point �ǵ�ǰ�жϵ�����㣬ts��ʱ������
%  rΪ-1���ֲ��͵�
%  rΪ0�����Ǿֲ���
%  rΪ1���ֲ��ߵ�
%  version 1.00 by zhangyan 2013-1-23
r=0;

%chedk whether point is a valley in ts
index1=find(ts(point)./ts(1:point-1)-1<=-mu1/(1+mu1),1,'last');
index2=find(ts(point+1:end)/ts(point)-1>=mu1,1,'first')+point;
leftflag=1;
rightflag=1;
if ~isempty(index1) &  ~isempty(index2) %�ҵ�����Ķ˵�
  for i=index1:(point-1)                                %check left interval
      if nnz(ts(i+1:point-1)/ts(i)-1>mu1)
          leftflag=0;
          break;
      end
  end
  for i=(point+1):index2-1
      if nnz(ts(i+1:index2-1)/ts(i)-1<-mu1/(1+mu1))
          rightflag=0;
          break;
      end
  end
  if leftflag & rightflag
      r=-1;
      return;
  end
end
  %chedk whether point is a peak in ts
index1=find(ts(point)./ts(1:point-1)-1>=mu2,1,'last');
index2=find(ts(point+1:end)/ts(point)-1<=-mu2/(1+mu2),1,'first')+point;
leftflag=1;
rightflag=1;
if ~isempty(index1) &  ~isempty(index2) %�ҵ�����Ķ˵�
  for i=index1:(point-1)                                %check left interval
      if nnz(ts(i+1:(point-1))/ts(i)-1<-mu2/(1+mu2))
          leftflag=0;
          break;
      end
  end
  for i=(point+1):index2-1
      if nnz(ts(i+1:index2)/ts(i)-1>mu2)
          rightflag=0;
          break;
      end
  end
  if leftflag & rightflag
      r=1;
      return;
  end
end

