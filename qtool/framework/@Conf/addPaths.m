function [ obj ] = addPaths( obj )
% 加入路径，只用执行一次
% 放在这个类中并不合适，只是暂时的
% 
% 程刚，20131206

addpath(genpath(obj.config.qtoolPath), '-begin');
addpath(genpath(obj.config.workingPath), '-begin');


end

