classdef (Sealed) Calendar_Test < handle
    % Calendar Ӧ������Ϊһ���������ڡ�����ڼ������ã��Դ˼��㽻���ռ����
    properties (Access = 'private')
        holidays_ ; 
        ots;
        cts;
        T930 = datenum(2016, 1,1, 9, 30,0) - datenum(2016, 1, 1);
        T1130 = (11 * 60 + 30)/ 60 / 24;
        T1300 = 13 / 24;
        T1500 = 15 / 24;

          %[ ...         
%           '2016-1-1'; ...% Ԫ��3��
%           '2016-1-2'; ...% 2016-1-2
%           '2016-1-3'; ...% 2016-1-3
%           '2016-2-7'; ...% ����7��
%           '2016-2-8'; ...
%           '2016-2-9'; ...
%           '2016-2-10'; ...
%           '2016-2-11'; ...
%           '2016-2-12'; ...
%           '2016-2-13'; ...
%           '2016-4-3'; ...% ���� 3��
%           '2016-4-4'; ...
%           '2016-4-5'; ...
%           '2016-5-1'; ...%�Ͷ���3��
%           '2016-5-2'; ...
%           '2016-5-3'; ...
%           '2016-6-9'; ...%�����3��
%           '2016-6-10';...
%           '2016-6-11';...
%           '2016-9-15'; ...%�����3��
%           '2016-9-16'; ...
%           '2016-9-17'; ...
%           '2016-10-1'; ...%�����7��
%           '2016-10-2'; ...
%           '2016-10-3'; ...
%           '2016-10-4'; ...
%           '2016-10-5'; ...
%           '2016-10-6'; ...
%           '2016-10-7'; ...
%         ];

        currentDate;
        T;
        tauInterday;  % �껯  1*4 , ÿ��ֻ����һ�Σ�initʱ��
        tauIntraday;  % �껯  1*1�� ��ʱ����
        tauPrecise;   % �껯�� == tauInterday + tauIntraday,  1*4�� ��ֵ�����е�quoteopt.tau
    end
    methods (Access = 'private', Hidden = true)
        function obj = Calendar_Test()
        obj.holidays_ = ...         
         ['2016-01-01';...% Ԫ��3��
          '2016-01-02';...% 2016-1-2
          '2016-01-03';...% 2016-1-3
          '2016-02-07';...% ����7��
          '2016-02-08';...
          '2016-02-09';...
          '2016-02-10';...
          '2016-02-11';...
          '2016-02-12';...
          '2016-02-13';...
          '2016-04-03';...% ���� 3��
          '2016-04-04';...
          '2016-04-05';...
          '2016-05-01';...%�Ͷ���3��
          '2016-05-02';...
          '2016-05-03';...
          '2016-06-09';...%�����3��
          '2016-06-10';...
          '2016-06-11';...
          '2016-09-15';...%�����3��
          '2016-09-16';...
          '2016-09-17';...
          '2016-10-01';...%�����7��
          '2016-10-02';...
          '2016-10-03';...
          '2016-10-04';...
          '2016-10-05';...
          '2016-10-06';...
          '2016-10-07';...          
          '2017-01-02';...%Ԫ��
          '2017-01-27';...%����
          '2017-01-30';...
          '2017-01-31';...
          '2017-02-01';...
          '2017-02-02';...
          '2017-04-03';...%������
          '2017-04-04';...
          '2017-05-01';...%�Ͷ���
          '2017-05-29';...%�����
          '2017-05-30';...
          '2017-10-02';...%����+����
          '2017-10-03';...
          '2017-10-04';...
          '2017-10-05';...
          '2017-10-06';...
        ];            
        end
    end
    
    methods (Access = 'public', Static = true)
        function singleObj = GetInstance()
            persistent localObj;
            if(isempty(localObj) || ~isvalid(localObj))
                localObj = Calendar_Test;
            end
            singleObj = localObj;
        end
    end
    
    methods (Access = 'public')
        function obj = load_holidays(obj, holidays)
            obj.holidays_ = holidays;
        end
        
