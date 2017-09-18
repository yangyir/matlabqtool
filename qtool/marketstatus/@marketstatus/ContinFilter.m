function [FiltLoc, newsignal]=ContinFilter(signal, tol)
% v.2.0 by Yang Xi
% 本函数将signal中有效信号连续数目小于tol的1直接过滤成0，并返回改变值的位置
% signal 是由 1 和 0 组成的数字串， 1 为有效，0 为无效
% tol 表示有效信号所要求的最短长度
% FiltLoc 表示被过滤值的位置
% newsignal 过滤之后得到的新信号

i =1;
ntotal = length(signal);
newsignal = signal;
while i <= ntotal
    if newsignal(i) == 1,
        start = i; % 一段有效信号的起始位置
        j = i;
        while j <= ntotal
            if newsignal(j) == 1,
                j = j+1;
            else
                break;
            end
        end
        stop = j-1; % 一段有效信号的终止位置
        len = stop-start+1; % 一段有效信号的长度
        if len < tol
            newsignal(start:stop)=zeros(1,len);
        end
        i = j+1;
    else
        i = i+1;
    end
end
FiltLoc = find(newsignal-signal == -1);
end


            
  