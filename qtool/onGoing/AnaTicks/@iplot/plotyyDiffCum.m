function [h1, h2] = plotyyDiffCum( data, datatype, data_x )
% һ�����ݣ���������ͼ�����ᣬ�ߣ���ɫ����΢��ͼ�����ᣬ������ɫ��
% ����ͼ��handle
% inputs:
%       data,               ����
%       datatype,           �������ͣ�'diff', 'cum')
%       data_x,             �������꣨Ĭ�ϼ�����
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

    

%% ��ͼ

[ax,h1,h2] = plotyy(data_x, cumData, data_x, diffData, @plot, @bar);

set(h2,'facecolor','y','edgecolor','y');





end
