function [ obj ] = addPaths( obj )
% ����·����ֻ��ִ��һ��
% ����������в������ʣ�ֻ����ʱ��
% 
% �̸գ�20131206

addpath(genpath(obj.config.qtoolPath), '-begin');
addpath(genpath(obj.config.workingPath), '-begin');


end

