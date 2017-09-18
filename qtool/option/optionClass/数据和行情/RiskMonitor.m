classdef RiskMonitor < handle
   % RiskMonitor ��Ϊһ������࣬���Թ���౾Book.
   % ����Bookʱ���趨ĳ���������µ�Ԥ��ֵ��vega, iv, delta, gamma.��
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