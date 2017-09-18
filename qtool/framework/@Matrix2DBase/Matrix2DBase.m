classdef Matrix2DBase < handle
% INFO2DMATRIXBASE ͨ�ö�ά���󣬴�������������Ϣ
% TODO��
%   TsMatrix��SingleAsset��Ӧ���Ǵ��������
% ---------------------------------
% �̸գ�20150515������getCopy(), copy constructor
% �̸գ�20150517��
%     ����xLabel��yLabel
%     des3 ��Ϊ'protected'

    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        des@char             %description
        des2@char            % ����
%         des3            % �������ݡ����������        
        datatype = 'val'%value/percentage/normal/delta
        data            % ���� matrix, Ny*Nx
    end %properties

     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
         xLabel@char = 'x��ı�����'         % x��ı��������ַ���
         xProps          %  1*Nx�� cell
         
         yLabel@char = 'y��ı�����'        % y��ı��������ַ���         
         yProps          % Ny*1�� cell? vector?
    end     %properties
    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = true)
         Nx = 0          % x�������
         Ny = 0          % y�������
    end     %properties

    
    properties (SetAccess = 'protected', GetAccess = 'public', Hidden = false)
       
        des3            % �������ݡ����������
        
    end %properties

   %%
   methods (Access = 'public', Static = false, Hidden = false)
        % ������ɢ����
       [ obj ] = autoFill( obj )
       
       
        % ������
%         [ data, headers, data2] = toTable( obj, headers );
%         [ obj ]                 = fromTable( obj );        
        [ obj ]             = toExcel(obj, filename, sheetname); 
        [ obj ]             = toTxt( obj, filename, datumFormat, flag_xyProps );
        
        
        [ obj ]             = fromExcel(obj, filename, sheetname);
        [ obj ]             = fromTxt( obj, filename);
        
        % ��Ϊ��handle�࣬��Ҫcopy constructor������ָ�븳ֵ
        [ newobj ]          = getCopy(obj);
        
        % ȡ��һ�л�һ�У�ʹ�ø���/�е�������
        [ vec, idx ]  = getVecByPropName( obj, nameStr, direction);
        
        % ȡ��һ��Ԫ�أ�ʹ����������index
        [ val ] = getByPropnames( obj, propNameX, propNameY); 
        [ val ] = getByPropvalues( obj, propvalueX, propvalueY); % ͬ��
        [ val ] = getByIndex( obj, indexX, indexY);
        
       
        
        % ����һ�л�һ�У�ʹ�ø���/�е�������
%         [ idx ]     = setByPropName( obj, vector, nameStr, direction);        
        [  ]    = insertVec(obj, vector, nameStr, direction, idx);
        [  ]    = insertRow(obj, rowVec, nameStr, idx);
        [  ]    = insertCol(obj, colVec, nameStr, idx);        
        % ɾ����/��
        [  ]    = removeRow(obj, idx);
        [  ]    = removeCol(obj, idx);        
        [ idx ] = removeRowByPropName(obj, nameStr);
        [ idx ] = removeColByPropName(obj, nameStr);
        
        
        %%
         % ȡ�е�index
         function idx = getIdxByPropvalue_Y( obj, Y_propvalue)
             % ȡ�е�index
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
         
         
         % ȡ�е�index
         function idx = getIdxByPropvalue_X( obj, X_propvalue)
             % ȡ�е�index
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

