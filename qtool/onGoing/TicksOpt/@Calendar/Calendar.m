classdef Calendar
    %CALENDAR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Access = 'public', Static = true, Hidden = false)
        % 取得和存储数据
        
        
        
        
        
        % 计算日期
        % xx月的第n个星期daystr
        [ datnum ] = nthWeekdayOfMonth(n, daystr, mm, yyyy);
        
        
        
        
        
        
       
        
        
        % 计算时间间隔的
        [ n ] = daysNonWeekend(startDate, endDate);
        
        
        % 利用DH聚源的函数
        [ n ] = dhDaysTrading( startDate, endDate, market);
        
    end
    
    
    %% 实用函数
    methods(Access = 'public', Static = true, Hidden = false)
        
        function [ datnum ] = expirationETFopt( mm,yyyy)
            %50ETF期权到期日：到期月份的第四个星期三（遇法定节假日顺延）
            datnum = Calendar.nthWeekdayOfMonth(4, 'wed', mm, yyyy);
        end
        
        function [ datnum ] = expirationIF(mm, yyyy)
            % 股指期货到期日：合约到期月份的第三个周五,遇国家法定假日顺延
            datnum = Calendar.nthWeekdayOfMonth(3, 'fri', mm, yyyy);            
        end
        
        
    end
    
end

