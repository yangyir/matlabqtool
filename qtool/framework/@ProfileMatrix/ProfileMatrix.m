classdef ProfileMatrix %<AbstractTsMatrix
    %PROFILEMATRIX �������N*p�� ��ĳ���ض�ʱ���ϵĽ���  
    %���᣺assets��N��
    %���᣺properties�� p��
    %ʱ�䣺����
    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
%         dataname        %single data name
        des             %description
        datatype = 'val'%value/percentage/normal/delta
        assets          %asset names and codes, 2*M cell array
        props           %T*1 vector
        data            % ���� matrix
    end %properties

    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        P = 0          % #dates 
        N = 0          % #assets
    end     %properties
    
    
    methods %(Access = 'public', Static = false, Hidden = false)
               
        %check dimension OK
        function obj = AutoFill(obj)
            P = size(obj.dates); P = P(1);
            N = size(obj.assets); N = N(2);
            MM = size(obj.data);
            if  P == MM(1)  obj.P = P;  end
            if  N == MM(2)  obj.M = N;  end
        end     %function
        
%         %constructor,  Excel -> putmatrix argin -> 
%         % how to reload?
        function obj = TsMatrix(argin, Y0, X0)           
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
            
        %TODO: 
        function obj = AddVector( v )
            %�ȶ���ʱ��
            
            %�ٲ�������            
        end %function
    
        
    end %methods
    
    
     %% static tools
    methods (Access = 'public', Static = true, Hidden = false)
        mergedTsm = Merge(tsm1, tsm2);
    end
end

