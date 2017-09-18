classdef Matrix3DBase
    %MATRIX3DBASE 存放三维矩阵，带维度信息
    %   Detailed explanation goes here
    
     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        des             %description
        des2            % 备用
        
        datatype = 'val'% value/percentage/normal/delta
        
        data            % 核心 matrix, Nz*Ny*Nx
    end %properties

     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        xProps          %  1*Nx
        yProps           % Ny*1 vector
        zProps          % Nz*1 vector
        
        Nx = 0          % x轴的数量
        Ny = 0          % y轴的数量
        Nz = 0          % z轴元素数量
        
    end     %properties
   
   methods (Access = 'public', Static = false, Hidden = false)
      
        % 储存用
%         [ data, headers, data2] = toTable( obj, headers );
%         [ obj ]                 = fromTable( obj );        
        [ obj ]                 = toExcel(obj, filename, sheetname); 
        [ obj ]                 = toTxt(obj,filename);
        
        
        
        % 因为是handle类，需要copy constructor，以免指针赋值
        [ newobj ] = getCopy(obj);
   end
end

