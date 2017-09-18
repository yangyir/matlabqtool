classdef L2QuoteParser < handle
    % L2�����������
    %��������������������
    % �콭�� 20160327, first issue
    properties
        rPos@double = 0; % ��¼��ȡλ�á�
        step@double = 1; % ÿ�ν���1min�����ݡ�
        fn@char % �����ļ�����
        fid@double % �ļ���������
        quotes % ����Struct. 
        structPrefix@char = 'quoteopt'; % ���ڹ�ƱΪ'quotestk'�� �ڻ�Ϊ'quotefut'
    end
    
    methods
        function [obj] = init(obj, file_name, quotes, type)
            obj.quotes = quotes;
            switch type
                case {'o', 'O', 'opt', 'Opt'}
                    obj.structPrefix = 'quoteopt';
                case {'s', 'S', 'stk', 'Stk'}
                    obj.structPrefix = 'quotestk';
                case {'f', 'F', 'fut', 'Fut'}
                    obj.structPrefix = 'quotefut';
            end
            obj.fid = fopen(file_name);
            if (obj.fid < 0)
                disp('�ļ��޷���');
                return;
            end
            
            % ����Ӧ���ڳ�ʼ����ʱ��ʱ����뵽����ʱ�䡣
            obj.align_to_time( 93000 );
        end
        
        function [obj] = align_to_time(obj, time)
            if ~exist('time', 'var')
                time = 93000;
            end
            
            if isa(time, 'char')
                tv = str2double(time);
            elseif isa(time, 'double')
                tv = time;
            end
            
            % ���취����ͷ��ʼ��ʱ�䡣
            % TODO ��Ϊ���ֲ��ҡ�
            fseek(obj.fid, 0, 'bof');
            
            while ~feof(obj.fid)
                l = fgetl(obj.fid);
                data = regexp(l, ',', 'split');
                t = str2double(data{1});
                if t >= tv
                    return;
                end
                if abs(tv - t) < 10
                    return;
                end
            end 
            
        end
        
        function [obj] = parse(obj)
            % calc end time
            position = ftell(obj.fid);
            if ~feof(obj.fid)
                l = fgetl(obj.fid);
                data = regexp(l,',','split');
                time = data{1};
                end_time = obj.add_time_step(time);
                num_end_time = str2double(end_time);
                fseek(obj.fid, position, 'bof');
            else
                disp('End of File');
                return;
            end
            
            while (~feof(obj.fid) )
                l = fgetl(obj.fid);
                obj.rPos  = obj.rPos + 1;
                
                % ȡ����
                data = regexp(l,',','split');
                code = data{3};
                time = data{1};
                t = str2double(time);
                
                fieldname = [obj.structPrefix,code];
                % �ж��Ƿ�ΪOption
                if (isfield(obj.quotes, fieldname))
                    % �ж�ȫ������
                    if(strcmp('1', data{4}))
                        obj.quotes.(fieldname).fillQuoteL2(l);
                    end
                end
                
                if(strcmp(end_time, time) || (num_end_time - t < 5))
                    break;
                end                
            end
            
        end
        
        function [time] = add_time_step(obj, time)
            timestr = obj.time2str(time);
            dsttimestr = addtotime(obj, timestr);
            time = obj.str2time(dsttimestr);
        end
        
        function [timestr, hour, min, sec] = time2str(obj, time)
            L = length(time);
            min = time((L -4 + 1):(L - 2));
            sec = time((L -2 + 1):end);
            hour = time(1:(L - 4));
            timestr = [hour,':', min, ':',sec];
        end
        
        function [dsttimestr] = addtotime(obj, srctimestr)
            dsttimestr = datestr( addtodate(datenum(srctimestr, 'HH:MM:SS'), obj.step, 'minute'), 'HH:MM:SS');
        end
        
        function [time, hour, min, sec] = str2time(obj, timestr)
            data = regexp(timestr, ':', 'split');
            hour = data{1};
            hour = num2str(str2num(hour));
            min = data{2};
            sec = data{3};
            time = [hour, min, sec];
        end
        
        function [obj] = release(obj)
            fclose(obj.fid);
        end
    end
end