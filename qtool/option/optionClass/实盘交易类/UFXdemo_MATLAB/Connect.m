function [errorCode, errorMsg,connection] = Connect(ufxserver_ip, ufxserver_port)
    import com.hundsun.esb.*  com.hundsun.esb.data.*;     
    errorCode = 0;
    errorMsg = '';    
    try
        EsbConnectionPoolFactory.close();
        connectParameter = javaObject('com.hundsun.esb.EsbConnectParameter',ufxserver_ip,ufxserver_port,'HS-HUNDSUN001-FBASE2-0000-4ePWxzscBVtY9ZKdgDKhSyk2',3000);    
        EsbConnectionPoolFactory.addPool(1028,connectParameter,1);    
        pool = EsbConnectionPoolFactory.getPool(1028);        
        connection = pool.getConnection();        
    catch me
        errorCode = -1;
        errorMsg = me.message;
        connection = '';
    end
end
