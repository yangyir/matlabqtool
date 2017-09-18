classdef SingleAsset < Matrix2DBase
%SINGLEASSET assembles timeseries vectors of a single asset.
% �����ڵ�һ�ʲ����ж�����ԣ�����һ��
% �����ݿɿ�������һά�ģ�ֻ�Ƕ��һά������һ��
%         assetname       %single asset name
%         assetcode       %single asset code
%         des             %description
%         tstypes         %time series types, 1*N cell array
%         dates           %T*1 vector
%         data            %assemble of ts vectors, ��ά�� T*N
% -------------
% �̸�
% �̸գ�20150517������˸���Matrix2DBase��
%     �ܶ�propertiesӦ��ɾȥ�ˣ�����Ϊ�д�����Ȼ�þ���д�ģ������ݲ�ɾȥ��ֻ������



    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        dates           %T*1 vector
    end
    
    
    % ���и��࣬��Ҫ������Щ��
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = true)
        assetname       %single asset name, ����
        assetcode       %single asset code������
        tstypes         %time series types, 1*N cell array

        T = 0          % #dates 
        N = 0          % #tstypes
    end     %properties
    
    
%     % ���������е����ԣ�matlab����������
%     properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
%         des             %description
%         data            %assemble of ts vectors, T*N
%     end     %properties
    
    
    %%
    methods (Access = 'public', Static = false, Hidden = false)        
        %constructor,  Excel -> putmatrix argin -> 
        % how to reload?
        function obj = SingleAsset(argin, Y0, X0) 
            % ������Matrix2DBase�е����Ը�ֵ
            obj.des3    = '��һ�ʲ��Ķ��ʱ�����У�����ʱ�䣬�������';
            obj.xLabel  = '�������ƣ�1*Nx Cell';
            obj.yLabel  = 'ʱ������ڣ�Ny*1 Cell';
            
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

