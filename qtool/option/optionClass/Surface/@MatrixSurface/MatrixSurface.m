% Surface ��Ϊ���ࣨx,y,Z�������ṩ��ֵ�ͻ��Ʒ���
% Surface ��ZΪ��ֵ�����������ڶ����ݶ���ˣ�ʹ���о�ʵ����������ã���
% ���M2TK�ṩ�ض�ת������
% ����������ߵĲ�����
% �ṩ�����ϸ���ȡֵ�ļ��㷽��

classdef MatrixSurface < Matrix2DBase
    properties
        N_fit_exponent = 2;
        x_fit_args = [];
        y_fit_args = [];
    end
    methods
        % ���캯��:K��������T������
        function surf = MatrixSurface( surf_name, x_name, y_name)
            %function surf = Surface( surf_name, x_name, y_name)
                        
            % �����Ա���
            surf.des = surf_name;
            surf.xLabel = x_name;
            surf.yLabel = y_name;
                                    
            % x�������
            surf.Nx = 0; 
            
            % y�������
            surf.Ny = 0;   
                        
            % X�����������
            surf.xProps = 0;
            
            % Y�����������
            surf.yProps = 0;            
        end
        
        function [obj] = load_data(obj, x_val, y_val, data_val)
            %function [obj] = load_data(x_val, y_val, data_val)            
            % X Y����Ҳ����Ϊ����X�������ݶ�Ӧ data_val ��ͬ�е�dataֵ
            % Y �������ݶ�Ӧ data_val ��ͬ�е�data ֵ
            % ���� Iv(M, tau)���������棬M���ڸ�����Լ��˵��һ���仯ֵ
            % У�����������
            
            x_len = length(x_val);
            y_len = length(y_val);
            [rows, cols] = size(data_val);
            if rows ~= y_len || cols ~= x_len
                warning('������������ƥ��');
                return;
            end
            
            obj.xProps = x_val;
            obj.yProps = y_val;
            obj.Nx = cols;
            obj.Ny = rows;
            obj.data = data_val;
        end        
        
        function [obj] = calibrate(obj)
            for index_y = 1:obj.Ny                
                rowvec = obj.data(index_y, :);
                % ��ȥ��Ч��
                valid_idx = find(~isnan(rowvec));
                x_axes = obj.xProps(valid_idx);
                rowvec = rowvec(valid_idx);
                obj.y_fit_args(index_y,:) = polyfit(x_axes, rowvec, obj.N_fit_exponent);
            end
            
            for index_x = 1:obj.Nx
                colvec = obj.data(:, index_x)';
                % ��ȥ��Ч��
                valid_idx = find(~isnan(colvec));
                y_axes = obj.yProps(valid_idx);
                colvec = colvec(valid_idx);
                obj.x_fit_args(index_x, :) = polyfit(y_axes, colvec, obj.N_fit_exponent);
            end
        end
        
        % TODO: check the logic with CG.
        function [val] = calculate_by_curve(x_val, y_val, val_0)
            % function [val] = calculate(x_val, y_val, val_0)
            % val = val_0 + f(x_val) + g(y_val) + e(x,y); �˴�����e(x,y)��
            if ~exist(val_0, 'var')
                val_0 = 0;
            end
            % ����X������Y
            % z = z0 + f(x) + g(y) + e(x,y); �˴�����e(x,y)
            % ϵ��ȡ��������ľ�ֵ
            MX_diff = bsxfun(@minus, obj.xProps, x_val);
            [xdiff, minId] = min(abs(MX_diff));
            %id < min or id > max ��ǡ��Ϊ������
            if xdiff < 0.0001 || (minId == 1 || minId == obj.Nx)
                y_args = obj.y_fit_args(minId, :);
            else
                if obj.xProps(minId) > x_val
                    minOffset = minId - 1;
                else
                    minOffset = minId + 1;
                end
                y_args1 = obj.y_fit_args(minOffset , :);
                y_args2 = obj.y_fit_args(minId, :);
                y_args = (y_args1 + y_args2)./2;
            end
            
            val_x = polyval(y_args, x_val);
            
            MY_diff = bsxfun(@minus, obj.yProps, y_val);
            [ydiff, minId] = min(abs(MY_diff));
            %id < min or id > max ��ǡ��Ϊ������
            if ydiff < 0.0001 || (minId == 1 || minId == obj.Nx)
                x_args = obj.x_fit_args(minId, :);
            else
                if obj.yProps(minId) > y_val
                    minOffset = minId - 1;
                else
                    minOffset = minId + 1;
                end
                x_args1 = obj.y_fit_args(minOffset , :);
                x_args2 = obj.y_fit_args(minId, :);
                x_args = (x_args1 + x_args2)./2;
            end
            
            val_y = polyval(x_args, y_val);
            
            val = val_0 + val_x + val_y;
        end
        
        function [val] = calculate_by_interp2d(x_val, y_val, val_0)
            %function [val] = calculate_by_interp2d(x_val, y_val, val_0)
            
        end
    end

end