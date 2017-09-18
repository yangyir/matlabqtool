classdef SingleAsset < Matrix2DBase
%SINGLEASSET assembles timeseries vectors of a single asset.
% 适用于单一资产，有多个属性，列在一起
% 其数据可看作就是一维的，只是多个一维捆绑在一起
%         assetname       %single asset name
%         assetcode       %single asset code
%         des             %description
%         tstypes         %time series types, 1*N cell array
%         dates           %T*1 vector
%         data            %assemble of ts vectors, 二维， T*N
% -------------
% 程刚
% 程刚，20150517，添加了父类Matrix2DBase，
%     很多properties应该删去了，但因为有代码依然用旧类写的，所以暂不删去，只是隐藏



    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        dates           %T*1 vector
    end
    
    
    % 已有父类，不要再用这些了
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = true)
        assetname       %single asset name, 标量
        assetcode       %single asset code，标量
        tstypes         %time series types, 1*N cell array

        T = 0          % #dates 
        N = 0          % #tstypes
    end     %properties
    
    
%     % 父类里已有的属性，matlab不允许重载
%     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
%         des             %description
%         data            %assemble of ts vectors, T*N
%     end     %properties
    
    
    %%
    methods (Access = 'public', Static = false, Hidden = false)        
        %constructor,  Excel -> putmatrix argin -> 
        % how to reload?
        function obj = SingleAsset(argin, Y0, X0) 
            % 给父类Matrix2DBase中的属性赋值
            obj.des3    = '单一资产的多个时间序列，纵向时间，横向变量';
            obj.xLabel  = '序列名称，1*Nx Cell';
            obj.yLabel  = '时间或日期，Ny*1 Cell';
            
            % 
            if nargin == 0 return; end
            if iscell(argin) 
                %get dates
                obj.dates = datenum( argin(Y0:end,1) );
                %get tstypes 
                obj.tstypes = argin(1:Y0-1,X0:end);
                %get data
                dataa = argin(Y0:end,X0:end);
                obj.data = cell2mat(dataa);
            end
        end
        
    end
    
            

    
    methods (Access = 'public', Static = true, Hidden = false)
        
        
    end
    
end

