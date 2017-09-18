function [newObj ] = slctByStrategy(obj,sNo)
%　潘其超,20140725,V1.0
%  潘其超,20140807,V2.0
%    1. 由TradeList迁移到TEBase，略作修改，三个类都可以使用。
idx = obj.strategyNo(1:obj.latest) == sNo;
numRcd = sum(idx);
if numRcd ==0
    newObj =  eval([class(obj) '(0)']);
    return;
end

newObj = eval([class(obj) '(numRcd)']);
newObj.latest = numRcd;

for i = 1:length(obj.headers)
    newObj.(newObj.headers{i})= obj.(obj.headers{i})(idx);
end
end