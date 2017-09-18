classdef RiskMonitor < handle
   % RiskMonitor 作为一个监控类，可以挂入多本Book.
   % 挂载Book时，设定某个风险项下的预警值，vega, iv, delta, gamma.。
   properties
       bookMonitors@BookMonitorArray
   end
   
   methods
       function [obj] = RiskMonitor()
           obj.bookMonitors = BookMonitorArray;
       end
       
       function [obj] = attachMonitor(obj, monitor)
           obj.bookMonitors.push(monitor);
       end
       
       function [] = check(obj, vs, S, r)
           obj.bookMonitors.foreachCheck(S, vs, r);
       end
   end
end