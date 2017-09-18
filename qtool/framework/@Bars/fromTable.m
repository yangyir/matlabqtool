function [ obj ] = fromTable( obj )
% 从obj.data和obj.headers中把数据转入域中
% 程刚，20131211


h = obj.headers;
d = obj.data;


for i =1:length(h)
    try
        %     obj.xxx  = d(:,i);
        eval( ['obj.' h{i} ' = d(:,i);' ] );
    catch e
        disp( [ h{i} '出错!'] );
    end
end


%% 
d2 = obj.data2;
% 未完



    
end

