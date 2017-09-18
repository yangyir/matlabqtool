classdef VolSurf < handle
    % Vol Surface  ��Ϊһ���ض�Ŀ�ĵ�Surface
    % ����������SmileSection��һ��TermStructure���
    %--------------------------------
    % �콭 20170615
    % ���Ʒ� 20170616 smile�Ƚ���ͼ���� plot_atmImpvol_smile
    % ���Ʒ� 20170616 termstrucutre plot_atmImpvol_termStrucutre
    % ���Ʒ� 20170623 [ hFig ] = plot_absrela_smitermsurf_oripoint(obj, abs_rela, smitermsurf, oripoint, hFig, varargin);
    
    properties
        des;
        smiles_@SmileSection = SmileSection;
        termstructure_@TermStructure = TermStructure;
    end
    
    properties
        % raw data storage
        tau_value_ = [];
        m_value_ = []; % Moneyness series; Moneyness, Money_tau, Money_shift;
        z_value_ = []; % raw value. 
    end
    
    methods
        function obj = VolSurf(des_)
            if ~exist('des_', 'var')
                des_ = 'call';
            end
            obj.des = des_;
        end
        
        function [value] = calculate(obj, x_val, tau_val)
            %function [value] = calculate(obj, x_val, tau_val)
            % value = value_0 + f(x_val) + g(tau_val)

            gvalue = obj.atm_vol(tau_val);
            
            % select a smile
            smile_num = length(obj.smiles_);
            id = find(sort([obj.smiles_.unique_val, tau_val]) == tau_val);
            if id == 1 
                fvalue = obj.smiles_(1).calculate(x_val);
            elseif id > smile_num
                fvalue = obj.smiles_(smile_num).calculate(x_val);
            else
                % tau_val ������Smile֮��
                fit_arg_1 = obj.smiles_(id - 1).fit_args_;
                fit_arg_2 = obj.smiles_(id).fit_args_;
                fit_arg = (fit_arg_1 + fit_arg_2 )./2;
                fvalue = polyval(fit_arg, x_val);
            end           

            value = gvalue + fvalue ;
        end
        
        function [atmvol] = atm_vol(obj, tau_val)
            atmvol = obj.termstructure_.calculate(tau_val);
        end
        
        function [nearatm] = nearATM(obj)
            nearatm = obj.termstructure_.calculate(obj.tau_value_(1));
        end
        
        [diffobj] = diff_volsurf(obj, cmp_surf); 
        
        function [obj] = load_data(obj, m2tk_opt_quotes)
            % function [obj] = load_data(obj, m2tk_opt_quotes)
            % ����ԭʼ���ݾ���M2TK��ʽ�洢���������ｫ�������ݵĲ�����ΪM2TK���Է���ʹ��
            if ~isa(m2tk_opt_quotes, 'M2TK')
                warning('�������Ͳ���M2TK');
                return;
            end
            
            obj.clear;
            
            % parse and store the values.
            K_num = length(m2tk_opt_quotes.xProps);
            T_num = length(m2tk_opt_quotes.yProps);
            m_num = 1;
            tau_num = 1;
            z_num = 1;
            for t_index = 1 : T_num
                for k_index = 1 : K_num
                    q = m2tk_opt_quotes.data(t_index, k_index);
                    if q.is_valid_opt
                        if ~isnan(q.M_shift)
                            m_shift = q.M_shift;
                        else
                            m_shift = 0;
                        end
                        tau = q.tau;
                        % Z value should be a struct which contains all
                        % info
                        z.m_shift = m_shift;
                        z.tau = tau;
                        z.data = q.impvol;
                        
                        % store the value to properties
                        obj.m_value_(m_num) = m_shift;
                        if z_num == 1
                        obj.z_value_ = z;
                        else
                            obj.z_value_(z_num) = z;
                        end
                        
                        % loop
                        m_num = m_num + 1;
                        z_num = z_num + 1;
                    end                    
                end
                
                if exist('tau', 'var')
                    obj.tau_value_(tau_num) = tau;
                    tau_num = tau_num + 1;
                end
            end
            
            % prepare Smiles
            for tau_index = 1:T_num
                target_tau = obj.tau_value_(tau_index);
                z_id = find([obj.z_value_.tau] == target_tau);
                target_values = obj.z_value_(z_id);
                smile = SmileSection;
                smile.load_data([target_values.m_shift], [target_values.data], target_tau);
                smile.calibrate;
                obj.smiles_(tau_index) = smile;
            end
            
            % prepare TermStructure
            smile_num = length(obj.smiles_);
            taus = 0;
            atmvol = 0;
            for index = 1:smile_num
                smile = obj.smiles_(index);
                taus(index) = smile.unique_val;
                atmvol(index) = smile.zero_val;
            end
            
            ts = TermStructure;
            ts.load_data(taus, atmvol, 0);
            ts.calibrate;
            obj.termstructure_ = ts;
        end
        
        function [obj] = clear(obj)
            % clear current data;
            obj.tau_value_ = [];
            obj.m_value_ = []; 
            obj.z_value_ = [];
            
            % clear smiles and termstructure;
            obj.smiles_ = SmileSection;
            obj.termstructure_ = TermStructure;
        end
        
        % smile�Ƚ���ͼ����
        [ hFig ] = plot_Impvol_smile(obj);
        [ hFig ] = plot_compare_volsurf(obj, t, type, varargin);
        % termstrucutre
        [ hFig ] = plot_atmV_termStrucutre(obj);
        [ hFig ] = plot_atmV_compare_termStrucutre(obj, type, varargin);
        % ����|���|������� smiles|terms|surf ԭʼ��|��ϵ�|ԭʼ��ϵ�
        % abs_rela: absolute relative
        % smitermsurf: smiles terms surf
        % oripoint: origiԭʼ�� fit��ϵ� origifitԭʼ��ϵ�
        % hFig ��ͼ��figure���������
        % varargin �����������
        [ hFig ] = plot_absrela_smitermsurf_oripoint(obj, abs_rela, smitermsurf, oripoint, hFig, varargin);
    end
    
end