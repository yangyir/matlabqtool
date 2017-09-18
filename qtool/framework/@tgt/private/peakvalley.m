function [r] = peakvalley(ts,point,mu1,mu2)
%  判断r点是否是ts中的局部低点或者局部低点，按照广发证券-技术形态识别
%  point 是当前判断的坐标点，ts是时间序列
%  r为-1，局部低点
%  r为0，不是局部点
%  r为1，局部高点
%  version 1.00 by zhangyan 2013-1-23
r=0;

%chedk whether point is a valley in ts
index1=find(ts(point)./ts(1:point-1)-1<=-mu1/(1+mu1),1,'last');
index2=find(ts(point+1:end)/ts(point)-1>=mu1,1,'first')+point;
leftflag=1;
rightflag=1;
if ~isempty(index1) &  ~isempty(index2) %找到两侧的端点
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
if ~isempty(index1) &  ~isempty(index2) %找到两侧的端点
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

