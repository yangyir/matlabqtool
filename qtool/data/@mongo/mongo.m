classdef mongo
% MONGO ��mongo���ݿ���ȡ����
% �ܾ�û��ʹ����
% Cheng,Gang; 20140124
    
    properties
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        
         % �������ò�����Ȼ���databaseȡ��һ��TsMatrix
        paramTSM = tsmParams(property, assets, startdate, enddate,tablename, dbname );
        TSMobj = FetchTsm( conn, params );
        
         % �������ò�����Ȼ���databaseȡ��һ��SingleAsset
        paramSA = saParams(propertiess, asset, startdate, enddate, tablename,dbname  );
        SAobj = FetchSa( conn, params );
        
        %ȡ�����۸�
        conn=connect(db,table);
        fetchPrice=fetch(property,asset,startdate,enddate);
        
    end
    
end

