classdef TsMatrix < Matrix2DBase %<AbstractTsMatrix
%TSMATRIX is a Time*Assets matrix of a single value
%eg. close, $position, signal, selected, isCSI300member, .
% -------------
% 程刚
% 程刚，20150517，添加了父类Matrix2DBase，
%     很多properties应该删去了，但因为有代码依然用旧类写的，所以暂不删去，只是隐藏
  
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        dates; %yProps的复制，为datenum，为了方便
    end 

    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = true)
       assets          %asset names and codes, 1*M cell array
       T = 0          % #dates 
       M = 0          % #assets
    end     %properties
    
%     % 父类里已有的属性，matlab不允许重载
%     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
%         datatype = 'val'%value/percentage/normal/delta
%         des             %description
%         data            % 时间序列矩阵, T*N
%     end     %properties

    
    methods %(Access = 'public', Static = false, Hidden = false)
               
        %check dimension OK, 父类已有
%         function obj = AutoFill(obj)
%             T = size(obj.dates); T = T(1);
%             M = size(obj.assets); M = M(2);
%             MM = size(obj.data);
%             if  T == MM(1)  obj.T = T;  end
%             if  M == MM(2)  obj.M = M;  end
%         end     %function
        
%         %constructor,  Excel -> putmatrix argin -> 
%         % how to reload?
        function obj = TsMatrix(argin, Y0, X0)  
            % 给父类Matrix2DBase中的属性赋值
            obj.des3    = '单一变量多资产时间序列矩阵，纵向时间，横向资产';
            obj.xLabel  = '资产名称，1*Nx Cell';
            obj.yLabel  = '时间或日期，Ny*1 Cell';
            
            
            if nargin == 0 return; end
            if iscell(argin) 
                %get dates
                obj.dates = datenum( argin(Y0:end,1) );
                %get tstypes 
                obj.assets = argin(1:Y0-1,X0:end);
                %get data
                dataa = argin(Y0:end,X0:end);
                obj.data = cell2mat(dataa);
                
                obj.AutoFill;
            end          
        end %function
     
        
    end %methods
    
    
     %% static tools
    methods (Access = 'public', Static = true, Hidden = false)
        mergedTsm = Merge(tsm1, tsm2);
    end
end

