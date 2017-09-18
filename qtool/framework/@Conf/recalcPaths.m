function [ obj ] = recalcPaths( obj )
% ��������µ�rootPath, һ��Ҫ����һ������paths
% �̸�,20131206��

if isempty(obj.config.rootPath)
    obj.setRootPath;
end


obj.config.dataPath     = [obj.config.rootPath, '\Database\'];
obj.config.workingPath  = [obj.config.rootPath, '\HMH\M_Pool\'];
obj.config.analyticPath = [obj.config.rootPath, '\Analytics\'];
obj.config.qtoolPath    = [obj.config.rootPath, '\qtool\'];
obj.config.reportPath   = [obj.config.analyticPath, '\Report\'];
obj.config.tradelistPath = [obj.config.analyticPath, '\Tradelist\'];
obj.config.replayPath   = [obj.config.workingPath, '\REPLAY\'];

end

