classdef Matrix2DBase < handle
% INFO2DMATRIXBASE 通用二维矩阵，带有行列坐标信息
% TODO：
%   TsMatrix，SingleAsset都应该是此类的子类
% ---------------------------------
% 程刚，20150515，加入getCopy(), copy constructor
% 程刚，20150517，
%     加入xLabel，yLabel
%     des3 改为'protected'

    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        des@char             %description
        des2@char            % 备用
%         des3            % 描述数据、子类的属性        
        datatype = 'val'%value/percentage/normal/delta
        data            % 核心 matrix, Ny*Nx
    end %properties

     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
         xLabel@char = 'x轴的变量名'         % x轴的变量名，字符串
         xProps          %  1*Nx， cell
         
         yLabel@char = 'y轴的变量名'        % y轴的变量名，字符串         
         yProps          % Ny*1， cell? vector?
    end     %properties
    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = true)
         Nx = 0          % x轴的数量
         Ny = 0          % y轴的数量
    end     %properties

    
    properties (SetAccess = 'protected', GetAccess = 'public', Hidden = false)
       
        des3            % 描述数据、子类的属性
        
    end %properties

   %%
   methods (Access = 'public', Static = false, Hidden = false)
        % 查错等零散方法
       [ obj ] = autoFill( obj )
       
       
        % 储存用
%         [ data, headers, data2] = toTable( obj, headers );
%         [ obj ]                 = fromTable( obj );        
        [ obj ]             = toExcel(obj, filename, sheetname); 
        [ obj ]             = toTxt( obj, filename, datumFormat, flag_xyProps );
        
        
        [ obj ]             = fromExcel(obj, filename, sheetname);
        [ obj ]             = fromTxt( obj, filename);
        
        % 因为是handle类，需要copy constructor，以免指针赋值
        [ newobj ]          = getCopy(obj);
        
        % 取出一列或一行，使用该行/列的属性名
        [ vec, idx ]  = getVecByPropName( obj, nameStr, direction);
        
        % 取出一个元素，使用属性名或index
        [ val ] = getByPropnames( obj, propNameX, propNameY); 
        [ val ] = getByPropvalues( obj, propvalueX, propvalueY); % 同上
        [ val ] = getByIndex( obj, indexX, indexY);
        
       
        
        % 插入一列或一行，使用该行/列的属性名
%         [ idx ]     = setByPropName( obj, vector, nameStr, direction);        
        [  ]    = insertVec(obj, vector, nameStr, direction, idx);
        [  ]    = insertRow(obj, rowVec, nameStr, idx);
        [  ]    = insertCol(obj, colVec, nameStr, idx);        
        % 删除行/列
        [  ]    = removeRow(obj, idx);
        [  ]    = removeCol(obj, idx);        
        [ idx ] = removeRowByPropName(obj, nameStr);
        [ idx ] = removeColByPropName(obj, nameStr);
        
        
        %%
         % 取列的index
         function idx = getIdxByPropvalue_Y( obj, Y_propvalue)
             % 取列的index
             if isa(Y_propvalue, 'cell')
                 Y_propvalue = Y_propvalue{1};
             end
             if isa(Y_propvalue, 'double')
                 idx = find( abs(Y_propvalue - obj.yProps) < 0.0001);
             end
             if isa(Y_propvalue, 'char')
                 idx = find( strcmp(Y_propvalue, obj.yProps) );
             end
         end
         
         
         % 取行的index
         function idx = getIdxByPropvalue_X( obj, X_propvalue)
             % 取行的index
             if isa(X_propvalue, 'cell')
                 X_propvalue = X_propvalue{1};
             end
             if isa(X_propvalue, 'double')
                 idx = find( abs(X_propvalue - obj.xProps) < 0.0001);
             end
             if isa(X_propvalue, 'char')
                 idx = find( strcmp(X_propvalue, obj.xProps) );
             end
         end
         
%          function [ idx ] = getIdxByPropvalue( obj, propvalueStr)
%              idx = find( strcmp(propvalueStr, obj.yProps) );
%          end

   end
   
   
   methods(Static = true)
       demo
       
   end
    
end

