classdef db
%��DB ���ݿ���صĺ�������
%  Cheng,Gang
    
    properties
    end
    
    %% static tools
    methods (Access = 'public', Static = true, Hidden = false)
        
        % ȡ����ʱ����ָ���ĳɷֹɴ�����
        assetList = FetchAssetList( index_name, index_time,conn, table_name )
        
        % �������ò�����Ȼ���databaseȡ��һ��TsMatrix
        paramTSM = tsmParams(property, assets, startdate, enddate,tablename, dbname );
        TSMobj = FetchTsm(params, conn);
        
         % �������ò�����Ȼ���databaseȡ��һ��SingleAsset
        paramSA = saParams(propertiess, asset, startdate, enddate, tablename,dbname  );
        SAobj = FetchSa(params, conn);
        
        % dataNormalize ʹ��ָ�ڻ���ҹʱ����������
         price  = dataNormalize( start_date,nDate,slice_seconds,path )
        
    end
    
end

