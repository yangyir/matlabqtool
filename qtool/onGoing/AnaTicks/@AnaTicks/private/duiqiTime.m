function [ idx1, idx2, commonTime ] = duiqiTime(times1, times2, type, givenTime)
%DUIQITIME 对齐两个时间序列，可以自己提供givenTime
% 输入:
%     times1，times2     待对齐时间列
%     type               对齐方式，'union'，'intersect'(默认），'given'
%     givenTime          对齐后的时间列，可以是输入
% 输出： 
%     idx1，idx2         序号，使得commonTime = times1(idx1) = times2(idx2)
%     commonTime         对齐后的时间列，如果给了，就是givenTime
% 程刚；140613


%% 

% 默认取交集
if  ~exist('type','var'), type = 'intersect'; end


if max(times1) < min(times2) || min(times1) > max(times2)
    disp('错误：times1，times2不相交');      
    return;
end


%% main
switch type
    case {'union'} % 取并集的处理有些麻烦，干脆都放到后面处理      
        [commonTime, ui1, ui2] = union(times1, times2);
%         idx1 = ui1(ia);
%         idx2 = ui2(ia);

    case {'intersect'} % 交集最容易处理,速度也快
        % intersect 自带unique和sort('ascend')
        [commonTime1, idx1,idx2] = intersect(times1, times2);

        return;
        
        
    case{'given'}
        commonTime = givenTime; 

end


%% 用低效的方法，一个一个找，极慢
% given 一个commonTime，直接找位置
idx1 = nan(length(commonTime), 1);
idx2 = nan(length(commonTime), 1);

for i = 1:length(commonTime)
    i1 = find(times1<=commonTime(i), 1, 'last');
    i2 = find(times2<=commonTime(i), 1, 'last');
    if isempty(i1)
        idx1(i) = 1;
    else
        idx1(i) = i1;
    end
    
    if isempty(i2)
        idx2(i) = 1;
    else
        idx2(i) = i2;
    end
end


%% 高效率的方法，但这样太严格
% [~, idx1] = ismember(times1, commonTime);
% [~, idx2] = ismember(times2, commonTime);
