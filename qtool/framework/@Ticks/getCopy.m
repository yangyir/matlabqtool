function [ newobj ] = getCopy( obj )
%GETCOPY handle子类通用的copy constructor。因为handle是指针类，所以需要
% 若 obj2 = obj1, 二者是同一个内存空间的两个指针（别名）,改变obj2，obj1也变
% 若 obj3 = obj1.getCopy，二者是两个内存空间的不同变量，改变obj3，obj1不变
% ------------------
% 程刚；20140726
% 程刚；20140829，使用这个写法：    newobj.(fd)  = obj.(fd);
% 程刚，20150515，改成通用方法


%%
% newobj = Class;
eval( ['newobj = ', class(obj), ';']  );
flds    = fields( obj );

for i = 1:length(flds)
    fd          = flds{i};
    newobj.(fd) = obj.(fd);
end    


end

