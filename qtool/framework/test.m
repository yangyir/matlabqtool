fn = fieldnames(bs_new);

for i = 1:length(fn)
     disp(fn{i});

%     sum(bs.xxx == bs_ori.xxx)
%     eval( ['sum(bs.' fn{i} '==bs_ori.' fn{i} ')' ] );
    
    eval( ['a = bs_new.' fn{i} ';'] );
    eval( ['aa = bs_ori.' fn{i} ';'] );
    
    len = length(aa);
    a = a(end-len+1:end);
    try 
        s = sum(a == aa);
        figure(1);
                plot(a-aa);
        
    catch
        disp('²»¿É±È');
    end
    
    b = 0;
%     ss = length(a);
%    
%     sss = length(aa);
%     try

    
    
    
    
    
end