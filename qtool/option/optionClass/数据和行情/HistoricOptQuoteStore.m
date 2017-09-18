classdef HistoricOptQuoteStore < ArrayBase
    % HistoricQuoteStore �洢һ�ζ�������ʷ�������ݡ�
    % ��ʵ��֮����������Ӱ�죬Ӧ��Ϊ�������顣
    properties
        node = QuoteOpt;
        optCode@char;
        optName@char;
        currentDate;
        day_pos;
        current_start_pos@double = 0;
        current_end_pos@double = 0;
    end
    
    
    methods        
        function [obj] = HistoricOptQuoteStore(opt_code, opt_name)
            if ~exist('opt_code', 'var')
                opt_code = '00000000';
            end
            
            if ~exist('opt_name', 'var')
                opt_name = '������Ȩ';
            end
            obj.optCode = opt_code;
            obj.optName = opt_name;            
            obj.node = QuoteOpt;            
            obj.currentDate = today;
            day_pos = 0;
            current_start_pos = 0;
            current_end_pos = 0;
        end
        
        function set.optCode(self, opt_code)
            if isa(opt_code, 'char')
                self.optCode = opt_code;
            else
                warning('��ֵʧ�ܣ����ʹ���');
            end
        end
        
        function set.optName(self, opt_name)
            if isa(opt_name, 'char')
                self.optName = opt_name;
            else
                warning('��ֵʧ�ܣ����ʹ���');
            end
        end
        
        function set.node(self, node)
            if isa(node, 'QuoteOpt')
                code = node(end).code;
                if (strcmp(code, self.optCode))
                    self.node = node;
                else
                    % ���loadʱ��յ�����򲹶��������е�󣬲���û�뵽�÷�����
                    if 0 == self.latest
                        node.code = self.optCode;
                        node.optName = self.optName;
                    else
                        warning('��ֵʧ�ܣ���ָ����Լ');
                    end
                end
            else
                warning('��ֵʧ�ܣ����ʹ���');
            end
        end
        
        function [success] = UpdateQuote(obj, quote)
            % ���ʱ���
            % �Ա�ĩβʱ����͵�ǰʱ��������б仯����Ϊ����Ч���¡�
            success = 0;
            if ~strcmp(obj.node(end).quoteTime, quote.quoteTime)
                q = quote.getCopy();
                q.quoteTime = now;
                obj.push(q);                
                obj.addto_end_pos(1);
                success = 1;
            end
        end
        
        function [] = atomic_settle_prev_pos(obj, num)
            % ά��������������ʱ�Ķ�дָ��ά��
            obj.current_start_pos = obj.current_start_pos + num;
            obj.current_end_pos = obj.current_end_pos + num;
        end
        
        function [] = addto_end_pos(obj, num)
            if obj.current_start_pos == 0
                obj.current_start_pos = 1;
            end
            obj.current_end_pos = obj.current_end_pos + num;
        end
        
        function merge_prev_quote(obj, prev_store)
            % ����֮ǰ�յ���������
            if obj.check_same_asset(prev_store)
                L = length(prev_store);
                obj.push_front(prev_store.node);
            end
        end
        
        function [] = save_currentday_quote(obj, file_name)
            % ȡ���յ����飬�����ļ��С�
            obj.toExcel(file_name, 'historic_quote', obj.current_start_pos, obj.current_end_pos);
        end
        
        function [same_asset] = check_same_asset(obj, other)
            same_asset = strcmp(obj.optCode, other.optCode) && strcmp(obj.optName, other.optName);
        end
        
        function [valid] = is_obj_valid(obj)
            valid = (~strcmp(obj.optName, '������Ȩ'));
        end

        
        % �ṩ���ص�ToTable
        % toFile
        % fromTable
        function [obj] = fromFile(obj, file_name)
            % file �ĽṹӦ��Ϊ��Ʒ����ΪĿ¼����������ΪƷ��Ŀ¼�µ��ļ���
            % ��Ѱ�Ҵ��룬���ж�ʱ�䣬�ٹ�������
            obj.fromExcel(file_name);
        end
        
        function [] = toFile(obj, file_name)
            % ��Ʒ����ΪĿ¼��������Ϊ�ļ������洢
            obj.toExcel(file_name);
        end
        
        % Ӧ���ṩ�����������е���ز��������续ͼ�ȡ�
        function plot_impvol(obj)
            plot([obj.node.impvol]);
        end
    end
end