classdef db
%　DB 数据库相关的函数容器
%  Cheng,Gang
    
    properties
    end
    
    %% static tools
    methods (Access = 'public', Static = true, Hidden = false)
        
        % 取给定时间下指数的成分股代码列
        assetList = FetchAssetList( index_name, index_time,conn, table_name )
        
        % 用于设置参数，然后从database取出一个TsMatrix
        paramTSM = tsmParams(property, assets, startdate, enddate,tablename, dbname );
        TSMobj = FetchTsm(params, conn);
        
         % 用于设置参数，然后从database取出一个SingleAsset
        paramSA = saParams(propertiess, asset, startdate, enddate, tablename,dbname  );
        SAobj = FetchSa(params, conn);
        
        % dataNormalize 使股指期货隔夜时间序列连续
         price  = dataNormalize( start_date,nDate,slice_seconds,path )
        
    end
    
end

