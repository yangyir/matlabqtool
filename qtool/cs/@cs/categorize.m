function [ category ] = categorize( data )
%CATEGORIZE         �����зֵ�
%   inputs:
%   data            ԭ������

%   outputs:
%   category        �ṹ��������ѷֺõ���
%   version 1.0 , luhuaibao��
%   version 1.1,  luhuaibao, �����10����13�У�ȥnan
ntag = size(data,2)  ; 
for i = 3:ntag
    data( isnan(data(:,i)),:) = [];    
end ; 

var0 = data(:,3:end);

[var1,~,idb] = unique(var0,'rows');

nc = size(var1,1);

for i = 1:nc
    tic
    
    idx =  ( idb == i );

    category.pattern{i,1} = var1(i,:);

    var2 = data(:,1);
    category.time{i,1} = var2(idx);

    var3 = data(:,2);
    category.pro{i,1} = var3(idx);

    
    toc
end;



end

