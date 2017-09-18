function [h1, h2] = plotyyDiffCum( data, datatype, data_x )
% 一组数据，画出积分图（左轴，线，蓝色）和微分图（右轴，柱，黄色）
% 返回图的handle
% inputs:
%       data,               数据
%       datatype,           数据类型（'diff', 'cum')
%       data_x,             横轴坐标（默认计数）
% chenggang; 140601;

%% default

if ~exist('datatype', 'var'), 
    datatype = 'diff'; % 
end

if ~exist('data_x','var')
    data_x = 1:length(data);
end

%% 
switch(datatype)
    case{'diff'}
        cumData  = cumsum(data);
        diffData = data;
    case{'cum'}
        cumData = data;
        diffData = [data(1); diff(data)];
end

    

%% 作图

[ax,h1,h2] = plotyy(data_x, cumData, data_x, diffData, @plot, @bar);

set(h2,'facecolor','y','edgecolor','y');





end
