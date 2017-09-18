classdef mongo
% MONGO 从mongo数据库里取数据
% 很久没有使用了
% Cheng,Gang; 20140124
    
    properties
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        
         % 用于设置参数，然后从database取出一个TsMatrix
        paramTSM = tsmParams(property, assets, startdate, enddate,tablename, dbname );
        TSMobj = FetchTsm( conn, params );
        
         % 用于设置参数，然后从database取出一个SingleAsset
        paramSA = saParams(propertiess, asset, startdate, enddate, tablename,dbname  );
        SAobj = FetchSa( conn, params );
        
        %取单个价格
        conn=connect(db,table);
        fetchPrice=fetch(property,asset,startdate,enddate);
        
    end
    
end

