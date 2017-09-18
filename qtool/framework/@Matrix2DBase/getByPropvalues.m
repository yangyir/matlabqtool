function [ value ] = getByPropvalues( obj, propvalueStrX, propvalueStrY )
%GETBYPROPVALUES 取一个元素，使用X和Y的propvalueStr
%   此处显示详细说明
% --------------------
% 程刚，20160120，糙版，没有任何防错处理

ix = find(   strcmp(propvalueStrX, obj.xProps)  );   
iy = find(   strcmp(propvalueStrY, obj.yProps)  );

value = obj.data(iy, ix);


end

