function [ newobj ] = getCopy( obj )
%GETCOPY handle����ͨ�õ�copy constructor����Ϊhandle��ָ���࣬������Ҫ
% �� obj2 = obj1, ������ͬһ���ڴ�ռ������ָ�루������,�ı�obj2��obj1Ҳ��
% �� obj3 = obj1.getCopy�������������ڴ�ռ�Ĳ�ͬ�������ı�obj3��obj1����
% ------------------
% �̸գ�20140726
% �̸գ�20140829��ʹ�����д����    newobj.(fd)  = obj.(fd);
% �̸գ�20150515���ĳ�ͨ�÷���


%%
% newobj = Class;
eval( ['newobj = ', class(obj), ';']  );
flds    = fields( obj );

for i = 1:length(flds)
    fd          = flds{i};
    newobj.(fd) = obj.(fd);
end    


end

