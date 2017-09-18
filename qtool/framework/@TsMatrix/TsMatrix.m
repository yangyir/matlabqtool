classdef TsMatrix < Matrix2DBase %<AbstractTsMatrix
%TSMATRIX is a Time*Assets matrix of a single value
%eg. close, $position, signal, selected, isCSI300member, .
% -------------
% �̸�
% �̸գ�20150517������˸���Matrix2DBase��
%     �ܶ�propertiesӦ��ɾȥ�ˣ�����Ϊ�д�����Ȼ�þ���д�ģ������ݲ�ɾȥ��ֻ������
  
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        dates; %yProps�ĸ��ƣ�Ϊdatenum��Ϊ�˷���
    end 

    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = true)
       assets          %asset names and codes, 1*M cell array
       T = 0          % #dates 
       M = 0          % #assets
    end     %properties
    
%     % ���������е����ԣ�matlab����������
%     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
%         datatype = 'val'%value/percentage/normal/delta
%         des             %description
%         data            % ʱ�����о���, T*N
%     end     %properties

    
    methods %(Access = 'public', Static = false, Hidden = false)
               
        %check dimension OK, ��������
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
            % ������Matrix2DBase�е����Ը�ֵ
            obj.des3    = '��һ�������ʲ�ʱ�����о�������ʱ�䣬�����ʲ�';
            obj.xLabel  = '�ʲ����ƣ�1*Nx Cell';
            obj.yLabel  = 'ʱ������ڣ�Ny*1 Cell';
            
            
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

