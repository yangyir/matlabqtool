classdef BookMonitor < handle
    % BookMonitor 包含一本Book，和一系列阈值
    
    properties
        book@Book
        dollarTheta = nan;
        dollarVega = nan;
        dollarDelta = nan;
        dollarGamma = nan;
        ATMiv = nan;
        needChecking@logical = false;
        
        % risks VaR
        risk_dollar_delta = 0;
        risk_dollar_gamma = 0;
        risk_dollar_theta = 0;
        risk_dollar_vega = 0;
    end
    
    methods
        function [obj] = BookMonitor(book)
            if isa(book, 'Book')
                obj.book = book;
            else
                disp(' ctor need a book parameter.');
            end
        end        
                
        function [obj] = set.dollarDelta(obj, val)
            %function [obj] = set.dollarDelta(obj, val)
            obj.dollarDelta = val;
            obj.needChecking = true;
        end
        
        function [obj] = set.dollarGamma(obj, val)
            %function [obj] = set.dollarGamma(obj, val)
            obj.dollarGamma = val;
            obj.needChecking = true;
        end
        
        function [obj] = set.dollarVega(obj, val)
            %function [obj] = set.dollarVega(obj, val)
            obj.dollarVega = val;
            obj.needChecking = true;
        end
               
        function [] = update_env(obj, S, vs, r)
            %function [] = update_env(obj, S, vs, r)
            obj.book.update_struct_env(S, vs, r);
        end
        
        function [obj] = setDDelta(obj, val)
            %function [obj] = setDDelta(obj, val)
            obj.dollarDelta = val;
        end
        
        function [obj] = setDGamma(obj, val)
            %function [obj] = setDGamma(obj, val)
            obj.dollarGamma = val;
        end
        
        function [risk_delta] = getRiskDelta(obj)
            %function [risk_delta] = getRiskDelta(obj)
            risk_delta = obj.risk_dollar_delta;
        end
        
        function [risk_gamma] = getRiskGamma(obj)
            %function [risk_gamma] = getRiskGamma(obj)
            risk_gamma = obj.risk_dollar_gamma;
        end
        
        function [risk_theta] = getRiskTheta(obj)
            %function [risk_theta] = getRiskTheta(obj)
            risk_theta = obj.risk_dollar_theta;
        end
        
        function [risk_vega] = getRiskVega(obj)
            %function [risk_vega] = getRiskVega(obj)
            risk_vega = obj.risk_dollar_vega;
        end
        
        function [alert] = check_risks(obj)
            % [alert] = check_risks(obj)
            % 检查是否触发阈值。
            if ~obj.needChecking
                alert = false;
                return;
            else
                obj.book.calc_risks();
                obj.risk_dollar_delta = obj.book.get_book_delta1;
                obj.risk_dollar_gamma = obj.book.get_book_gamma1;
                obj.risk_dollar_theta = obj.book.get_book_theta1;
                obj.risk_dollar_vega = obj.book.get_book_vega1;
                
                if ~isnan(obj.dollarDelta)                    
                    if abs(obj.risk_dollar_delta) >= obj.dollarDelta
                        alert = true;
                        fprintf(2, 'Delta 告警 : %s, %0.3f !!!\n', obj.book.trader, obj.risk_dollar_delta);
                    end
                end
                
                if ~isnan(obj.dollarVega)                    
                    if abs(obj.risk_dollar_vega) >= obj.dollarVega
                        alert = true;
                        fprintf(2, 'Vega 告警 ：%s, %0.3f !!!\n', obj.book.trader, obj.risk_dollar_vega);
                    end
                end
                
            end
        end
                
    end
end