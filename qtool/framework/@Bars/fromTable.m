function [ obj ] = fromTable( obj )
% ��obj.data��obj.headers�а�����ת������
% �̸գ�20131211


h = obj.headers;
d = obj.data;


for i =1:length(h)
    try
        %     obj.xxx  = d(:,i);
        eval( ['obj.' h{i} ' = d(:,i);' ] );
    catch e
        disp( [ h{i} '����!'] );
    end
end


%% 
d2 = obj.data2;
% δ��



    
end

