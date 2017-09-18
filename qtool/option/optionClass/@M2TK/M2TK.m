classdef M2TK < Matrix2DBase
%M2TK专用于期权的二维矩阵，横轴是K，纵轴是T
% 注意： data(indexT , indexK) ，先纵轴（行坐标），再横轴（列坐标）
% ---------------------------------------
% 程刚，20160120
% 程刚，20160124，增加了复制构造函数
% 朱江/吴云峰，20170613 增加了plot_quote_surface/plot_tau_m

    
    % 没有加新的域
    properties
        % 重载这个域，语法不允许
        % yProps@cell;
    end

    methods
        
        % 构造函数:K的数量和T的数量
        function m2tk = M2TK( des2 )
            
            if ~exist( 'des2' , 'var' )
                des2 = 'call';
            end 
            
            % 描述性变量
            m2tk.des = '市场上的期权的T，K二维数组';
            % des2用于描述到底是看涨还是看跌期权;
            
            switch des2
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    m2tk.des2 = 'call';
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    m2tk.des2 = 'put';
            end  
            
            % X轴的名称
            m2tk.xLabel = 'K执行价';
            
            % Y轴的名称
            m2tk.yLabel = 'T到期日'; 
            
            % 数据类型是类对象
            m2tk.datatype = 'object';
            
            % x轴的数量
            m2tk.Nx = 0; 
            
            % y轴的数量
            m2tk.Ny = 0;   
            
            % 核心数据
            % 核心数据既可以是OptPricer也可以是OptInfo
            m2tk.data = OptInfo;
            
            % X轴的属性数据
            m2tk.xProps = 0;
            
            % Y轴的属性数据
            m2tk.yProps = {};
            
        end
        
        %  ！语法：不能加载父类属性的setter
%         function obj = set.yProps(value)
%             % yProps, 即uniqueTs， 必须是cell（string）
%             if isa(value, 'cell')
%                 obj.yProps = value;
%             else
%                 
%                 disp('赋值失败，yProps必须是cell类');
%                 return;
%             end
%         end
          

    end
    
    % 将复制构造函数隐藏起来
    methods(Hidden = true)
        
        % 复制构造函数
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