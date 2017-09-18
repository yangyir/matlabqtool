classdef M2TK < Matrix2DBase
%M2TKר������Ȩ�Ķ�ά���󣬺�����K��������T
% ע�⣺ data(indexT , indexK) �������ᣨ�����꣩���ٺ��ᣨ�����꣩
% ---------------------------------------
% �̸գ�20160120
% �̸գ�20160124�������˸��ƹ��캯��
% �콭/���Ʒ壬20170613 ������plot_quote_surface/plot_tau_m

    
    % û�м��µ���
    properties
        % ����������﷨������
        % yProps@cell;
    end

    methods
        
        % ���캯��:K��������T������
        function m2tk = M2TK( des2 )
            
            if ~exist( 'des2' , 'var' )
                des2 = 'call';
            end 
            
            % �����Ա���
            m2tk.des = '�г��ϵ���Ȩ��T��K��ά����';
            % des2�������������ǿ��ǻ��ǿ�����Ȩ;
            
            switch des2
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    m2tk.des2 = 'call';
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    m2tk.des2 = 'put';
            end  
            
            % X�������
            m2tk.xLabel = 'Kִ�м�';
            
            % Y�������
            m2tk.yLabel = 'T������'; 
            
            % ���������������
            m2tk.datatype = 'object';
            
            % x�������
            m2tk.Nx = 0; 
            
            % y�������
            m2tk.Ny = 0;   
            
            % ��������
            % �������ݼȿ�����OptPricerҲ������OptInfo
            m2tk.data = OptInfo;
            
            % X�����������
            m2tk.xProps = 0;
            
            % Y�����������
            m2tk.yProps = {};
            
        end
        
        %  ���﷨�����ܼ��ظ������Ե�setter
%         function obj = set.yProps(value)
%             % yProps, ��uniqueTs�� ������cell��string��
%             if isa(value, 'cell')
%                 obj.yProps = value;
%             else
%                 
%                 disp('��ֵʧ�ܣ�yProps������cell��');
%                 return;
%             end
%         end
          

    end
    
    % �����ƹ��캯����������
    methods(Hidden = true)
        
        % ���ƹ��캯��
        [ newobj ] = getCopy( obj );
        
    end
    
    methods
        % plot K_Z / T_Z
        [  ] = plot_surface(obj, type);
        % val_type : impvol, delta, gamma, theta, vega.etc
        % plot_type : K_Z , T_Z , 3D
        [ ] = plot_quote_surface(obj, z_val_fieldname, plot_type);
        % z_val_fieldname : impvol, delta, gamma, theta, vega.etc
        % plot_type : m_Z , tau_Z , 3D
        % m_type : M, M_tau, M_shift, Z
        [ ] = plot_quote_surf_tau_m(obj, z_val_fieldname, plot_type, m_type);
        [ ] = plot_tau_m(obj);
    end
    
end