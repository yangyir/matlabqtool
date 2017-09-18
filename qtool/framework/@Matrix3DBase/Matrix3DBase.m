classdef Matrix3DBase
    %MATRIX3DBASE �����ά���󣬴�ά����Ϣ
    %   Detailed explanation goes here
    
     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        des             %description
        des2            % ����
        
        datatype = 'val'% value/percentage/normal/delta
        
        data            % ���� matrix, Nz*Ny*Nx
    end %properties

     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        xProps          %  1*Nx
        yProps           % Ny*1 vector
        zProps          % Nz*1 vector
        
        Nx = 0          % x�������
        Ny = 0          % y�������
        Nz = 0          % z��Ԫ������
        
    end     %properties
   
   methods (Access = 'public', Static = false, Hidden = false)
      
        % ������
%         [ data, headers, data2] = toTable( obj, headers );
%         [ obj ]                 = fromTable( obj );        
        [ obj ]                 = toExcel(obj, filename, sheetname); 
        [ obj ]                 = toTxt(obj,filename);
        
        
        
        % ��Ϊ��handle�࣬��Ҫcopy constructor������ָ�븳ֵ
        [ newobj ] = getCopy(obj);
   end
end