%         function [expiration_times] = ETFexpirationTimes(obj, current)
%             current_year = year(current);
%             % �жϵ����Ƿ��ѹ������գ���������ԼΪ���º�Լ��
%             if current > obj.expirationETFopt(month(current), year(current))
%                 current_month = month(current) + 1;
%             else
%                 current_month = month(current);
%             end
%             expiration_times(1) = obj.expirationETFopt(current_month, current_year);
%             next_month = current_month + 1;
%             expiration_times(2) = obj.expirationETFopt(next_month, current_year);
%             next_quarter_month = 0;
%             
%         end
        
        function [ datnum, datestr ] = expirationETFopt(obj, mm,yyyy)
            %function [ datnum, datestr ] = expirationETFopt(obj, mm,yyyy)
            %50ETF��Ȩ�����գ������·ݵĵ��ĸ����������������ڼ���˳�ӣ�
            [datnum, datestr] = obj.nth_week_date(4, 'wed', mm, yyyy);
        end
        
        function [ datnum, datestr ] = expirationIF(obj, mm, yyyy)
            %function [ datnum, datestr ] = expirationIF(obj, mm, yyyy)
            % ��ָ�ڻ������գ���Լ�����·ݵĵ���������,�����ҷ�������˳��
            [datnum, datestr] = obj.nth_week_date(3, 'fri', mm, yyyy);            
        end
        
        
        % Qtool �е�ʵ���п�����⺯����
        % ToDo���㽻���ռ��
        function [num_years] = trading_days_precise_annualised(obj, start_time, end_time, holidays)
            %function [num_years] = trading_days_precise_annualised(obj, start_time, end_time, holidays)
            if ~exist('holidays', 'var')
                holidays = obj.holidays_;
            end
            % ���껯���ʱ������
            % ȡ�����յ�ʱ�䵱��Ľ�������Ŀ�ľ�ֵ
            
            days_of_year = obj.calc_trading_days_of_year(start_time, end_time);
            num_years = obj.trading_days_precise(start_time, end_time, holidays) / days_of_year ;
            
        end
        
        function [days_of_year] = calc_trading_days_of_year(obj, start_time, end_time)
            %function [days_of_year] = calc_trading_days_of_year(obj, start_time, end_time)
            start_year_days = obj.trading_days(datenum(year(start_time), 1, 1), datenum(year(start_time), 12, 31));
            end_year_days = obj.trading_days(datenum(year(end_time), 1, 1), datenum(year(end_time), 12, 31));
            avg_year_days = (start_year_days + end_year_days) / 2;
            days_of_year = avg_year_days;
        end
        
        function [num_days] = trading_days_precise(obj, start_time, end_time, holidays)
            %function [num_days] = trading_days_precise(obj, start_time, end_time, holidays)
            if ~exist('holidays', 'var')
                holidays = obj.holidays_;
            end
            ttt = obj.trading_fraction_day(start_time);
            num_days = days252bus(start_time, end_time, holidays) + ttt;
        end
        
        function [fraction_day] = trading_fraction_day(obj, start_time)
            %function [fraction_day] = trading_fraction_day(obj, start_time)
            tt = start_time - floor(start_time);
            ttt = min(max(tt - obj.T930 , 0), 2/24) + min( max((tt - obj.T1300), 0), 2/24);
            fraction_day = ttt * 6;            
        end
        
        function [num_days] = trading_days(obj, start_time, end_time, holidays)
            %function [num_days] = trading_days(obj, start_time, end_time, holidays)
            if ~exist('holidays', 'var')
                holidays = obj.holidays_;
            end
            
            num_days = days252bus(start_time, end_time, holidays);
        end

        % ����Ȼ�ռ�����껯
        function [num_years] = nature_days_precise_annualised(obj, start_time, end_time)
            %function [num_years] = nature_days_precise_annualised(obj, start_time, end_time)
            num_years = obj.nature_days_precise(start_time, end_time) / 365;
        end
        
        % ������Ȼ�ռ��
        function [num_days] = nature_days_precise(obj, start_time, end_time)
            %function [num_days] = nature_days_precise(obj, start_time, end_time)
            num_days = datenum(end_time) - datenum(start_time);
        end

        function [num_days] = nature_days(obj, start_time, end_time)
            %function [num_days] = nature_days(obj, start_time, end_time)
            num_days = floor(datenum(end_time)) - floor(datenum(start_time));
        end

        % ����ڼ����ܼ�
        function [date, date_str] = nth_week_date(obj, n, wkday, mm, yyyy)
            %function [date, date_str] = nth_week_date(obj, n, wkday, mm, yyyy)
            % ����ڼ����ܼ�
            if ~exist('yyyy', 'var'),   yyyy = year(now); end
            if ~exist('mm', 'var'),     mm = month(now); end
            
            if isa(yyyy, 'char')
                yyyy = str2double(yyyy);
                if yyyy < 100
                    yyyy = 2000+yyyy;
                end
            end
            
            if isa(mm, 'char')
                mm = str2double(mm);
                if mm<0 || mm>12
                    disp('����mmӦΪ 1 - 12 ');
                    return;
                end
            end
            
            
            if isa(wkday, 'double')
                k = floor(wkday); %ֱ�Ӿ���������
                if k>7 || k<=0
                    disp('����: weekday ӦΪ 1 - 7');
                    return;
                end
            end
            
            if isa(wkday, 'char')
                switch wkday
                    case{'Sun', 'sun', 'Sunday', 'sunday'}
                        k = 1;
                    case{ 'Mon', 'mon'}
                        k = 2;
                    case{'Tue', 'tue'}
                        k = 3;
                    case{'Wed', 'wed'}
                        k = 4;
                    case{'Thu', 'thu'}
                        k = 5;
                    case{'Fri', 'fri'}
                        k = 6;
                    case{'Sat', 'sat'}
                        k = 7;
                    otherwise
                        fprintf('����weekday = %s ����ʶ��', wkday);
                        return;
                end
            end
            
            date = nweekdate(n,k,yyyy,mm);
            date_str = datestr(date);            
        end
    end
    
end