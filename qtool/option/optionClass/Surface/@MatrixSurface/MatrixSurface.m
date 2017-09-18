% Surface 类为各类（x,y,Z）数据提供插值和绘制方法
% Surface 的Z为简单值，不允许用于对象（暂定如此，使用中据实际情况再推敲）。
% 针对M2TK提供特定转换方法
% 计算拟合曲线的参数。
% 提供曲线上个点取值的计算方法

classdef MatrixSurface < Matrix2DBase
    properties
        N_fit_exponent = 2;
        x_fit_args = [];
        y_fit_args = [];
    end
    methods
        % 构造函数:K的数量和T的数量
        function surf = MatrixSurface( surf_name, x_name, y_name)
            %function surf = Surface( surf_name, x_name, y_name)
                        
            % 描述性变量
            surf.des = surf_name;
            surf.xLabel = x_name;
            surf.yLabel = y_name;
                                    
            % x轴的数量
            surf.Nx = 0; 
            
            % y轴的数量
            surf.Ny = 0;   
                        
            % X轴的属性数据
            surf.xProps = 0;
            
            % Y轴的属性数据
            surf.yProps = 0;            
        end
        
        function [obj] = load_data(obj, x_val, y_val, data_val)
            %function [obj] = load_data(x_val, y_val, data_val)            
            % X Y数据也可以为矩阵，X的行数据对应 data_val 相同行的data值
            % Y 的列数据对应 data_val 相同列的data 值
            % 例如 Iv(M, tau)这样的曲面，M对于各个合约来说是一个变化值
            % 校验矩阵行列数
            
            x_len = length(x_val);
            y_len = length(y_val);
            [rows, cols] = size(data_val);
            if rows ~= y_len || cols ~= x_len
                warning('矩阵行列数不匹配');
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
                % 除去无效数
                valid_idx = find(~isnan(rowvec));
                x_axes = obj.xProps(valid_idx);
                rowvec = rowvec(valid_idx);
                obj.y_fit_args(index_y,:) = polyfit(x_axes, rowvec, obj.N_fit_exponent);
            end
            
            for index_x = 1:obj.Nx
                colvec = obj.data(:, index_x)';
                % 除去无效数
                valid_idx = find(~isnan(colvec));
                y_axes = obj.yProps(valid_idx);
                colvec = colvec(valid_idx);
                obj.x_fit_args(index_x, :) = polyfit(y_axes, colvec, obj.N_fit_exponent);
            end
        end
        
        % TODO: check the logic with CG.
        function [val] = calculate_by_curve(x_val, y_val, val_0)
            % function [val] = calculate(x_val, y_val, val_0)
            % val = val_0 + f(x_val) + g(y_val) + e(x,y); 此处忽略e(x,y)项
            if ~exist(val_0, 'var')
                val_0 = 0;
            end
            % 先算X，后算Y
            % z = z0 + f(x) + g(y) + e(x,y); 此处忽略e(x,y)
            % 系数取相邻两组的均值
            MX_diff = bsxfun(@minus, obj.xProps, x_val);
            [xdiff, minId] = min(abs(MX_diff));
            %id < min or id > max 或恰好为采样点
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
            %id < min or id > max 或恰好为采样点
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