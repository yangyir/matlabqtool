function [ newobj ] = getCopy( obj )
%GETCOPY handle����ͨ�õ�copy constructor����Ϊhandle��ָ���࣬������Ҫ
% �� obj2 = obj1, ������ͬһ���ڴ�ռ������ָ�루������,�ı�obj2��obj1Ҳ��
% �� obj3 = obj1.getCopy�������������ڴ�ռ�Ĳ�ͬ�������ı�obj3��obj1����
% ------------------
% �̸գ�20140726
% �̸գ�20140829��ʹ�����д����    newobj.(fd)  = obj.(fd);
% �̸գ�20150515���ĳ�ͨ�÷���
% ���Ʒ壬20160316�����������optPricers��OptInfos�����൥��getCopy

%%
% newobj = Class;
eval( ['newobj = ', class(obj), ';']  );
flds    = fields( obj );

for i = 1:length(flds)
    fd          = flds{i};
    if strcmp( fd , 'optPricers' ) || strcmp( fd , 'optInfos' )
        clear('data')
        original = obj.(fd);
        [ m , n ] = size( original );
        switch fd
            case 'optInfos'
                evl_str = sprintf( '%s(%d,%d) = %s','data',m,n,'OptInfo;' );
            case 'optPricers'
                evl_str = sprintf( '%s(%d,%d) = %s','data',m,n,'OptPricer;' );
        end
        eval( evl_str )
        for i = 1:m
            for j = 1:n
                data( i , j ) = original( i , j ).getCopy();
            end
        end
        newobj.(fd) = data;
    else
        newobj.(fd) = obj.(fd);
    end
end    




end
