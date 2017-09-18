function [sarval]= sar( high,low,AFstart,AFmax,AFdelta)
%%  Parabolic SAR计算，按照easylanguage中对应函数编写
% default AFstart = 0.02, AFmax = 0.2, AFdelta = 0.02;
% version 1.0 yanzhang 2013/4/19




%% 参数选择
% defults AFstart,  AFmax, AFdelta
if nargin==2
    AFstart=0.02;
    AFmax=0.2;
    AFdelta=0.02;
elseif nargin==3
    AFmax=0.2;
    AFdelta=0.02;
elseif nargin==4
    AFdelta=0.02;
end;

%memory allocation
sarval=zeros(length(high),1);

%% 初始化
% reset AF
if size(high,1)~=1; high=high'; end;
if size(low,1)~=1; low=low'; end;
AF=AFstart;
maxHigh=max(high(1),high(2));
minLow=min(low(1),low(2));
ominLow=minLow;
omaxHigh=maxHigh;
% SIP (SAR Initial Point) and first SAR
if high(1)<high(2)
    position=1;
    sarval(1)=min(low(1),low(2));
    sarval(2)=sarval(1);
    maxHigh=max(high(1),high(2));
else
    position=-1;
    sarval(1)=max(high(1),high(2));
    sarval(2)=sarval(1);
    minLow=min(low(1),low(2));
end;


%%  迭代计算后面的数值
% main loop
for i=2:length(high)-1
   omaxHigh=maxHigh;
   maxHigh=max(high(i),maxHigh);
   ominLow=minLow;
   minLow=min(low(i),minLow);
    % update AF
    if (AF<AFmax)
        if (position==1 && high(i)>omaxHigh)
            maxHigh=high(i);
            AF=min(AF+AFdelta,AFmax);
        elseif (position==-1 && low(i)<ominLow)
            minLow=low(i);
            AF=min(AF+AFdelta,AFmax);
        end;
    end;

    % new SAR
    if position==1
        if low(i)<sarval(i)
            position=-1;
            sarval(i)=maxHigh;
            maxHigh=high(i);
            minLow=low(i);
            AF=AFstart;
            sarval(i+1)=AF*(minLow-sarval(i))+sarval(i);
            if sarval(i+1)<high(i) 
                sarval(i+1)=high(i);
            end
            if sarval(i+1)<high(i-1) 
                sarval(i+1)=high(i-1);
            end
        else
            sarval(i+1)=sarval(i)+AF*(maxHigh-sarval(i));
            if sarval(i+1)>low(i)
                sarval(i+1)=low(i);
            end
             if sarval(i+1)>low(i-1)
                sarval(i+1)=low(i-1);
            end
        end;
    else  %position==-1
          if high(i)>sarval(i);
            position=1;
            sarval(i)=minLow;
            maxHigh=high(i);
            minLow=low(i);
            AF=AFstart;
            sarval(i+1)=AF*(maxHigh-sarval(i))+sarval(i);
            if sarval(i+1)>low(i) 
                sarval(i+1)=low(i);
            end
            if sarval(i+1)>low(i-1) 
                sarval(i+1)=low(i-1);
            end
          else
            sarval(i+1)=sarval(i)+AF*(minLow-sarval(i));
            if sarval(i+1)<high(i)
                sarval(i+1)=high(i);
            end
             if sarval(i+1)<high(i-1)
                sarval(i+1)=high(i-1);
            end
          end
    end
end