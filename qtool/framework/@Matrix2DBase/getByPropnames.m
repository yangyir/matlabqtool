function [ value ] = getByPropnames( obj, propnameStrX, propnameStrY )
%GETBYPROPNAMES ȡһ��Ԫ�أ�ʹ��X��Y��propnameStr
%   �˴���ʾ��ϸ˵��
% --------------------
% �̸գ�20160120���ڰ棬û���κη�����

ix = find(   strcmp(propNameStrX, obj.xProps)  );   
iy = find(   strcmp(propNameStrY, obj.yProps)  );

value = obj.data(iy, ix);


end

