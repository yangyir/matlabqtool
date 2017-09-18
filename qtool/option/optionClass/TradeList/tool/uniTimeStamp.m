function [ idx ] = uniTimeStamp( X, Y )
%UNITIMESTAMP,将以Y为尺度的时间序列转换为以X为尺度的时间序列。idx的长度
% 与X相同，为Y -> X 的映射坐标。
% 转换的时候采用前方延续，后方压缩的方式。
%
% 要保证 X 和 Y 都是升序的。

lenRuler = length(X);
lenRod = length(Y);

idx = nan(lenRuler,1);
%%
iY = 1;
flag = true;
for iX = 1:length(X)
    while Y(iY)<=X(iX)
        % 标尺之间靠后，在Y中找到不大于这个时间的第一个点
        iY = iY+1;
        if iY>lenRod
            idx(iX:end) = iY-1;
            flag = false;
            break;
        end
    end
    
    if flag 
        idx(iX) = iY-1;
    else
        break;
    end
end

%% 后续处理

ind = idx == 0;

idx(ind) = 1;


end

