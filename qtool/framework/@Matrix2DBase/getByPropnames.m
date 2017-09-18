function [ value ] = getByPropnames( obj, propnameStrX, propnameStrY )
%GETBYPROPNAMES 取一个元素，使用X和Y的propnameStr
%   此处显示详细说明
% --------------------
% 程刚，20160120，糙版，没有任何防错处理

ix = find(   strcmp(propNameStrX, obj.xProps)  );   
iy = find(   strcmp(propNameStrY, obj.yProps)  );

value = obj.data(iy, ix);


end

