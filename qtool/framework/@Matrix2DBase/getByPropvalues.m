function [ value ] = getByPropvalues( obj, propvalueStrX, propvalueStrY )
%GETBYPROPVALUES ȡһ��Ԫ�أ�ʹ��X��Y��propvalueStr
%   �˴���ʾ��ϸ˵��
% --------------------
% �̸գ�20160120���ڰ棬û���κη�����

ix = find(   strcmp(propvalueStrX, obj.xProps)  );   
iy = find(   strcmp(propvalueStrY, obj.yProps)  );

value = obj.data(iy, ix);


end

